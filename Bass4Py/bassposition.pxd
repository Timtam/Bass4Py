from bass cimport DWORD
from basschannel cimport BASSCHANNEL
from bassmusic cimport BASSMUSIC
from basssample cimport BASSSAMPLE
from bassstream cimport BASSSTREAM
ctypedef fused Handles:
 BASSCHANNEL
 BASSMUSIC
 BASSSAMPLE
 BASSSTREAM
cdef class BASSPOSITION:
 cdef readonly object _handle
 cdef DWORD __gethandle(BASSPOSITION self)
 cpdef Link(BASSPOSITION self,Handles handle)
