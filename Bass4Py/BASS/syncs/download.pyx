from ..bass cimport (
                     _BASS_SYNC_DOWNLOAD,
                     DWORD
                    )

from ..channel cimport Channel
from ..stream cimport Stream
from ..sync cimport Sync
from ...exceptions import BassSyncError

cdef class Download(Sync):
  def __cinit__(Download self):

    self.__type = _BASS_SYNC_DOWNLOAD
    self._set_mixtime(True)

  cpdef Set(Download self, Channel chan):

    if not isinstance(chan, Stream):
      raise BassSyncError("this sync can only be set to a stream")
    
    super(Download, self).Set(chan)
