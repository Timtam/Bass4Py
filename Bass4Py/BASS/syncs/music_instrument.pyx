from ..bass cimport (
                     _BASS_SYNC_MUSICINST,
                     DWORD,
                     HIWORD,
                     LOWORD,
                     MAKELONG
                    )

from ..channel cimport Channel
from ..music cimport Music
from ..sync cimport Sync
from ...exceptions import BassApiError, BassSyncError

cdef class MusicInstrument(Sync):
  def __cinit__(MusicInstrument self):

    self.__type = _BASS_SYNC_MUSICINST

  cpdef Set(MusicInstrument self, Channel chan):
    if not isinstance(chan, Music):
      raise BassSyncError("this sync can only be set to a music")
    
    super(MusicInstrument, self).Set(chan)

  cpdef _call_callback(MusicInstrument self, DWORD data):
    self.__func(self, LOWORD(data), HIWORD(data))

  property Instrument:
    def __get__(MusicInstrument self):
      return LOWORD(self.__param)
    
    def __set__(MusicInstrument self, int value):

      if self.__sync:
        raise BassApiError()
      
      if value <= 0:
        raise ValueError("value may not be <= 0")

      self.__param = MAKELONG(value, HIWORD(self.__param))

  property Note:
    def __get__(MusicInstrument self):
      return HIWORD(self.__param)
    
    def __set__(MusicInstrument self, int value):

      if self.__sync:
        raise BassApiError()
      
      if value < 0:
        value = -1
      
      if value > 119:
        raise ValueError("value may not be larger than 119")

      self.__param = MAKELONG(LOWORD(self.__param), value)
