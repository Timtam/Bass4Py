from ...bindings.bass cimport (
  _BASS_SYNC_FREE,
  DWORD)

from ..sync cimport Sync

cdef class Free(Sync):
  def __cinit__(Free self):

    self._type = _BASS_SYNC_FREE
    self._set_mixtime(True)
