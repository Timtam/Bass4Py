from ...bindings.bass cimport (
  _BASS_SYNC_MUSICINST,
  DWORD,
  HIWORD,
  LOWORD,
  MAKELONG)

from ..channel cimport Channel
from ..music cimport Music
from ..sync cimport Sync
from ...exceptions import BassAPIError, BassSyncError

cdef class MusicInstrument(Sync):
  def __cinit__(MusicInstrument self):

    self._type = _BASS_SYNC_MUSICINST

  cpdef Set(MusicInstrument self, Channel chan):
    if not isinstance(chan, Music):
      raise BassSyncError("this sync can only be set to a music")
    
    super(MusicInstrument, self).Set(chan)

  cpdef _call_callback(MusicInstrument self, DWORD data):
    self._func(self, LOWORD(data), HIWORD(data))

  property Instrument:
    def __get__(MusicInstrument self):
      return LOWORD(self.__param)
    
    def __set__(MusicInstrument self, int value):

      if self._sync:
        raise BassAPIError()
      
      if value <= 0:
        raise ValueError("value may not be <= 0")

      self._param = MAKELONG(value, HIWORD(self._param))

  property Note:
    def __get__(MusicInstrument self):
      return HIWORD(self.__param)
    
    def __set__(MusicInstrument self, int value):

      if self._sync:
        raise BassAPIError()
      
      if value < 0:
        value = -1
      
      if value > 119:
        raise ValueError("value may not be larger than 119")

      self._param = MAKELONG(LOWORD(self._param), value)
