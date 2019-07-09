from ..bass cimport (
                     _BASS_SYNC_STALL,
                     DWORD
                    )

from ..basssync cimport BASSSYNC

cdef class BASSSYNC_STALL(BASSSYNC):
  def __cinit__(BASSSYNC_STALL self):

    self.__type = _BASS_SYNC_STALL
    self.__forcemixtime = True
    self.__mixtime = True

  cpdef _call_callback(BASSSYNC_STALL self, DWORD data):
    self.__func(self, bool(data))
