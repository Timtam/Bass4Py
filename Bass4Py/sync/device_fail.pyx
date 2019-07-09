from ..bass cimport (
                     _BASS_SYNC_DEV_FAIL,
                     DWORD
                    )

from ..basssync cimport BASSSYNC

cdef class BASSSYNC_DEVICEFAIL(BASSSYNC):
  def __cinit__(BASSSYNC_DEVICEFAIL self):

    self.__type = _BASS_SYNC_DEV_FAIL
    self.__forcemixtime = True
    self.__mixtime = True
