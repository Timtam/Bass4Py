from cpython.mem cimport PyMem_Malloc, PyMem_Free
from libc.string cimport memmove
from . cimport bass
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

    dev = bass.BASS_ChannelGetDevice(self._channel)
    
    bass.__Evaluate()
    
    if dev == bass._BASS_NODEVICE:
      self._device = None
    else:
      self._device = OutputDevice(dev)

  cdef void _initattributes(Channel self):

    ChannelBase._initattributes(self)

    self.Buffer = Attribute(self._channel, bass._BASS_ATTRIB_BUFFER)
    self.CPU = Attribute(self._channel, bass._BASS_ATTRIB_CPU, True)
    self.Ramping = Attribute(self._channel, bass._BASS_ATTRIB_NORAMP)

    IF UNAME_SYSNAME == "Windows":
      self.EAXMix = Attribute(self._channel, bass._BASS_ATTRIB_EAXMIX)
    ELSE:
      self.EAXMix = Attribute(self._channel, bass._BASS_ATTRIB_EAXMIX, False, True)

  cdef DWORD _getflags(Channel self):
    return bass.BASS_ChannelFlags(self._channel, 0, 0)

  cpdef _setflags(Channel self, DWORD flag, bint switch):
    if switch:
      bass.BASS_ChannelFlags(self._channel, flag, flag)
    else:
      bass.BASS_ChannelFlags(self._channel, 0, flag)
    bass.__Evaluate()

  cpdef Play(Channel self, bint restart):
    cdef bint res
    with nogil:
      res = bass.BASS_ChannelPlay(self._channel, restart)
    bass.__Evaluate()
    return res

  cpdef SetSync(Channel self, Sync sync):
    (<object>sync).Set(self)

  cpdef SetFX(Channel self, FX fx):
    (<object>fx).Set(self)

  cpdef ResetFX(Channel self):
    cdef bint res
    with nogil:
      res = bass.BASS_FXReset(self._channel)
    bass.__Evaluate()
    return res

  cpdef SetDSP(Channel self, DSP dsp):
    dsp.Set(self)

  cpdef Link(Channel self, Channel obj):
    cdef bint res
    res = bass.BASS_ChannelSetLink(self._channel, obj._channel)
    bass.__Evaluate()
    return res

  cpdef Unlink(Channel self, Channel obj):
    cdef bint res
    res = bass.BASS_ChannelRemoveLink(self._channel, obj._channel)
    bass.__Evaluate()
    return res

  cpdef SetPosition(Channel self, QWORD pos, DWORD mode = bass._BASS_POS_BYTE):
    cdef bint res
    with nogil:
      res = bass.BASS_ChannelSetPosition(self._channel, pos, mode)
    bass.__Evaluate()
    return res
  
  cpdef GetTags(Channel self, DWORD tagtype):
    cdef DWORD offset = 0
    cdef DWORD length = 0
    cdef char *res = bass.BASS_ChannelGetTags(self._channel, tagtype)
    
    bass.__Evaluate()
    
    if tagtype == bass._BASS_TAG_ID3V2:
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
      return self._getflags()&bass._BASS_SAMPLE_LOOP == bass._BASS_SAMPLE_LOOP

    def __set__(Channel self, bint switch):
      self._setflags(bass._BASS_SAMPLE_LOOP, switch)

  property Device:
    def __get__(Channel self):
      return self._device

    def __set__(Channel self, OutputDevice dev):
      if dev is None:
        bass.BASS_ChannelSetDevice(self._channel, bass._BASS_NODEVICE)
      else:
        bass.BASS_ChannelSetDevice(self._channel, (<OutputDevice?>dev)._device)

      bass.__Evaluate()

      if not dev:
        self._device = None
      else:
        self._device = (<OutputDevice>dev)

  property Mode3D:
    def __get__(Channel self):
      cdef DWORD mode
      bass.BASS_ChannelGet3DAttributes(self._channel, &mode, NULL, NULL, NULL, NULL, NULL)
      bass.__Evaluate()
      return mode

    def __set__(Channel self, int mode):
      bass.BASS_ChannelSet3DAttributes(self._channel, mode, 0.0, 0.0, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property MinimumDistance:
    def __get__(Channel self):
      cdef float min
      bass.BASS_ChannelGet3DAttributes(self._channel, NULL, &min, NULL, NULL, NULL, NULL)
      bass.__Evaluate()
      return min

    def __set__(Channel self, float min):
      bass.BASS_ChannelSet3DAttributes(self._channel, -1, min, 0.0, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property MaximumDistance:
    def __get__(Channel self):
      cdef float max
      bass.BASS_ChannelGet3DAttributes(self._channel, NULL, NULL, &max, NULL, NULL, NULL)
      bass.__Evaluate()
      return max

    def __set__(Channel self, float max):
      bass.BASS_ChannelSet3DAttributes(self._channel, -1, 0.0, max, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Angle:
    def __get__(Channel self):
      cdef DWORD iangle,oangle
      bass.BASS_ChannelGet3DAttributes(self._channel, NULL, NULL, NULL, &iangle, &oangle, NULL)
      bass.__Evaluate()
      return [iangle, oangle]

    def __set__(Channel self, list angle):
      if len(angle) != 2: raise BassAPIError()
      bass.BASS_ChannelSet3DAttributes(self._channel, -1, 0.0, 0.0, angle[0], angle[1], -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property OuterVolume:
    def __get__(Channel self):
      cdef float outvol
      bass.BASS_ChannelGet3DAttributes(self._channel, NULL, NULL, NULL, NULL, NULL, &outvol)
      bass.__Evaluate()
      return outvol

    def __set__(Channel self, float outvol):
      bass.BASS_ChannelSet3DAttributes(self._channel, -1, 0.0, 0.0, -1, -1, outvol)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Position3D:
    def __get__(Channel self):
      cdef BASS_3DVECTOR pos
      bass.BASS_ChannelGet3DPosition(self._channel, &pos, NULL, NULL)
      bass.__Evaluate()
      return CreateVector(&pos)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR pos
      value.Resolve(&pos)
      bass.BASS_ChannelSet3DPosition(self._channel, &pos, NULL, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Orientation3D:
    def __get__(Channel self):
      cdef BASS_3DVECTOR orient
      bass.BASS_ChannelGet3DPosition(self._channel, NULL, &orient, NULL)
      bass.__Evaluate()
      return CreateVector(&orient)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR orient
      value.Resolve(&orient)
      bass.BASS_ChannelSet3DPosition(self._channel, NULL, &orient, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Velocity3D:
    def __get__(Channel self):
      cdef BASS_3DVECTOR vel
      bass.BASS_ChannelGet3DPosition(self._channel, NULL, NULL, &vel)
      bass.__Evaluate()
      return CreateVector(&vel)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR vel
      value.Resolve(&vel)
      bass.BASS_ChannelSet3DPosition(self._channel, NULL, NULL, &vel)
      bass.__Evaluate()
      bass.BASS_Apply3D()
