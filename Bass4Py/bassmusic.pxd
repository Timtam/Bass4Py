from bass cimport HMUSIC
from basschannel cimport BASSCHANNEL
cdef class BASSMUSIC(BASSCHANNEL):
 cdef readonly HMUSIC __music
 cpdef Free(BASSMUSIC self)