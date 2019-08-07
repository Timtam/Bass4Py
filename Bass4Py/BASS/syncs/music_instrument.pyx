from ..bass cimport (
                     _BASS_SYNC_MUSICINST,
                     DWORD,
                     HIWORD,
                     LOWORD,
                     MAKELONG
                    )

from ..channel cimport CHANNEL
from ..music cimport MUSIC
from ..sync cimport SYNC
from ...exceptions import BassAPIError, BassSyncError

cdef class SYNC_MUSIC_INSTRUMENT(SYNC):
  def __cinit__(SYNC_MUSIC_INSTRUMENT self):

    self.__type = _BASS_SYNC_MUSICINST

  cpdef Set(SYNC_MUSIC_INSTRUMENT self, CHANNEL chan):
    if not isinstance(chan, MUSIC):
      raise BassSyncError("this sync can only be set to a music")
    
    super(SYNC_MUSIC_INSTRUMENT, self).Set(chan)

  cpdef _call_callback(SYNC_MUSIC_INSTRUMENT self, DWORD data):
    self.__func(self, LOWORD(data), HIWORD(data))

  property Instrument:
    def __get__(SYNC_MUSIC_INSTRUMENT self):
      return LOWORD(self.__param)
    
    def __set__(SYNC_MUSIC_INSTRUMENT self, int value):

      if self.__sync:
        raise BassAPIError()
      
      if value <= 0:
        raise ValueError("value may not be <= 0")

      self.__param = MAKELONG(value, HIWORD(self.__param))

  property Note:
    def __get__(SYNC_MUSIC_INSTRUMENT self):
      return HIWORD(self.__param)
    
    def __set__(SYNC_MUSIC_INSTRUMENT self, int value):

      if self.__sync:
        raise BassAPIError()
      
      if value < 0:
        value = -1
      
      if value > 119:
        raise ValueError("value may not be larger than 119")

      self.__param = MAKELONG(LOWORD(self.__param), value)
