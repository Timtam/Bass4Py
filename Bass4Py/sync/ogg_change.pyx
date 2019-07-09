from ..bass cimport (
                     _BASS_SYNC_OGG_CHANGE,
                     DWORD
                    )

from ..basssync cimport BASSSYNC

cdef class BASSSYNC_OGGCHANGE(BASSSYNC):
  def __cinit__(BASSSYNC_OGGCHANGE self):

    self.__type = _BASS_SYNC_OGG_CHANGE
