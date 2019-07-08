from libc.stdlib cimport malloc, free
from libc.string cimport memmove
from . cimport bass
from . import basscallbacks
from .basschannelattribute cimport BASSCHANNELATTRIBUTE
from .bassdevice cimport BASSDEVICE
from .bassdsp cimport BASSDSP, CDSPPROC, CDSPPROC_STD
from .bassplugin cimport BASSPLUGIN
from .basssample cimport BASSSAMPLE
from .basssync cimport BASSSYNC, CSYNCPROC, CSYNCPROC_STD
from .bassvector cimport BASSVECTOR, BASSVECTOR_Create
from .exceptions import BassError,BassAPIError
from types import FunctionType

cdef class BASSCHANNEL:
  def __cinit__(BASSCHANNEL self, HCHANNEL channel):
    self.__channel=channel
    self.__initattributes()

  cdef void __initattributes(BASSCHANNEL self):
    self.Buffer = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_BUFFER)
    self.CPU = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_CPU, True)
    self.Frequency = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_FREQ)
    self.Pan = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_PAN)
    self.Ramping = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_NORAMP)
    self.SRC = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_SRC)
    self.Volume = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_VOL)

    IF UNAME_SYSNAME == "Windows":
      self.EAXMix = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_EAXMIX)

  cdef BASS_CHANNELINFO __getinfo(BASSCHANNEL self):
    cdef BASS_CHANNELINFO info
    cdef bint res
    res=bass.BASS_ChannelGetInfo(self.__channel, &info)
    return info

  cdef DWORD __getflags(BASSCHANNEL self):
    return bass.BASS_ChannelFlags(self.__channel, 0, 0)

  cpdef __setflags(BASSCHANNEL self, DWORD flag, bint switch):
    if switch:
      bass.BASS_ChannelFlags(self.__channel, flag, flag)
    else:
      bass.BASS_ChannelFlags(self.__channel, 0, flag)
    bass.__Evaluate()

  cpdef Play(BASSCHANNEL self, bint restart):
    cdef bint res = bass.BASS_ChannelPlay(self.__channel, restart)
    bass.__Evaluate()
    return res

  cpdef Pause(BASSCHANNEL self):
    cdef bint res = bass.BASS_ChannelPause(self.__channel)
    bass.__Evaluate()
    return res

  cpdef Stop(BASSCHANNEL self):
    cdef bint res = bass.BASS_ChannelStop(self.__channel)
    bass.__Evaluate()
    return res

  cpdef GetLevels(BASSCHANNEL self, float length, DWORD flags):
    cdef int chans = self.Channels
    cdef int i=0
    cdef float *levels
    cdef list plevels=[]
    levels = <float*>malloc(chans * sizeof(float))
    if levels == NULL: return plevels
    bass.BASS_ChannelGetLevelEx(self.__channel, levels, length, flags)
    bass.__Evaluate()
    for i in range(chans):
      plevels.append(levels[i])
    free(<void*>levels)
    return tuple(plevels)

  cpdef Lock(BASSCHANNEL self):
    return bass.BASS_ChannelLock(self.__channel, True)

  cpdef Unlock(BASSCHANNEL self):
    return bass.BASS_ChannelLock(self.__channel, False)

  cpdef SetSync(BASSCHANNEL self, DWORD stype, QWORD param, object proc, object user=None):
    cdef int cbpos, iproc
    cdef SYNCPROC *cproc
    cdef HSYNC sync
    if type(proc) != FunctionType: raise BassAPIError()
    cbpos = basscallbacks.Callbacks.AddCallback(proc, user)
    IF UNAME_SYSNAME=="Windows":
      cproc = <SYNCPROC*>CSYNCPROC_STD
    ELSE:
      cproc = <SYNCPROC*>CSYNCPROC
    sync = bass.BASS_ChannelSetSync(self.__channel, stype, param, cproc, <void*>cbpos)
    bass.__Evaluate()
    return BASSSYNC(self.__channel, sync)

  cpdef SetFX(BASSCHANNEL self, BASSFX fx):
    (<object>fx).Set(self.__channel)

  cpdef ResetFX(BASSCHANNEL self):
    cdef bint res = bass.BASS_FXReset(self.__channel)
    bass.__Evaluate()
    return res

  cpdef SetDSP(BASSCHANNEL self, object proc, int priority, object user=None):
    cdef int cbpos, iproc
    cdef DSPPROC *cproc
    cdef HDSP dsp
    if type(proc) != FunctionType: raise BassAPIError()
    cbpos = basscallbacks.Callbacks.AddCallback(proc, user)
    IF UNAME_SYSNAME=="Windows":
      cproc = <DSPPROC*>CDSPPROC_STD
    ELSE:
      cproc = <DSPPROC*>CDSPPROC
    dsp = bass.BASS_ChannelSetDSP(self.__channel, cproc, <void*>cbpos, priority)
    bass.__Evaluate()
    return BASSDSP(self.__channel, dsp)

  cpdef Link(BASSCHANNEL self, BASSCHANNEL obj):
    cdef bint res = bass.BASS_ChannelSetLink(self.__channel, obj.__channel)
    bass.__Evaluate()
    return res

  cpdef Unlink(BASSCHANNEL self, BASSCHANNEL obj):
    cdef bint res = bass.BASS_ChannelRemoveLink(self.__channel, obj.__channel)
    bass.__Evaluate()
    return res

  cpdef GetPosition(BASSCHANNEL self, DWORD mode = bass._BASS_POS_BYTE):
    cdef QWORD res
    res = bass.BASS_ChannelGetPosition(self.__channel, mode)
    bass.__Evaluate()
    return res
  
  cpdef SetPosition(BASSCHANNEL self, QWORD pos, DWORD mode = bass._BASS_POS_BYTE):
    cdef bint res = bass.BASS_ChannelSetPosition(self.__channel, pos, mode)
    bass.__Evaluate()
    return res
  
  cpdef Bytes2Seconds(BASSCHANNEL self, QWORD bytes):
    cdef double secs
    secs = bass.BASS_ChannelBytes2Seconds(self.__channel, bytes)
    bass.__Evaluate()
    return secs
  
  cpdef Seconds2Bytes(BASSCHANNEL self, double secs):
    cdef QWORD bytes
    bytes = bass.BASS_ChannelSeconds2Bytes(self.__channel, secs)
    bass.__Evaluate()
    return bytes

  cpdef GetData(BASSCHANNEL self, DWORD length):
    cdef DWORD l = length&0xfffffff
    cdef void *buffer = <void*>malloc(l)
    cdef bytes b

    if buffer == NULL:
      raise MemoryError()
    
    l = bass.BASS_ChannelGetData(self.__channel, buffer, length)
    try:
      bass.__Evaluate()
    except BassError as e:
      free(buffer)
      raise e
    b = (<char*>buffer)[:l]
    free(buffer)
    return b

  cpdef GetLength(BASSCHANNEL self, DWORD mode = bass._BASS_POS_BYTE):
    cdef QWORD res = bass.BASS_ChannelGetLength(self.__channel, mode)
    bass.__Evaluate()
    return res

  property DefaultFrequency:
    def __get__(BASSCHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.freq

  property Channels:
    def __get__(BASSCHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.chans

  property Flags:
    def __get__(BASSCHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.flags

  property Type:
    def __get__(BASSCHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.ctype

  property Resolution:
    def __get__(BASSCHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.origres

  property Plugin:
    def __get__(BASSCHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      if info.plugin:
        return BASSPLUGIN(info.plugin)
      else:
        return None

  property Name:
    def __get__(BASSCHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.filename

  property Sample:
    def __get__(BASSCHANNEL self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      if info.sample:
        return BASSSAMPLE(info.sample)
      else:
        return None

  property Loop:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_SAMPLE_LOOP == bass._BASS_SAMPLE_LOOP

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_SAMPLE_LOOP, switch)

  property Device:
    def __get__(BASSCHANNEL self):
      return BASSDEVICE(bass.BASS_ChannelGetDevice(self.__channel))

  property Level:
    def __get__(BASSCHANNEL self):
      cdef WORD left, right
      cdef DWORD level = bass.BASS_ChannelGetLevel(self.__channel)
      bass.__Evaluate()
      left = LOWORD(level)
      right = HIWORD(level)
      return (left, right,)

  property Status:
    def __get__(BASSCHANNEL self):
      return bass.BASS_ChannelIsActive(self.__channel)

  property Mode3D:
    def __get__(BASSCHANNEL self):
      cdef DWORD mode
      bass.BASS_ChannelGet3DAttributes(self.__channel, &mode, NULL, NULL, NULL, NULL, NULL)
      bass.__Evaluate()
      return mode

    def __set__(BASSCHANNEL self, int mode):
      bass.BASS_ChannelSet3DAttributes(self.__channel, mode, 0.0, 0.0, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property MinimumDistance:
    def __get__(BASSCHANNEL self):
      cdef float min
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, &min, NULL, NULL, NULL, NULL)
      bass.__Evaluate()
      return min

    def __set__(BASSCHANNEL self, float min):
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, min, 0.0, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property MaximumDistance:
    def __get__(BASSCHANNEL self):
      cdef float max
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, NULL, &max, NULL, NULL, NULL)
      bass.__Evaluate()
      return max

    def __set__(BASSCHANNEL self, float max):
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, 0.0, max, -1, -1, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Angle:
    def __get__(BASSCHANNEL self):
      cdef DWORD iangle,oangle
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, NULL, NULL, &iangle, &oangle, NULL)
      bass.__Evaluate()
      return [iangle, oangle]

    def __set__(BASSCHANNEL self, list angle):
      if len(angle) != 2: raise BassAPIError()
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, 0.0, 0.0, angle[0], angle[1], -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property OuterVolume:
    def __get__(BASSCHANNEL self):
      cdef float outvol
      bass.BASS_ChannelGet3DAttributes(self.__channel, NULL, NULL, NULL, NULL, NULL, &outvol)
      bass.__Evaluate()
      return outvol

    def __set__(BASSCHANNEL self, float outvol):
      bass.BASS_ChannelSet3DAttributes(self.__channel, -1, 0.0, 0.0, -1, -1, outvol)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Position3D:
    def __get__(BASSCHANNEL self):
      cdef BASS_3DVECTOR pos
      bass.BASS_ChannelGet3DPosition(self.__channel, &pos, NULL, NULL)
      bass.__Evaluate()
      return BASSVECTOR_Create(&pos)

    def __set__(BASSCHANNEL self, BASSVECTOR value):
      cdef BASS_3DVECTOR pos
      value.Resolve(&pos)
      bass.BASS_ChannelSet3DPosition(self.__channel, &pos, NULL, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Orientation3D:
    def __get__(BASSCHANNEL self):
      cdef BASS_3DVECTOR orient
      bass.BASS_ChannelGet3DPosition(self.__channel, NULL, &orient, NULL)
      bass.__Evaluate()
      return BASSVECTOR_Create(&orient)

    def __set__(BASSCHANNEL self, BASSVECTOR value):
      cdef BASS_3DVECTOR orient
      value.Resolve(&orient)
      bass.BASS_ChannelSet3DPosition(self.__channel, NULL, &orient, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Velocity3D:
    def __get__(BASSCHANNEL self):
      cdef BASS_3DVECTOR vel
      bass.BASS_ChannelGet3DPosition(self.__channel, NULL, NULL, &vel)
      bass.__Evaluate()
      return BASSVECTOR_Create(&vel)

    def __set__(BASSCHANNEL self, BASSVECTOR value):
      cdef BASS_3DVECTOR vel
      value.Resolve(&vel)
      bass.BASS_ChannelSet3DPosition(self.__channel, NULL, NULL, &vel)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  @property
  def DataAvailable(BASSCHANNEL self):
    cdef DWORD res
    res = bass.BASS_ChannelGetData(self.__channel, NULL, bass._BASS_DATA_AVAILABLE)
    bass.__Evaluate()
    return res
