from ..bass cimport (
                     _BASS_SYNC_SLIDE,
                     DWORD
                    )

from ..basschannelattribute cimport BASSCHANNELATTRIBUTE
from ..basssync cimport BASSSYNC

cdef class BASSSYNC_SLIDE(BASSSYNC):
  def __cinit__(BASSSYNC_SLIDE self):

    self.__type = _BASS_SYNC_SLIDE
    self.__forcemixtime = True
    self.__mixtime = True

  cpdef _call_callback(BASSSYNC_SLIDE self, DWORD data):
    self.__func(self, BASSCHANNELATTRIBUTE(self.__channel, data))
