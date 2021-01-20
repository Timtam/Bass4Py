from cpython.mem cimport PyMem_Free, PyMem_Malloc

from .._evaluable cimport _Evaluable
from ..bindings.bass cimport (
  _BASS_ATTRIB_FREQ,
  _BASS_ATTRIB_GRANULE,
  _BASS_ATTRIB_PAN,
  _BASS_ATTRIB_SRC,
  _BASS_ATTRIB_VOL,
  _BASS_DATA_AVAILABLE,
  _BASS_POS_BYTE,
  _BASS_UNICODE,
  BASS_ChannelBytes2Seconds,
  BASS_ChannelGetData,
  BASS_ChannelGetInfo,
  BASS_ChannelGetLength,
  BASS_ChannelGetLevel,
  BASS_ChannelGetLevelEx,
  BASS_ChannelGetPosition,
  BASS_ChannelIsActive,
  BASS_ChannelLock,
  BASS_ChannelPause,
  BASS_ChannelSeconds2Bytes,
  BASS_ChannelStop,
  HIWORD,
  LOWORD,
  WORD,
  )

from .attribute cimport Attribute
from .plugin cimport Plugin
from .sample cimport Sample

cdef class ChannelBase(_Evaluable):
  def __cinit__(ChannelBase self, HCHANNEL channel):

    from ..constants import SAMPLE

    self._flags_enum = SAMPLE

    if channel != 0:
      self._sethandle(channel)

  cdef void _sethandle(ChannelBase self, HCHANNEL handle):
    self._channel = handle
    self._initattributes()

  cdef void _initattributes(ChannelBase self):
    self.Frequency = Attribute(self._channel, _BASS_ATTRIB_FREQ)
    self.Pan = Attribute(self._channel, _BASS_ATTRIB_PAN)
    self.SRC = Attribute(self._channel, _BASS_ATTRIB_SRC)
    self.Volume = Attribute(self._channel, _BASS_ATTRIB_VOL)
    self.Granularity = Attribute(self._channel, _BASS_ATTRIB_GRANULE)

  cdef BASS_CHANNELINFO _getinfo(ChannelBase self):
    cdef BASS_CHANNELINFO info
    cdef bint res
    res=BASS_ChannelGetInfo(self._channel, &info)
    return info

  cpdef Pause(ChannelBase self):
    cdef bint res 
    with nogil:
      res = BASS_ChannelPause(self._channel)
    self._evaluate()
    return res

  cpdef Stop(ChannelBase self):
    cdef bint res 
    with nogil:
      res = BASS_ChannelStop(self._channel)
    self._evaluate()
    return res

  cpdef GetLevels(ChannelBase self, float length, DWORD flags):
    cdef int chans = self.Channels
    cdef int i=0
    cdef float *levels
    cdef list plevels=[]
    levels = <float*>PyMem_Malloc(chans * sizeof(float))
    if levels == NULL: return plevels
    BASS_ChannelGetLevelEx(self._channel, levels, length, flags)
    self._evaluate()
    for i in range(chans):
      plevels.append(levels[i])
    PyMem_Free(<void*>levels)
    return tuple(plevels)

  cpdef Lock(ChannelBase self):
    cdef bint res

    res = BASS_ChannelLock(self._channel, True)

    self._evaluate()
    
    return res

  cpdef Unlock(ChannelBase self):
    cdef bint res
    
    res = BASS_ChannelLock(self._channel, False)

    self._evaluate()
    
    return res

  cpdef GetPosition(ChannelBase self, DWORD mode = _BASS_POS_BYTE):
    cdef QWORD res
    res = BASS_ChannelGetPosition(self._channel, mode)
    self._evaluate()
    return res
  
  cpdef Bytes2Seconds(ChannelBase self, QWORD bytes):
    cdef double secs
    secs = BASS_ChannelBytes2Seconds(self._channel, bytes)
    self._evaluate()
    return secs
  
  cpdef Seconds2Bytes(ChannelBase self, double secs):
    cdef QWORD bytes
    bytes = BASS_ChannelSeconds2Bytes(self._channel, secs)
    self._evaluate()
    return bytes

  cpdef GetData(ChannelBase self, DWORD length):
    cdef DWORD l = length&0xfffffff
    cdef void *buffer = <void*>PyMem_Malloc(l)
    cdef bytes b

    if buffer == NULL:
      raise MemoryError()
    
    l = BASS_ChannelGetData(self._channel, buffer, length)
    try:
      self._evaluate()
    except BassError as e:
      PyMem_Free(buffer)
      raise e
    b = (<char*>buffer)[:l]
    PyMem_Free(buffer)
    return b

  cpdef GetLength(ChannelBase self, DWORD mode = _BASS_POS_BYTE):
    cdef QWORD res = BASS_ChannelGetLength(self._channel, mode)
    self._evaluate()
    return res

  def __eq__(ChannelBase self, object y):
    cdef ChannelBase chan
    if isinstance(y, ChannelBase):
      chan = <ChannelBase>y
      return self._channel == chan._channel
    return NotImplemented

  property DefaultFrequency:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._getinfo()
      self._evaluate()
      return info.freq

  property Channels:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._getinfo()
      self._evaluate()
      return info.chans

  property Type:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._getinfo()
      self._evaluate()

      from ..constants import CHANNEL_TYPE

      return CHANNEL_TYPE(info.ctype)

  property Resolution:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._getinfo()
      self._evaluate()
      return info.origres

  property Plugin:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._getinfo()
      self._evaluate()
      if info.plugin:
        return Plugin(info.plugin)
      else:
        return None

  property Name:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._getinfo()
      self._evaluate()

      if info.filename == NULL:
        return u''
      return info.filename.decode('utf-8')

  property Sample:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._getinfo()
      self._evaluate()
      if info.sample:
        return Sample(info.sample)
      else:
        return None

  property Level:
    def __get__(ChannelBase self):
      cdef WORD left, right
      cdef DWORD level = BASS_ChannelGetLevel(self._channel)
      self._evaluate()
      left = LOWORD(level)
      right = HIWORD(level)
      return (left, right, )

  property Active:
    def __get__(ChannelBase self):
      cdef DWORD act

      act = BASS_ChannelIsActive(self._channel)

      self._evaluate()
      
      from ..constants import ACTIVE

      return ACTIVE(act)

  @property
  def DataAvailable(ChannelBase self):
    cdef DWORD res
    res = BASS_ChannelGetData(self._channel, NULL, _BASS_DATA_AVAILABLE)
    self._evaluate()
    return res

  property Flags:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._getinfo()
      self._evaluate()
      if info.flags&_BASS_UNICODE:
        return self._flags_enum(info.flags^_BASS_UNICODE)
      return self._flags_enum(info.flags)
