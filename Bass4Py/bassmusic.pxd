from bass cimport HCHANNEL
from basschannel cimport BASSCHANNEL

cdef class BASSMUSIC(BASSCHANNEL):
  cpdef Free(BASSMUSIC self)