from ..bass cimport (
                     _BASS_SYNC_SETPOS,
                     DWORD
                    )

from ..sync cimport SYNC

cdef class SYNC_SET_POSITION(SYNC):
  def __cinit__(SYNC_SET_POSITION self):

    self.__type = _BASS_SYNC_SETPOS

  cpdef _call_callback(SYNC_SET_POSITION self, DWORD data):
    self.__func(self, bool(data))
