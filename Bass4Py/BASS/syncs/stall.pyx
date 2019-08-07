from ..bass cimport (
                     _BASS_SYNC_STALL,
                     DWORD
                    )

from ..sync cimport SYNC

cdef class SYNC_STALL(SYNC):
  def __cinit__(SYNC_STALL self):

    self.__type = _BASS_SYNC_STALL
    self.__forcemixtime = True
    self.__mixtime = True

  cpdef _call_callback(SYNC_STALL self, DWORD data):
    self.__func(self, bool(data))
