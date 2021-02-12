from ...bindings.bass cimport (
  _BASS_SYNC_SLIDE,
  DWORD)

from ..attributes.attribute_base cimport AttributeBase
from ..sync cimport Sync

cdef class Slide(Sync):
  def __cinit__(Slide self):

    self._type = _BASS_SYNC_SLIDE
    self._set_mix_time(True)

  cpdef _call_callback(Slide self, DWORD data):
    self._func(self, AttributeBase._get(self.Channel._channel, data))
