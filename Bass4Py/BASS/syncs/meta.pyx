from ..bass cimport (
                     _BASS_SYNC_META,
                     DWORD
                    )

from ..channel cimport CHANNEL
from ..stream cimport STREAM
from ..sync cimport SYNC
from ...exceptions import BassSyncError

cdef class SYNC_META(SYNC):
  def __cinit__(SYNC_META self):

    self.__type = _BASS_SYNC_META
    self.__forcemixtime = True
    self.__mixtime = True

  cpdef Set(SYNC_META self, CHANNEL chan):
    if not isinstance(chan, STREAM):
      raise BassSyncError("this sync can only be set to a stream")
    
    super(SYNC_META, self).Set(chan)
