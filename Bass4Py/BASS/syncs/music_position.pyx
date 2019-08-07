from ..bass cimport (
                     _BASS_SYNC_MUSICPOS,
                     DWORD,
                     HIWORD,
                     LOWORD,
                     MAKELONG
                    )

from ..channel cimport CHANNEL
from ..music cimport MUSIC
from ..sync cimport SYNC
from ...exceptions import BassAPIError, BassSyncError

cdef class SYNC_MUSIC_POSITION(SYNC):
  def __cinit__(SYNC_MUSIC_POSITION self):

    self.__type = _BASS_SYNC_MUSICPOS

  cpdef Set(SYNC_MUSIC_POSITION self, CHANNEL chan):
    if not isinstance(chan, MUSIC):
      raise BassSyncError("this sync can only be set to a music")
    
    super(SYNC_MUSIC_POSITION, self).Set(chan)

  cpdef _call_callback(SYNC_MUSIC_POSITION self, DWORD data):
    self.__func(self, LOWORD(data), HIWORD(data))

  property Order:
    def __get__(SYNC_MUSIC_POSITION self):
      return LOWORD(self.__param)
    
    def __set__(SYNC_MUSIC_POSITION self, int value):

      if self.__sync:
        raise BassAPIError()
      
      if value < 0:
        value = -1
      
      self.__param = MAKELONG(value, HIWORD(self.__param))

  property Row:
    def __get__(SYNC_MUSIC_POSITION self):
      return HIWORD(self.__param)
    
    def __set__(SYNC_MUSIC_POSITION self, int value):

      if self.__sync:
        raise BassAPIError()
      
      if value < 0:
        value = -1
      
      self.__param = MAKELONG(LOWORD(self.__param), value)
