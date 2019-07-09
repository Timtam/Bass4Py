from ..bass cimport (
                     _BASS_SYNC_DEV_FORMAT,
                     DWORD
                    )

from ..basssync cimport BASSSYNC

cdef class BASSSYNC_DEVICEFORMAT(BASSSYNC):
  def __cinit__(BASSSYNC_DEVICEFORMAT self):

    self.__type = _BASS_SYNC_DEV_FORMAT
    self.__forcemixtime = True
    self.__mixtime = True
