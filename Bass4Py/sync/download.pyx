from ..bass cimport (
                     _BASS_SYNC_DOWNLOAD,
                     DWORD
                    )

from ..basssync cimport BASSSYNC

cdef class BASSSYNC_DOWNLOAD(BASSSYNC):
  def __cinit__(BASSSYNC_DOWNLOAD self):

    self.__type = _BASS_SYNC_DOWNLOAD
    self.__forcemixtime = True
    self.__mixtime = True
