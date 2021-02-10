from ...bindings.bass cimport (
  BASS_ChannelGetAttribute,
  BASS_ChannelSetAttribute,
  BASS_ChannelSlideAttribute)

from ...exceptions import BassAPIError, BassAttributeError, BassInvalidTypeError, BassPlatformError

cdef class BoolAttribute(_AttributeBase):
  cpdef get(self):
    cdef float value
    cdef bint res

    if self._not_available:
      raise BassPlatformError()

    res = BASS_ChannelGetAttribute(self._channel, self._attribute, &value)
    try:
      self._evaluate()
    except BassInvalidTypeError:
      raise BassAPIError()
    return True if value == 1 else False

  cpdef set(self, bint value):
    cdef bint res

    if self._not_available:
      raise BassPlatformError()

    if self._readonly:
      raise BassAttributeError("attribute is readonly and thus cannot be set")

    res = BASS_ChannelSetAttribute(self._channel, self._attribute, 1.0 if value else 0.0)
    try:
      self._evaluate()
    except BassInvalidTypeError:
      raise BassAPIError()
    return res

  cpdef slide(self, bint value, DWORD time):
    cdef bint res

    if self._not_available:
      raise BassPlatformError()

    if self._readonly:
      raise BassAttributeError("attribute is readonly and thus cannot be set")

    res = BASS_ChannelSlideAttribute(self._channel, self._attribute, 1.0 if value else 0.0, time)
    self._evaluate()
    return res
