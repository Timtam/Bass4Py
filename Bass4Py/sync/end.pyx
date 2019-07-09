from ..bass cimport (
                     _BASS_SYNC_END,
                     DWORD
                    )

from ..basssync cimport BASSSYNC

cdef class BASSSYNC_END(BASSSYNC):
  def __cinit__(BASSSYNC_END self):

    self.__type = _BASS_SYNC_END

  cpdef _call_callback(BASSSYNC_END self, DWORD data):
    self.__func(self, bool(data))
