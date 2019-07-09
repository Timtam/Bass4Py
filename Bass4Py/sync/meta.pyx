from ..bass cimport (
                     _BASS_SYNC_META,
                     DWORD
                    )

from ..basssync cimport BASSSYNC

cdef class BASSSYNC_META(BASSSYNC):
  def __cinit__(BASSSYNC_META self):

    self.__type = _BASS_SYNC_META
    self.__forcemixtime = True
    self.__mixtime = True
