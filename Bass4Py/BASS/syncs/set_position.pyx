from ..bass cimport (
                     _BASS_SYNC_SETPOS,
                     DWORD
                    )

from ..sync cimport Sync

cdef class SetPosition(Sync):
  def __cinit__(SetPosition self):

    self._type = _BASS_SYNC_SETPOS

  cpdef _call_callback(SetPosition self, DWORD data):
    self._func(self, bool(data))
