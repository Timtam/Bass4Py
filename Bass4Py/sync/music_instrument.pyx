from ..bass cimport (
                     _BASS_SYNC_MUSICINST,
                     DWORD,
                     HIWORD,
                     LOWORD,
                     MAKELONG
                    )

from ..basssync cimport BASSSYNC
from .exceptions import BassAPIError

cdef class BASSSYNC_MUSICINSTRUMENT(BASSSYNC):
  def __cinit__(BASSSYNC_MUSICINSTRUMENT self):

    self.__type = _BASS_SYNC_MUSICINST

  cpdef _call_callback(BASSSYNC_MUSICINSTRUMENT self, DWORD data):
    self.__func(self, LOWORD(data), HIWORD(data))

  property Instrument:
    def __get__(BASSSYNC_MUSICINSTRUMENT self):
      return LOWORD(self.__param)
    
    def __set__(BASSSYNC_MUSICINSTRUMENT self, int value):

      if self.__sync:
        raise BassAPIError()
      
      if value <= 0:
        raise ValueError("value may not be <= 0")

      self.__param = MAKELONG(value, HIWORD(self.__param))

  property Note:
    def __get__(BASSSYNC_MUSICINSTRUMENT self):
      return HIWORD(self.__param)
    
    def __set__(BASSSYNC_MUSICINSTRUMENT self, int value):

      if self.__sync:
        raise BassAPIError()
      
      if value < 0:
        value = -1
      
      if value > 119:
        raise ValueError("value may not be larger than 119")

      self.__param = MAKELONG(LOWORD(self.__param), value)
