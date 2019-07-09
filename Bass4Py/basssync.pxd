from .bass cimport DWORD,HSYNC
cdef void CSYNCPROC(HSYNC handle,DWORD channel,DWORD data,void *user) with gil
cdef void __stdcall CSYNCPROC_STD(HSYNC handle,DWORD channel,DWORD data,void *user) with gil
cdef class BASSSYNC:
 cdef DWORD __channel
 cdef HSYNC __sync
 cpdef Remove(BASSSYNC self)