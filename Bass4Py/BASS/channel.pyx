from cpython.mem cimport PyMem_Malloc, PyMem_Free
from libc.string cimport memmove
from . cimport bass
from .attribute cimport ATTRIBUTE
from .output_device cimport OUTPUT_DEVICE
from .dsp cimport DSP
from .plugin cimport PLUGIN
from .sample cimport SAMPLE
from .sync cimport SYNC
from .vector cimport VECTOR, VECTOR_Create
from ..constants import CHANNEL_TYPE
from ..exceptions import BassError,BassAPIError

cdef class CHANNEL:
  def __init__(CHANNEL self, HCHANNEL channel):
    self.__channel=channel

    if self.__channel != 0:
      self.__initattributes()

  cdef void __initattributes(CHANNEL self):
    self.Buffer = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_BUFFER)
    self.CPU = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_CPU, True)
    self.Frequency = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_FREQ)
    self.Pan = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_PAN)
    self.Ramping = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_NORAMP)
    self.SRC = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_SRC)
    self.Volume = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_VOL)

    IF UNAME_SYSNAME == "Windows":
      self.EAXMix = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_EAXMIX)

  cdef BASS_CHANNELINFO __getinfo(CHANNEL self):
    cdef BASS_CHANNELINFO info
    cdef bint res
    res=bass.BASS_ChannelGetInfo(self.__channel, &info)
    return info

  cdef DWORD __getflags(CHANNEL self):
    return bass.BASS_ChannelFlags(self.__channel, 0, 0)

  cpdef __setflags(CHANNEL self, DWORD flag, bint switch):
    if switch:
      bass.BASS_ChannelFlags(self.__channel, flag, flag)
    else:
      bass.BASS_ChannelFlags(self.__channel, 0, flag)
    bass.__Evaluate()

  cpdef Play(CHANNEL self, bint restart):
    cdef bint res = bass.BASS_ChannelPlay(self.__channel, restart)
    bass.__Evaluate()
    return res

  cpdef Pause(CHANNEL self):
    cdef bint res = bass.BASS_ChannelPause(self.__channel)
    bass.__Evaluate()
    return res

  cpdef Stop(CHANNEL self):
    cdef bint res = bass.BASS_ChannelStop(self.__channel)
    bass.__Evaluate()
    return res

  cpdef GetLevels(CHANNEL self, float length, DWORD flags):
    cdef int chans = self.Channels
    cdef int i=0
    cdef float *levels
    cdef list plevels=[]
    levels = <float*>PyMem_Malloc(chans * sizeof(float))
    if levels == NULL: return plevels
    bass.BASS_ChannelGetLevelEx(self.__channel, levels, length, flags)
    bass.__Evaluate()
    for i in range(chans):
      plevels.append(levels[i])
    PyMem_Free(<void*>levels)
    return tuple(plevels)

  cpdef Lock(CHANNEL self):
    return bass.BASS_ChannelLock(self.__channel, True)

  cpdef Unlock(CHANNEL self):
    return bass.BASS_ChannelLock(self.__channel, False)

  cpdef SetSync(CHANNEL self, SYNC sync):
    (<object>sync).Set(self)

  cpdef SetFX(CHANNEL self, FX fx):
    (<object>fx).Set(self)

  cpdef ResetFX(CHANNEL self):
    cdef bint res = bass.BASS_FXReset(self.__channel)
    bass.__Evaluate()
    return res

  cpdef SetDSP(CHANNEL self, DSP dsp):
    dsp.Set(self)

  cpdef Link(CHANNEL self, CHANNEL obj):
    cdef bint res = bass.BASS_ChannelSetLink(self.__channel, obj.__channel)
    bass.__Evaluate()
    return res

  cpdef Unlink(CHANNEL self, CHANNEL obj):
    cdef bint res = bass.BASS_ChannelRemoveLink(self.__channel, obj.__channel)
    bass.__Evaluate()
    return res

  cpdef GetPosition(CHANNEL self, DWORD mode = bass._BASS_POS_BYTE):
    cdef QWORD res
    res = bass.BASS_ChannelGetPosition(self.__channel, mode)
    bass.__Evaluate()
    return res
  
  cpdef SetPosition(CHANNEL self, QWORD pos, DWORD mode = bass._BASS_POS_BYTE):
    cdef bint res = bass.BASS_ChannelSetPosition(self.__channel, pos, mode)
    bass.__Evaluate()
    return res
  
  cpdef Bytes2Seconds(CHANNEL self, QWORD bytes):
    cdef double secs
    secs = bass.BASS_ChannelBytes2Seconds(self.__channel, bytes)
    bass.__Evaluate()
    return secs
  
  cpdef Seconds2Bytes(CHANNEL self, double secs):
    cdef QWORD bytes
    bytes = bass.BASS_ChannelSeconds2Bytes(self.__channel, secs)
    bass.__Evaluate()
    return bytes

  cpdef GetData(CHANNEL self, DWORD length):
    cdef DWORD l = length&0xfffffff
    cdef void *buffer = <void*>PyMem_Malloc(l)
    cdef bytes b

    if buffer == NULL:
      raise MemoryError()
    
    l = bass.BASS_ChannelGetData(self.__channel, buffer, length)
    try:
      bass.__Evaluate()
    except BassError as e:
      PyMem_Free(buffer)
      raise e
    b = (<char*>buffer)[:l]
    PyMem_Free(buffer)
    return b

  cpdef GetLength(CHANNEL self, DWORD mode = bass._BASS_POS_BYTE):
    cdef QWORD res = bass.BASS_ChannelGetLength(self.__channel, mode)
    bass.__Evaluate()
    return res

  def __eq__(CHANNEL self, object y):
    cdef CHANNEL chan
    if isinstance(y, CHANNEL):
      chan = <CHANNEL>y
      return self.__channel == chan.__channel
    return NotImplemented

  property DefaultFrequency:
    def __get__(CHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.freq

  property Channels:
    def __get__(CHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.chans

  property Flags:
    def __get__(CHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.flags

  property Type:
    def __get__(CHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return CHANNEL_TYPE(info.ctype)

  property Resolution:
    def __get__(CHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.origres

  property Plugin:
    def __get__(CHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      if info.plugin:
        return PLUGIN(info.plugin)
      else:
        return None

  property Name:
    def __get__(CHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()

      if info.filename == NULL:
        return u''
      return info.filename.decode('utf-8')

  property Sample:
    def __get__(CHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      if info.sample:
        return SAMPLE(info.sample)
      else:
        return None

  property Loop:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_SAMPLE_LOOP == bass._BASS_SAMPLE_LOOP

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_SAMPLE_LOOP, switch)

  property Device:
    def __get__(CHANNEL self):
      cdef DWORD dev = bass.BASS_ChannelGetDevice(self.__channel)

      bass.__Evaluate()

      if dev == bass._BASS_NODEVICE:
        return None
        
      return OUTPUT_DEVICE(dev)

    def __set__(CHANNEL self, OUTPUT_DEVICE dev):
      if dev is None:
        bass.BASS_ChannelSetDevice(self.__channel, bass._BASS_NODEVICE)
      else:
        bass.BASS_ChannelSetDevice(self.__channel, (<OUTPUT_DEVICE?>dev).__device)

      bass.__Evaluate()

  property Level:
    def __get__(CHANNEL self):
      cdef WORD left, right
      cdef DWORD level = bass.BASS_ChannelGetLevel(self.__channel)
      bass.__Evaluate()
      left = LOWORD(level)
      right = HIWORD(level)
      return (left, right,)

  property Status:
    def __get__(CHANNEL self):
      return bass.BASS_ChannelIsActive(self.__channel)

  property Mode3D:
    def __get__(CHANNEL self):
      cdef DWORD mode
      bass.BASS_ChannelGet3DAttributes(self.__channel, &mode, NULL, NULL, NULL, NULL, NULL)
      bass.__Evaluate()
      return mode

    def __set__(CHANNEL self, int mode):
      bass.BASS_ChannelSet3DAttributes(self.__channel, mode, 0.0, 0.0, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property MinimumDistance:
    def __get__(CHANNEL self):
      cdef float min
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, &min, NULL, NULL, NULL, NULL)
      bass.__Evaluate()
      return min

    def __set__(CHANNEL self, float min):
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, min, 0.0, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property MaximumDistance:
    def __get__(CHANNEL self):
      cdef float max
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, NULL, &max, NULL, NULL, NULL)
      bass.__Evaluate()
      return max

    def __set__(CHANNEL self, float max):
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, 0.0, max, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Angle:
    def __get__(CHANNEL self):
      cdef DWORD iangle,oangle
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, NULL, NULL, &iangle, &oangle, NULL)
      bass.__Evaluate()
      return [iangle, oangle]

    def __set__(CHANNEL self, list angle):
      if len(angle) != 2: raise BassAPIError()
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, 0.0, 0.0, angle[0], angle[1], -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property OuterVolume:
    def __get__(CHANNEL self):
      cdef float outvol
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, NULL, NULL, NULL, NULL, &outvol)
      bass.__Evaluate()
      return outvol

    def __set__(CHANNEL self, float outvol):
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, 0.0, 0.0, -1, -1, outvol)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Position3D:
    def __get__(CHANNEL self):
      cdef BASS_3DVECTOR pos
      bass.BASS_ChannelGet3DPosition(self.__channel, &pos, NULL, NULL)
      bass.__Evaluate()
      return VECTOR_Create(&pos)

    def __set__(CHANNEL self, VECTOR value):
      cdef BASS_3DVECTOR pos
      value.Resolve(&pos)
      bass.BASS_ChannelSet3DPosition(self.__channel, &pos, NULL, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Orientation3D:
    def __get__(CHANNEL self):
      cdef BASS_3DVECTOR orient
      bass.BASS_ChannelGet3DPosition(self.__channel, NULL, &orient, NULL)
      bass.__Evaluate()
      return VECTOR_Create(&orient)

    def __set__(CHANNEL self, VECTOR value):
      cdef BASS_3DVECTOR orient
      value.Resolve(&orient)
      bass.BASS_ChannelSet3DPosition(self.__channel, NULL, &orient, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Velocity3D:
    def __get__(CHANNEL self):
      cdef BASS_3DVECTOR vel
      bass.BASS_ChannelGet3DPosition(self.__channel, NULL, NULL, &vel)
      bass.__Evaluate()
      return VECTOR_Create(&vel)

    def __set__(CHANNEL self, VECTOR value):
      cdef BASS_3DVECTOR vel
      value.Resolve(&vel)
      bass.BASS_ChannelSet3DPosition(self.__channel, NULL, NULL, &vel)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  @property
  def DataAvailable(CHANNEL self):
    cdef DWORD res
    res = bass.BASS_ChannelGetData(self.__channel, NULL, bass._BASS_DATA_AVAILABLE)
    bass.__Evaluate()
    return res
