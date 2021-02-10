from cpython.mem cimport PyMem_Free, PyMem_Malloc

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

from .plugin cimport Plugin
from .sample cimport Sample

cdef class ChannelBase(Evaluable):
  def __cinit__(ChannelBase self, HCHANNEL channel):

    from ..constants import SAMPLE

    self._flags_enum = SAMPLE

    if channel != 0:
      self._set_handle(channel)

  cdef void _set_handle(ChannelBase self, HCHANNEL handle):
    self._channel = handle
    self._init_attributes()

  cdef void _init_attributes(ChannelBase self):
    self.frequency = FloatAttribute(self._channel, _BASS_ATTRIB_FREQ)
    self.pan = FloatAttribute(self._channel, _BASS_ATTRIB_PAN)
    self.src = FloatAttribute(self._channel, _BASS_ATTRIB_SRC)
    self.volume = FloatAttribute(self._channel, _BASS_ATTRIB_VOL)
    self.granularity = FloatAttribute(self._channel, _BASS_ATTRIB_GRANULE)

  cdef BASS_CHANNELINFO _get_info(ChannelBase self):
    cdef BASS_CHANNELINFO info
    cdef bint res
    res=BASS_ChannelGetInfo(self._channel, &info)
    return info

  cpdef pause(ChannelBase self):
    cdef bint res 
    with nogil:
      res = BASS_ChannelPause(self._channel)
    self._evaluate()
    return res

  cpdef stop(ChannelBase self):
    cdef bint res 
    with nogil:
      res = BASS_ChannelStop(self._channel)
    self._evaluate()
    return res

  cpdef get_levels(ChannelBase self, float length, DWORD flags):
    cdef int chans = self.channels
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

  cpdef lock(ChannelBase self):
    cdef bint res

    res = BASS_ChannelLock(self._channel, True)

    self._evaluate()
    
    return res

  cpdef unlock(ChannelBase self):
    cdef bint res
    
    res = BASS_ChannelLock(self._channel, False)

    self._evaluate()
    
    return res

  cpdef get_position(ChannelBase self, DWORD mode = _BASS_POS_BYTE):
    cdef QWORD res
    res = BASS_ChannelGetPosition(self._channel, mode)
    self._evaluate()
    return res
  
  cpdef bytes_to_seconds(ChannelBase self, QWORD bytes):
    cdef double secs
    secs = BASS_ChannelBytes2Seconds(self._channel, bytes)
    self._evaluate()
    return secs
  
  cpdef seconds_to_bytes(ChannelBase self, double secs):
    cdef QWORD bytes
    bytes = BASS_ChannelSeconds2Bytes(self._channel, secs)
    self._evaluate()
    return bytes

  cpdef get_data(ChannelBase self, DWORD length):
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

  cpdef get_length(ChannelBase self, DWORD mode = _BASS_POS_BYTE):
    cdef QWORD res = BASS_ChannelGetLength(self._channel, mode)
    self._evaluate()
    return res

  def __eq__(ChannelBase self, object y):
    cdef ChannelBase chan
    if isinstance(y, ChannelBase):
      chan = <ChannelBase>y
      return self._channel == chan._channel
    return NotImplemented

  property default_frequency:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      return info.freq

  property channels:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      return info.chans

  property type:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()

      from ..constants import CHANNEL_TYPE

      return CHANNEL_TYPE(info.ctype)

  property resolution:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      return info.origres

  property plugin:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      if info.plugin:
        return Plugin(info.plugin)
      else:
        return None

  property name:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()

      if info.filename == NULL:
        return u''
      return info.filename.decode('utf-8')

  property sample:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      if info.sample:
        return Sample(info.sample)
      else:
        return None

  property level:
    def __get__(ChannelBase self):
      cdef WORD left, right
      cdef DWORD level = BASS_ChannelGetLevel(self._channel)
      self._evaluate()
      left = LOWORD(level)
      right = HIWORD(level)
      return (left, right, )

  property active:
    def __get__(ChannelBase self):
      cdef DWORD act

      act = BASS_ChannelIsActive(self._channel)

      self._evaluate()
      
      from ..constants import ACTIVE

      return ACTIVE(act)

  @property
  def data_available(ChannelBase self):
    cdef DWORD res
    res = BASS_ChannelGetData(self._channel, NULL, _BASS_DATA_AVAILABLE)
    self._evaluate()
    return res

  property flags:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      if info.flags&_BASS_UNICODE:
        return self._flags_enum(info.flags^_BASS_UNICODE)
      return self._flags_enum(info.flags)
