from ..bass cimport (
                     _BASS_SYNC_SLIDE,
                     DWORD
                    )

from ..attribute cimport ATTRIBUTE
from ..sync cimport SYNC

cdef class SYNC_SLIDE(SYNC):
  def __cinit__(SYNC_SLIDE self):

    self.__type = _BASS_SYNC_SLIDE
    self.__forcemixtime = True
    self.__mixtime = True

  cpdef _call_callback(SYNC_SLIDE self, DWORD data):
    self.__func(self, ATTRIBUTE(self.__channel, data))
