from ...bindings.bass cimport (
  _BASS_SYNC_STALL,
  DWORD)

from ..sync cimport Sync

cdef class Stall(Sync):
  def __cinit__(Stall self):

    self._type = _BASS_SYNC_STALL
    self._set_mix_time(True)

  cpdef _call_callback(Stall self, DWORD data):
    self._func(self, bool(data))
