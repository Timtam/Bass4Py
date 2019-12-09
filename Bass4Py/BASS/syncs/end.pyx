from ..bass cimport (
                     _BASS_SYNC_END,
                     DWORD
                    )

from ..sync cimport Sync

cdef class End(Sync):
  def __cinit__(End self):

    self.__type = _BASS_SYNC_END

  cpdef _call_callback(End self, DWORD data):
    self.__func(self, bool(data))
