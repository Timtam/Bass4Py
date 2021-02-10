from ...bindings.bass cimport BASS_ChannelIsSliding
from ...exceptions import BassPlatformError

cdef class AttributeBase(Evaluable):

  def __cinit__(self, HCHANNEL channel, DWORD attribute, bint readonly = False, bint not_available = False):
    self._channel = channel
    self._attribute = attribute
    self._readonly = readonly
    self._not_available = not_available

  @property
  def sliding(self):
    if self._not_available:
      raise BassPlatformError()

    return BASS_ChannelIsSliding(self._channel, self._attribute)
