from ..bass cimport (
                     _BASS_SYNC_OGG_CHANGE,
                     DWORD
                    )

from ..basschannel cimport BASSCHANNEL
from ..bassstream cimport BASSSTREAM
from ..basssync cimport BASSSYNC
from ..exceptions import BassSyncError

cdef class BASSSYNC_OGGCHANGE(BASSSYNC):
  def __cinit__(BASSSYNC_OGGCHANGE self):

    self.__type = _BASS_SYNC_OGG_CHANGE

  cpdef Set(BASSSYNC_OGGCHANGE self, BASSCHANNEL chan):
    if not isinstance(chan, BASSSTREAM):
      raise BassSyncError("this sync can only be set to a stream")
    
    super(BASSSYNC_OGGCHANGE, self).Set(chan)
