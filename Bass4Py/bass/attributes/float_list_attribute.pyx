from ...bindings.bass cimport (
  BASS_ChannelGetAttribute,
  BASS_ChannelSetAttribute,
  BASS_ChannelSlideAttribute)

from ...exceptions import BassAPIError, BassAttributeError, BassInvalidTypeError, BassPlatformError

cdef class FloatListAttribute(AttributeBase):
  cpdef get(self):
    cdef list values = []
    cdef int index = 0
    cdef float res
    try:
      while True:
        BASS_ChannelGetAttribute(self._channel, self._attribute + index, &res)
        self._evaluate()
        values.append(res)
        index+=1
    except BassInvalidTypeError:
      if len(values) == 0:
        raise BassInvalidTypeError()
    return values

  cpdef set(self, list values):
    cdef list current = self.get()
    cdef int i
    if len(values) != len(current):
      raise BassAPIError()
    for i in range(len(values)):
      BASS_ChannelSetAttribute(self._channel, self._attribute + i, values[i])
    return True

  cpdef slide(self, list values, DWORD time):
    cdef list current = self.get()
    cdef int i
    if len(values) != len(current):
      raise BassAPIError()
    for i in range(len(values)):
      BASS_ChannelSlideAttribute(self._channel, self._attribute + i, values[i], time)
    return True
