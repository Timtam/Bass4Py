from ..bindings.bass cimport (
  _BASS_ATTRIB_BUFFER,
  _BASS_ATTRIB_MUSIC_VOL_CHAN,
  _BASS_ATTRIB_MUSIC_VOL_INST,
  _BASS_ATTRIB_NOBUFFER,
  _BASS_ATTRIB_NORAMP,
  _BASS_ATTRIB_SCANINFO,
  BASS_ChannelIsSliding,
  BASS_ChannelGetAttribute,
  BASS_ChannelGetAttributeEx,
  BASS_ChannelSetAttribute,
  BASS_ChannelSetAttributeEx,
  BASS_ChannelSlideAttribute)

from .._evaluable cimport _Evaluable
from ..exceptions import BassAPIError, BassAttributeError, BassInvalidTypeError, BassPlatformError

from cpython.mem cimport PyMem_Malloc, PyMem_Free

cdef class Attribute(_Evaluable):
  def __cinit__(Attribute self, HCHANNEL channel, DWORD attribute, bint readonly = False, bint not_available = False):
    self._channel = channel
    self._attrib = attribute
    self._readonly = readonly
    self._not_available = not_available

  cpdef Get(Attribute self):
    cdef float value
    cdef bint res

    if self._not_available:
      raise BassPlatformError()

    if self._attrib == _BASS_ATTRIB_MUSIC_VOL_CHAN or \
       self._attrib == _BASS_ATTRIB_MUSIC_VOL_INST:
      return self._getmusicvolchan()
    elif self._attrib == _BASS_ATTRIB_BUFFER:
      return self._getbuffer()
    elif self._attrib == _BASS_ATTRIB_NORAMP:
      return self._getramping()
    elif self._attrib == _BASS_ATTRIB_SCANINFO:
      return self._getscaninfo()

    res = BASS_ChannelGetAttribute(self._channel, self._attrib, &value)
    try:
      self._evaluate()
    except BassInvalidTypeError:
      raise BassAPIError()
    return value

  cpdef Set(Attribute self, object value):
    cdef bint res

    if self._not_available:
      raise BassPlatformError()

    if self._readonly:
      raise BassAttributeError("attribute is readonly and thus cannot be set")

    if self._attrib == _BASS_ATTRIB_MUSIC_VOL_CHAN or \
       self._attrib==_BASS_ATTRIB_MUSIC_VOL_INST:
      return self._setmusicvolchan(<list>value)
    elif self._attrib == _BASS_ATTRIB_BUFFER:
      return self._setbuffer(<float>value)
    elif self._attrib == _BASS_ATTRIB_NORAMP:
      return self._setramping(<bint>value)

    res = BASS_ChannelSetAttribute(self._channel, self._attrib, <float>value)
    try:
      self._evaluate()
    except BassInvalidTypeError:
      raise BassAPIError()
    return res

  cpdef Slide(Attribute self, object value, DWORD time):
    cdef bint res

    if self._not_available:
      raise BassPlatformError()

    if self._readonly:
      raise BassAttributeError("attribute is readonly and thus cannot be set")

    if self._attrib == _BASS_ATTRIB_MUSIC_VOL_CHAN or \
       self._attrib == _BASS_ATTRIB_MUSIC_VOL_INST:
      return self._slidemusicvolchan(<tuple?>value, time)
    elif self._attrib == _BASS_ATTRIB_BUFFER:
      return self._slidebuffer(<float>value, time)
    res = BASS_ChannelSlideAttribute(self._channel, self._attrib, <float>value, time)
    self._evaluate()
    return res

  cpdef _getmusicvolchan(Attribute self):
    cdef list volumes=[]
    cdef int channel=0
    cdef float res
    try:
      while True:
        BASS_ChannelGetAttribute(self._channel, self._attrib+channel, &res)
        self._evaluate()
        volumes.append(res)
        channel+=1
    except BassInvalidTypeError:
      if len(volumes) == 0:
        raise BassInvalidTypeError()
    return tuple(volumes)

  cpdef _setmusicvolchan(Attribute self, tuple value):
    cdef tuple current = self._getmusicvolchan()
    cdef int i
    if len(value) != len(current):
      raise BassAPIError()
    for i in range(len(value)):
      BASS_ChannelSetAttribute(self._channel, self._attrib+i, value[i])
    return True

  cpdef _getbuffer(Attribute self):
    cdef float res
    BASS_ChannelGetAttribute(self._channel, self._attrib, &res)
    self._evaluate()
    return res

  cpdef _setbuffer(Attribute self, float value):
    BASS_ChannelSetAttribute(self._channel, self._attrib, value)
    self._evaluate()
    if value == 0:
      BASS_ChannelSetAttribute(self._channel, _BASS_ATTRIB_NOBUFFER, 1.0)
    else:
      BASS_ChannelSetAttribute(self._channel, _BASS_ATTRIB_NOBUFFER, 0.0)
    self._evaluate()
    return True

  cpdef _slidemusicvolchan(Attribute self, tuple value, DWORD time):
    cdef tuple current = self._getmusicvolchan()
    cdef int i
    if len(value) != len(current):
      raise BassAPIError()
    for i in range(len(value)):
      BASS_ChannelSlideAttribute(self._channel, self._attrib+i, value[i], time)
    return True

  cpdef _slidebuffer(Attribute self, float value, DWORD time):
    BASS_ChannelSlideAttribute(self._channel, self._attrib, value, time)
    self._evaluate()
    return True

  property Sliding:
    def __get__(Attribute self):

      if self._not_available:
        raise BassPlatformError()

      return BASS_ChannelIsSliding(self._channel, self._attrib)
      
  cpdef _getramping(Attribute self):
    cdef float res
    BASS_ChannelGetAttribute(self._channel, _BASS_ATTRIB_NORAMP, &res)
    self._evaluate()
    return False if res == 1 else True

  cpdef _setramping(Attribute self, bint value):
    BASS_ChannelSetAttribute(self._channel, _BASS_ATTRIB_NORAMP, 0.0 if value == True else 1.0)
    self._evaluate()
    return True

  cpdef _getscaninfo(Attribute self):
    cdef bytes res
    cdef DWORD size
    cdef void * info

    size = BASS_ChannelGetAttributeEx(self._channel, self._attrib, NULL, 0)
    self._evaluate()

    info = PyMem_Malloc(size)

    if info == NULL:
      raise MemoryError()

    BASS_ChannelGetAttributeEx(self._channel, self._attrib, info, size)

    try:
      self._evaluate()
    except Exception, e:
      PyMem_Free(info)
      raise e
    
    res = (<char*>info)[:size]
    PyMem_Free(info)
    return res

  cpdef _setscaninfo(Attribute self, bytes info):
    cdef DWORD size = len(info)
    cdef DWORD res = BASS_ChannelSetAttributeEx(self._channel, self._attrib, <void*>info, size)
    self._evaluate()
    return res

  def __eq__(Attribute self, object y):
    cdef Attribute attr
    if isinstance(y, Attribute):
      attr = <Attribute>y
      return self._channel == attr._channel and self._attrib == attr._attrib
    return NotImplemented
