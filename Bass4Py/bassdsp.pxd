from bass cimport HDSP,DWORD
cdef void CDSPPROC(HDSP dsp, DWORD channel, void *buffer,DWORD length,void *user) with gil
cdef void __stdcall CDSPPROC_STD(HDSP dsp, DWORD channel, void *buffer,DWORD length,void *user) with gil
cdef class BASSDSP:
 cdef HDSP __dsp
 cdef DWORD __channel
 cpdef Remove(BASSDSP self)