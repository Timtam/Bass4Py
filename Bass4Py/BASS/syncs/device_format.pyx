from ..bass cimport (
                     _BASS_SYNC_DEV_FORMAT,
                     DWORD
                    )

from ..sync cimport SYNC

cdef class SYNC_DEVICE_FORMAT(SYNC):
  def __cinit__(SYNC_DEVICE_FORMAT self):

    self.__type = _BASS_SYNC_DEV_FORMAT
    self.__forcemixtime = True
    self.__mixtime = True
