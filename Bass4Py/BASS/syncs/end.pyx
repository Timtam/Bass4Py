from ..bass cimport (
                     _BASS_SYNC_END,
                     DWORD
                    )

from ..sync cimport SYNC

cdef class SYNC_END(SYNC):
  def __cinit__(SYNC_END self):

    self.__type = _BASS_SYNC_END

  cpdef _call_callback(SYNC_END self, DWORD data):
    self.__func(self, bool(data))
