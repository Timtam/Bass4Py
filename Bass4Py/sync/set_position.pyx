from ..bass cimport (
                     _BASS_SYNC_SETPOS,
                     DWORD
                    )

from ..basssync cimport BASSSYNC

cdef class BASSSYNC_SETPOSITION(BASSSYNC):
  def __cinit__(BASSSYNC_SETPOSITION self):

    self.__type = _BASS_SYNC_SETPOS

  cpdef _call_callback(BASSSYNC_SETPOSITION self, DWORD data):
    self.__func(self, bool(data))
