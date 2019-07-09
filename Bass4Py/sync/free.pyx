from ..bass cimport (
                     _BASS_SYNC_FREE,
                     DWORD
                    )

from ..basssync cimport BASSSYNC

cdef class BASSSYNC_FREE(BASSSYNC):
  def __cinit__(BASSSYNC_FREE self):

    self.__type = _BASS_SYNC_FREE
    self.__forcemixtime = True
    self.__mixtime = True
