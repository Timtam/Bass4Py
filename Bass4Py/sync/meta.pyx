from ..bass cimport (
                     _BASS_SYNC_META,
                     DWORD
                    )

from ..basschannel cimport BASSCHANNEL
from ..bassstream cimport BASSSTREAM
from ..basssync cimport BASSSYNC
from ..exceptions import BassSyncError

cdef class BASSSYNC_META(BASSSYNC):
  def __cinit__(BASSSYNC_META self):

    self.__type = _BASS_SYNC_META
    self.__forcemixtime = True
    self.__mixtime = True

  cpdef Set(BASSSYNC_META self, BASSCHANNEL chan):
    if not isinstance(chan, BASSSTREAM):
      raise BassSyncError("this sync can only be set to a stream")
    
    super(BASSSYNC_META, self).Set(chan)
