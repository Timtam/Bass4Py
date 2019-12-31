from cpython.mem cimport PyMem_Malloc, PyMem_Free
from libc.string cimport memmove
from . cimport bass
from .attribute cimport Attribute
from .channel_base cimport ChannelBase
from .output_device cimport OutputDevice
from .dsp cimport DSP
from .sync cimport Sync
from .vector cimport Vector, CreateVector
from ..constants import ACTIVE
from ..exceptions import BassApiError

cdef class Channel(ChannelBase):

  cdef void __sethandle(Channel self, HCHANNEL handle):
    cdef DWORD dev

    ChannelBase.__sethandle(self, handle)

    dev = bass.BASS_ChannelGetDevice(self.__channel)
    
    bass.__Evaluate()
    
    if dev == bass._BASS_NODEVICE:
      self.__device = None
    else:
      self.__device = OutputDevice(dev)

  cdef void __initattributes(Channel self):

    ChannelBase.__initattributes(self)

    self.Buffer = Attribute(self.__channel, bass._BASS_ATTRIB_BUFFER)
    self.CPU = Attribute(self.__channel, bass._BASS_ATTRIB_CPU, True)
    self.Ramping = Attribute(self.__channel, bass._BASS_ATTRIB_NORAMP)

    IF UNAME_SYSNAME == "Windows":
      self.EAXMix = Attribute(self.__channel, bass._BASS_ATTRIB_EAXMIX)
    ELSE:
      self.EAXMix = Attribute(self.__channel, bass._BASS_ATTRIB_EAXMIX, False, True)

  cdef DWORD __getflags(Channel self):
    return bass.BASS_ChannelFlags(self.__channel, 0, 0)

  cpdef __setflags(Channel self, DWORD flag, bint switch):
    if switch:
      bass.BASS_ChannelFlags(self.__channel, flag, flag)
    else:
      bass.BASS_ChannelFlags(self.__channel, 0, flag)
    bass.__Evaluate()

  cpdef Play(Channel self, bint restart):
    cdef bint res
    with nogil:
      res = bass.BASS_ChannelPlay(self.__channel, restart)
    bass.__Evaluate()
    return res

  cpdef SetSync(Channel self, Sync sync):
    (<object>sync).Set(self)

  cpdef SetFX(Channel self, FX fx):
    (<object>fx).Set(self)

  cpdef ResetFX(Channel self):
    cdef bint res
    with nogil:
      res = bass.BASS_FXReset(self.__channel)
    bass.__Evaluate()
    return res

  cpdef SetDSP(Channel self, DSP dsp):
    dsp.Set(self)

  cpdef Link(Channel self, Channel obj):
    cdef bint res
    res = bass.BASS_ChannelSetLink(self.__channel, obj.__channel)
    bass.__Evaluate()
    return res

  cpdef Unlink(Channel self, Channel obj):
    cdef bint res
    res = bass.BASS_ChannelRemoveLink(self.__channel, obj.__channel)
    bass.__Evaluate()
    return res

  cpdef SetPosition(Channel self, QWORD pos, DWORD mode = bass._BASS_POS_BYTE):
    cdef bint res
    with nogil:
      res = bass.BASS_ChannelSetPosition(self.__channel, pos, mode)
    bass.__Evaluate()
    return res
  
  property Loop:
    def __get__(Channel self):
      return self.__getflags()&bass._BASS_SAMPLE_LOOP == bass._BASS_SAMPLE_LOOP

    def __set__(Channel self, bint switch):
      self.__setflags(bass._BASS_SAMPLE_LOOP, switch)

  property Device:
    def __get__(Channel self):
      return self.__device

    def __set__(Channel self, OutputDevice dev):
      if dev is None:
        bass.BASS_ChannelSetDevice(self.__channel, bass._BASS_NODEVICE)
      else:
        bass.BASS_ChannelSetDevice(self.__channel, (<OutputDevice?>dev).__device)

      bass.__Evaluate()

      if not dev:
        self.__device = None
      else:
        self.__device = (<OutputDevice>dev)

  property Mode3D:
    def __get__(Channel self):
      cdef DWORD mode
      bass.BASS_ChannelGet3DAttributes(self.__channel, &mode, NULL, NULL, NULL, NULL, NULL)
      bass.__Evaluate()
      return mode

    def __set__(Channel self, int mode):
      bass.BASS_ChannelSet3DAttributes(self.__channel, mode, 0.0, 0.0, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property MinimumDistance:
    def __get__(Channel self):
      cdef float min
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, &min, NULL, NULL, NULL, NULL)
      bass.__Evaluate()
      return min

    def __set__(Channel self, float min):
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, min, 0.0, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property MaximumDistance:
    def __get__(Channel self):
      cdef float max
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, NULL, &max, NULL, NULL, NULL)
      bass.__Evaluate()
      return max

    def __set__(Channel self, float max):
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, 0.0, max, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Angle:
    def __get__(Channel self):
      cdef DWORD iangle,oangle
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, NULL, NULL, &iangle, &oangle, NULL)
      bass.__Evaluate()
      return [iangle, oangle]

    def __set__(Channel self, list angle):
      if len(angle) != 2: raise BassApiError()
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, 0.0, 0.0, angle[0], angle[1], -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property OuterVolume:
    def __get__(Channel self):
      cdef float outvol
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, NULL, NULL, NULL, NULL, &outvol)
      bass.__Evaluate()
      return outvol

    def __set__(Channel self, float outvol):
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, 0.0, 0.0, -1, -1, outvol)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Position3D:
    def __get__(Channel self):
      cdef BASS_3DVECTOR pos
      bass.BASS_ChannelGet3DPosition(self.__channel, &pos, NULL, NULL)
      bass.__Evaluate()
      return CreateVector(&pos)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR pos
      value.Resolve(&pos)
      bass.BASS_ChannelSet3DPosition(self.__channel, &pos, NULL, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Orientation3D:
    def __get__(Channel self):
      cdef BASS_3DVECTOR orient
      bass.BASS_ChannelGet3DPosition(self.__channel, NULL, &orient, NULL)
      bass.__Evaluate()
      return CreateVector(&orient)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR orient
      value.Resolve(&orient)
      bass.BASS_ChannelSet3DPosition(self.__channel, NULL, &orient, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Velocity3D:
    def __get__(Channel self):
      cdef BASS_3DVECTOR vel
      bass.BASS_ChannelGet3DPosition(self.__channel, NULL, NULL, &vel)
      bass.__Evaluate()
      return CreateVector(&vel)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR vel
      value.Resolve(&vel)
      bass.BASS_ChannelSet3DPosition(self.__channel, NULL, NULL, &vel)
      bass.__Evaluate()
      bass.BASS_Apply3D()
