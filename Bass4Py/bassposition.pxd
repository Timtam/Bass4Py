from bass cimport DWORD,QWORD
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
 cdef readonly object __handle
 cdef public bint Inexact
 cdef public bint Scan
 cdef DWORD __applyflags(BASSPOSITION self,DWORD *flags)
 cdef DWORD __gethandle(BASSPOSITION self)
 cpdef Link(BASSPOSITION self,Handles handle)
 cpdef GetOrder(BASSPOSITION self)
 cpdef SetOrder(BASSPOSITION self,tuple order)
 cpdef Reset(BASSPOSITION self,bint resetex=?)