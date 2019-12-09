from ..bass cimport (
                     _BASS_SYNC_META,
                     DWORD
                    )

from ..channel cimport Channel
from ..stream cimport Stream
from ..sync cimport Sync
from ...exceptions import BassSyncError

cdef class Meta(Sync):
  def __cinit__(Meta self):

    self.__type = _BASS_SYNC_META
    self.__forcemixtime = True
    self.__mixtime = True

  cpdef Set(Meta self, Channel chan):
    if not isinstance(chan, Stream):
      raise BassSyncError("this sync can only be set to a stream")
    
    super(Meta, self).Set(chan)
