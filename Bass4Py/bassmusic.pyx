cimport bass
from basschannel cimport BASSCHANNEL

cdef class BASSMUSIC(BASSCHANNEL):
  cpdef Free(BASSMUSIC self):
    cdef bint res = bass.BASS_MusicFree(self.__channel)
    bass.__Evaluate()
    return res