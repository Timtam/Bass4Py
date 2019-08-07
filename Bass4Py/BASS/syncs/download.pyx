from ..bass cimport (
                     _BASS_SYNC_DOWNLOAD,
                     DWORD
                    )

from ..channel cimport CHANNEL
from ..stream cimport STREAM
from ..sync cimport SYNC
from ...exceptions import BassSyncError

cdef class SYNC_DOWNLOAD(SYNC):
  def __cinit__(SYNC_DOWNLOAD self):

    self.__type = _BASS_SYNC_DOWNLOAD
    self.__forcemixtime = True
    self.__mixtime = True

  cpdef Set(SYNC_DOWNLOAD self, CHANNEL chan):

    if not isinstance(chan, STREAM):
      raise BassSyncError("this sync can only be set to a stream")
    
    super(SYNC_DOWNLOAD, self).Set(chan)
