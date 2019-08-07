from ..bass cimport (
                     _BASS_SYNC_DOWNLOAD,
                     DWORD
                    )

from ..basschannel cimport BASSCHANNEL
from ..bassstream cimport BASSSTREAM
from ..basssync cimport BASSSYNC
from ..exceptions import BassSyncError

cdef class BASSSYNC_DOWNLOAD(BASSSYNC):
  def __cinit__(BASSSYNC_DOWNLOAD self):

    self.__type = _BASS_SYNC_DOWNLOAD
    self.__forcemixtime = True
    self.__mixtime = True

  cpdef Set(BASSSYNC_DOWNLOAD self, BASSCHANNEL chan):

    if not isinstance(chan, BASSSTREAM):
      raise BassSyncError("this sync can only be set to a stream")
    
    super(BASSSYNC_DOWNLOAD, self).Set(chan)
