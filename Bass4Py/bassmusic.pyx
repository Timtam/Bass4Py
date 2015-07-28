cimport bass
from basschannel cimport BASSCHANNEL
cdef class BASSMUSIC(BASSCHANNEL):
 def __cinit__(BASSMUSIC self,HMUSIC music):
  self.__music=music
 cpdef Free(BASSMUSIC self):
  cdef bint res=bass.BASS_MusicFree(self.__music)
  bass.__Evaluate()
  return res