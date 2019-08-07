from ..bass cimport (
                     _BASS_SYNC_POS,
                     DWORD
                    )

from ..sync cimport SYNC
from ...exceptions import BassAPIError

cdef class SYNC_POSITION(SYNC):
  def __cinit__(SYNC_POSITION self):

    self.__type = _BASS_SYNC_POS
    self.__forceparam = True

  property Position:
    def __get__(SYNC_POSITION self):
      return self.__param
      
    def __set__(SYNC_POSITION self, DWORD value):

      if self.__sync:
        raise BassAPIError()
        
      self.__param = value
