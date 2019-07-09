from ..bass cimport (
                     _BASS_SYNC_POS,
                     DWORD
                    )

from ..basssync cimport BASSSYNC
from ..exceptions import BassAPIError

cdef class BASSSYNC_POSITION(BASSSYNC):
  def __cinit__(BASSSYNC_POSITION self):

    self.__type = _BASS_SYNC_POS
    self.__forceparam = True

  property Position:
    def __get__(BASSSYNC_POSITION self):
      return self.__param
      
    def __set__(BASSSYNC_POSITION self, DWORD value):

      if self.__sync:
        raise BassAPIError()
        
      self.__param = value
