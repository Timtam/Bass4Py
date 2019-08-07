from ..bass cimport (
                     _BASS_SYNC_FREE,
                     DWORD
                    )

from ..sync cimport SYNC

cdef class SYNC_FREE(SYNC):
  def __cinit__(SYNC_FREE self):

    self.__type = _BASS_SYNC_FREE
    self.__forcemixtime = True
    self.__mixtime = True
