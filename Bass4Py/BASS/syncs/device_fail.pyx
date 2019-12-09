from ..bass cimport (
                     _BASS_SYNC_DEV_FAIL,
                     DWORD
                    )

from ..sync cimport Sync

cdef class DeviceFail(Sync):
  def __cinit__(DeviceFail self):

    self.__type = _BASS_SYNC_DEV_FAIL
    self.__forcemixtime = True
    self.__mixtime = True
