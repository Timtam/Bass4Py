from ..bass cimport (
                     _BASS_SYNC_MUSICPOS,
                     DWORD,
                     HIWORD,
                     LOWORD,
                     MAKELONG
                    )

from ..channel cimport Channel
from ..music cimport Music
from ..sync cimport Sync
from ...exceptions import BassAPIError, BassSyncError

cdef class MusicPosition(Sync):
  def __cinit__(MusicPosition self):

    self._type = _BASS_SYNC_MUSICPOS

  cpdef Set(MusicPosition self, Channel chan):
    if not isinstance(chan, Music):
      raise BassSyncError("this sync can only be set to a music")
    
    super(MusicPosition, self).Set(chan)

  cpdef _call_callback(MusicPosition self, DWORD data):
    self._func(self, LOWORD(data), HIWORD(data))

  property Order:
    def __get__(MusicPosition self):
      return LOWORD(self.__param)
    
    def __set__(MusicPosition self, int value):

      if self._sync:
        raise BassAPIError()
      
      if value < 0:
        value = -1
      
      self._param = MAKELONG(value, HIWORD(self._param))

  property Row:
    def __get__(MusicPosition self):
      return HIWORD(self.__param)
    
    def __set__(MusicPosition self, int value):

      if self._sync:
        raise BassAPIError()
      
      if value < 0:
        value = -1
      
      self._param = MAKELONG(LOWORD(self._param), value)
