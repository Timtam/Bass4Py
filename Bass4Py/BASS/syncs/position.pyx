from ..bass cimport (
                     _BASS_SYNC_POS,
                     DWORD
                    )

from ..sync cimport Sync
from ...exceptions import BassApiError

cdef class Position(Sync):
  def __cinit__(Position self):

    self.__type = _BASS_SYNC_POS
    self.__forceparam = True

  property Position:
    def __get__(Position self):
      return self.__param
      
    def __set__(Position self, DWORD value):

      if self.__sync:
        raise BassApiError()
        
      self.__param = value
