from ..bass cimport (
                     _BASS_SYNC_OGG_CHANGE,
                     DWORD
                    )

from ..channel cimport CHANNEL
from ..stream cimport STREAM
from ..sync cimport SYNC
from ...exceptions import BassSyncError

cdef class SYNC_OGG_CHANGE(SYNC):
  def __cinit__(SYNC_OGG_CHANGE self):

    self.__type = _BASS_SYNC_OGG_CHANGE

  cpdef Set(SYNC_OGG_CHANGE self, CHANNEL chan):
    if not isinstance(chan, STREAM):
      raise BassSyncError("this sync can only be set to a stream")
    
    super(SYNC_OGG_CHANGE, self).Set(chan)
