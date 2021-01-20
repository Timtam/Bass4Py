from cpython.mem cimport PyMem_Malloc, PyMem_Free
from libc.string cimport memmove

from ..bindings.bass cimport (
  _BASS_ATTRIB_BUFFER,
  _BASS_ATTRIB_CPU,
  _BASS_ATTRIB_EAXMIX,
  _BASS_ATTRIB_NORAMP,
  _BASS_NODEVICE,
  _BASS_POS_BYTE,
  _BASS_SAMPLE_LOOP,
  _BASS_TAG_ID3V2,
  BASS_Apply3D,
  BASS_ChannelFlags,
  BASS_ChannelGet3DAttributes,
  BASS_ChannelGet3DPosition,
  BASS_ChannelGetDevice,
  BASS_ChannelGetTags,
  BASS_ChannelPlay,
  BASS_ChannelRemoveLink,
  BASS_ChannelSet3DAttributes,
  BASS_ChannelSet3DPosition,
  BASS_ChannelSetDevice,
  BASS_ChannelSetLink,
  BASS_ChannelSetPosition,
  BASS_FXReset)

from .attribute cimport Attribute
from .channel_base cimport ChannelBase
from .output_device cimport OutputDevice
from .dsp cimport DSP
from .sync cimport Sync
from .vector cimport Vector, CreateVector
from ..exceptions import BassAPIError

