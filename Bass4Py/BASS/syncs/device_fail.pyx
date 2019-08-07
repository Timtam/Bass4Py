from ..bass cimport (
                     _BASS_SYNC_DEV_FAIL,
                     DWORD
                    )

from ..sync cimport SYNC

cdef class SYNC_DEVICE_FAIL(SYNC):
  def __cinit__(SYNC_DEVICE_FAIL self):

    self.__type = _BASS_SYNC_DEV_FAIL
    self.__forcemixtime = True
    self.__mixtime = True
