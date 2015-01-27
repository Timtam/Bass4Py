cimport bass
from bassexceptions import BassError
cdef class BASSCHANNEL:
 def __cinit__(BASSCHANNEL self,bass.HCHANNEL channel):
  self.__channel=channel
 cpdef __Evaluate(BASSCHANNEL self):
  cdef bass.DWORD error=bass.BASS_ErrorGetCode()
  if error!=bass.BASS_OK: raise BassError(error)
 cpdef Play(BASSCHANNEL self,bint restart):
  cdef bint res=bass.BASS_ChannelPlay(self.__channel,restart)
  self.__Evaluate()
  return res