cdef class Channel(ChannelBase):

  cdef void _sethandle(Channel self, HCHANNEL handle):
    cdef DWORD dev

    ChannelBase._sethandle(self, handle)

    dev = BASS_ChannelGetDevice(self._channel)
    
    self._evaluate()
    
    if dev == _BASS_NODEVICE:
      self._device = None
    else:
      self._device = OutputDevice(dev)

  cdef void _initattributes(Channel self):

    ChannelBase._initattributes(self)

    self.Buffer = Attribute(self._channel, _BASS_ATTRIB_BUFFER)
    self.CPU = Attribute(self._channel, _BASS_ATTRIB_CPU, True)
    self.Ramping = Attribute(self._channel, _BASS_ATTRIB_NORAMP)

    IF UNAME_SYSNAME == "Windows":
      self.EAXMix = Attribute(self._channel, _BASS_ATTRIB_EAXMIX)
    ELSE:
      self.EAXMix = Attribute(self._channel, _BASS_ATTRIB_EAXMIX, False, True)

  cdef DWORD _getflags(Channel self):
    return BASS_ChannelFlags(self._channel, 0, 0)

  cpdef _setflags(Channel self, DWORD flag, bint switch):
    if switch:
      BASS_ChannelFlags(self._channel, flag, flag)
    else:
      BASS_ChannelFlags(self._channel, 0, flag)
    self._evaluate()

  cpdef Play(Channel self, bint restart):
    cdef bint res
    with nogil:
      res = BASS_ChannelPlay(self._channel, restart)
    self._evaluate()
    return res

  cpdef SetSync(Channel self, Sync sync):
    (<object>sync).Set(self)

  cpdef SetFX(Channel self, FX fx):
    (<object>fx).Set(self)

  cpdef ResetFX(Channel self):
    cdef bint res
    with nogil:
      res = BASS_FXReset(self._channel)
    self._evaluate()
    return res

  cpdef SetDSP(Channel self, DSP dsp):
    dsp.Set(self)

  cpdef Link(Channel self, Channel obj):
    cdef bint res
    res = BASS_ChannelSetLink(self._channel, obj._channel)
    self._evaluate()
    return res

  cpdef Unlink(Channel self, Channel obj):
    cdef bint res
    res = BASS_ChannelRemoveLink(self._channel, obj._channel)
    self._evaluate()
    return res

  cpdef SetPosition(Channel self, QWORD pos, DWORD mode = _BASS_POS_BYTE):
    cdef bint res
    with nogil:
      res = BASS_ChannelSetPosition(self._channel, pos, mode)
    self._evaluate()
    return res
  
  cpdef GetTags(Channel self, DWORD tagtype):
    cdef DWORD offset = 0
    cdef DWORD length = 0
    cdef char *res = BASS_ChannelGetTags(self._channel, tagtype)
    
    self._evaluate()
    
    if tagtype == _BASS_TAG_ID3V2:
      # first three bytes are ID3
      # two bytes describe the version information of the tag
      # one byte describes the flags
      offset += 6
      # next 4 bytes note the length of the remaining tag
      length |= res[offset] << 21
      length |= res[offset + 1] << 14
      length |= res[offset + 2] << 7
      length |= res[offset + 3]
      offset += 4
      
      return res[:length + 10]

    return res.decode('utf-8')

  property Loop:
    def __get__(Channel self):
      return self._getflags()&_BASS_SAMPLE_LOOP == _BASS_SAMPLE_LOOP

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_SAMPLE_LOOP, switch)

  property Device:
    def __get__(Channel self):
      return self._device

    def __set__(Channel self, OutputDevice dev):
      if dev is None:
        BASS_ChannelSetDevice(self._channel, _BASS_NODEVICE)
      else:
        BASS_ChannelSetDevice(self._channel, (<OutputDevice?>dev)._device)

      self._evaluate()

      if not dev:
        self._device = None
      else:
        self._device = (<OutputDevice>dev)

  property Mode3D:
    def __get__(Channel self):
      cdef DWORD mode
      BASS_ChannelGet3DAttributes(self._channel, &mode, NULL, NULL, NULL, NULL, NULL)
      self._evaluate()
      return mode

    def __set__(Channel self, int mode):
      BASS_ChannelSet3DAttributes(self._channel, mode, 0.0, 0.0, -1, -1, -1.0)
      self._evaluate()
      BASS_Apply3D()

  property MinimumDistance:
    def __get__(Channel self):
      cdef float min
      BASS_ChannelGet3DAttributes(self._channel, NULL, &min, NULL, NULL, NULL, NULL)
      self._evaluate()
      return min

    def __set__(Channel self, float min):
      BASS_ChannelSet3DAttributes(self._channel, -1, min, 0.0, -1, -1, -1.0)
      self._evaluate()
      BASS_Apply3D()

  property MaximumDistance:
    def __get__(Channel self):
      cdef float max
      BASS_ChannelGet3DAttributes(self._channel, NULL, NULL, &max, NULL, NULL, NULL)
      self._evaluate()
      return max

    def __set__(Channel self, float max):
      BASS_ChannelSet3DAttributes(self._channel, -1, 0.0, max, -1, -1, -1.0)
      self._evaluate()
      BASS_Apply3D()

  property Angle:
    def __get__(Channel self):
      cdef DWORD iangle,oangle
      BASS_ChannelGet3DAttributes(self._channel, NULL, NULL, NULL, &iangle, &oangle, NULL)
      self._evaluate()
      return [iangle, oangle]

    def __set__(Channel self, list angle):
      if len(angle) != 2: raise BassAPIError()
      BASS_ChannelSet3DAttributes(self._channel, -1, 0.0, 0.0, angle[0], angle[1], -1.0)
      self._evaluate()
      BASS_Apply3D()

  property OuterVolume:
    def __get__(Channel self):
      cdef float outvol
      BASS_ChannelGet3DAttributes(self._channel, NULL, NULL, NULL, NULL, NULL, &outvol)
      self._evaluate()
      return outvol

    def __set__(Channel self, float outvol):
      BASS_ChannelSet3DAttributes(self._channel, -1, 0.0, 0.0, -1, -1, outvol)
      self._evaluate()
      BASS_Apply3D()

  property Position3D:
    def __get__(Channel self):
      cdef BASS_3DVECTOR pos
      BASS_ChannelGet3DPosition(self._channel, &pos, NULL, NULL)
      self._evaluate()
      return CreateVector(&pos)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR pos
      value.Resolve(&pos)
      BASS_ChannelSet3DPosition(self._channel, &pos, NULL, NULL)
      self._evaluate()
      BASS_Apply3D()

  property Orientation3D:
    def __get__(Channel self):
      cdef BASS_3DVECTOR orient
      BASS_ChannelGet3DPosition(self._channel, NULL, &orient, NULL)
      self._evaluate()
      return CreateVector(&orient)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR orient
      value.Resolve(&orient)
      BASS_ChannelSet3DPosition(self._channel, NULL, &orient, NULL)
      self._evaluate()
      BASS_Apply3D()

  property Velocity3D:
    def __get__(Channel self):
      cdef BASS_3DVECTOR vel
      BASS_ChannelGet3DPosition(self._channel, NULL, NULL, &vel)
      self._evaluate()
      return CreateVector(&vel)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR vel
      value.Resolve(&vel)
      BASS_ChannelSet3DPosition(self._channel, NULL, NULL, &vel)
      self._evaluate()
      BASS_Apply3D()
