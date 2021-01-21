from ...bindings.bass cimport (
  _BASS_SYNC_POS,
  DWORD)

from ..sync cimport Sync
from ...exceptions import BassAPIError

cdef class Position(Sync):
  def __cinit__(Position self):

    self._type = _BASS_SYNC_POS
    self._force_param = True

  property Position:
    def __get__(Position self):
      return self._param
      
    def __set__(Position self, DWORD value):

      if self._sync:
        raise BassAPIError()
        
      self._param = value
