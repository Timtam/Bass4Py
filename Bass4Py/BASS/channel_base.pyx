from cpython.mem cimport PyMem_Free, PyMem_Malloc

from . cimport bass
from .attribute cimport ATTRIBUTE
from .plugin cimport PLUGIN
from .sample cimport SAMPLE
from ..constants import ACTIVE, CHANNEL_TYPE

cdef class CHANNEL_BASE:
  def __cinit__(CHANNEL_BASE self, HCHANNEL channel):

    if channel != 0:
      self.__sethandle(channel)

  cdef void __sethandle(CHANNEL_BASE self, HCHANNEL handle):
    self.__channel = handle
    self.__initattributes()

  cdef void __initattributes(CHANNEL_BASE self):
    self.Frequency = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_FREQ)
    self.Pan = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_PAN)
    self.SRC = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_SRC)
    self.Volume = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_VOL)

  cdef BASS_CHANNELINFO __getinfo(CHANNEL_BASE self):
    cdef BASS_CHANNELINFO info
    cdef bint res
    res=bass.BASS_ChannelGetInfo(self.__channel, &info)
    return info

  cpdef Pause(CHANNEL_BASE self):
    cdef bint res 
    with nogil:
      res = bass.BASS_ChannelPause(self.__channel)
    bass.__Evaluate()
    return res

  cpdef Stop(CHANNEL_BASE self):
    cdef bint res 
    with nogil:
      res = bass.BASS_ChannelStop(self.__channel)
    bass.__Evaluate()
    return res

  cpdef GetLevels(CHANNEL_BASE self, float length, DWORD flags):
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

  cpdef Lock(CHANNEL_BASE self):
    cdef bint res

    res = bass.BASS_ChannelLock(self.__channel, True)

    bass.__Evaluate()
    
    return res

  cpdef Unlock(CHANNEL_BASE self):
    cdef bint res
    
    res = bass.BASS_ChannelLock(self.__channel, False)

    bass.__Evaluate()
    
    return res

  cpdef GetPosition(CHANNEL_BASE self, DWORD mode = bass._BASS_POS_BYTE):
    cdef QWORD res
    res = bass.BASS_ChannelGetPosition(self.__channel, mode)
    bass.__Evaluate()
    return res
  
  cpdef Bytes2Seconds(CHANNEL_BASE self, QWORD bytes):
    cdef double secs
    secs = bass.BASS_ChannelBytes2Seconds(self.__channel, bytes)
    bass.__Evaluate()
    return secs
  
  cpdef Seconds2Bytes(CHANNEL_BASE self, double secs):
    cdef QWORD bytes
    bytes = bass.BASS_ChannelSeconds2Bytes(self.__channel, secs)
    bass.__Evaluate()
    return bytes

  cpdef GetData(CHANNEL_BASE self, DWORD length):
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

  cpdef GetLength(CHANNEL_BASE self, DWORD mode = bass._BASS_POS_BYTE):
    cdef QWORD res = bass.BASS_ChannelGetLength(self.__channel, mode)
    bass.__Evaluate()
    return res

  def __eq__(CHANNEL_BASE self, object y):
    cdef CHANNEL_BASE chan
    if isinstance(y, CHANNEL_BASE):
      chan = <CHANNEL_BASE>y
      return self.__channel == chan.__channel
    return NotImplemented

  property DefaultFrequency:
    def __get__(CHANNEL_BASE self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.freq

  property Channels:
    def __get__(CHANNEL_BASE self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.chans

  property Flags:
    def __get__(CHANNEL_BASE self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.flags

  property Type:
    def __get__(CHANNEL_BASE self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return CHANNEL_TYPE(info.ctype)

  property Resolution:
    def __get__(CHANNEL_BASE self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.origres

  property Plugin:
    def __get__(CHANNEL_BASE self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      if info.plugin:
        return PLUGIN(info.plugin)
      else:
        return None

  property Name:
    def __get__(CHANNEL_BASE self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()

      if info.filename == NULL:
        return u''
      return info.filename.decode('utf-8')

  property Sample:
    def __get__(CHANNEL_BASE self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      if info.sample:
        return SAMPLE(info.sample)
      else:
        return None

  property Level:
    def __get__(CHANNEL_BASE self):
      cdef bass.WORD left, right
      cdef DWORD level = bass.BASS_ChannelGetLevel(self.__channel)
      bass.__Evaluate()
      left = bass.LOWORD(level)
      right = bass.HIWORD(level)
      return (left, right, )

  property Active:
    def __get__(CHANNEL_BASE self):
      cdef DWORD act

      act = bass.BASS_ChannelIsActive(self.__channel)

      bass.__Evaluate()
      
      return ACTIVE(act)

  @property
  def DataAvailable(CHANNEL_BASE self):
    cdef DWORD res
    res = bass.BASS_ChannelGetData(self.__channel, NULL, bass._BASS_DATA_AVAILABLE)
    bass.__Evaluate()
    return res
