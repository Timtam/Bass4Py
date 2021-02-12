from ...bindings.bass cimport BASS_ChannelIsSliding
from ...exceptions import BassPlatformError

cdef class AttributeBase(Evaluable):

  _map = {}

  def __cinit__(self, HCHANNEL channel, DWORD attribute, bint readonly = False, bint not_available = False):
    self._channel = channel
    self._attribute = attribute
    self._readonly = readonly
    self._not_available = not_available
    self._map[(channel, attribute, )] = self

  @property
  def sliding(self):
    if self._not_available:
      raise BassPlatformError()

    return BASS_ChannelIsSliding(self._channel, self._attribute)

  @staticmethod
  cdef void _clean(HCHANNEL channel):
    cdef tuple key
    for key in AttributeBase._map.copy().keys():
      if key[0] == channel:
        del AttributeBase._map[key]

  @staticmethod
  cdef AttributeBase _get(HCHANNEL channel, DWORD attribute):
    try:
      return AttributeBase._map[(channel, attribute, )]
    except KeyError:
      return None
