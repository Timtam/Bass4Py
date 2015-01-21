from bass cimport HSTREAM,DWORD
cdef void CDOWNLOADPROC(const void *buffer,DWORD length,void *user)
cdef void __stdcall CDOWNLOADPROC_STD(const void *buffer,DWORD length,void *user)
cdef void __cdecl CDOWNLOADPROC_CDE(const void *buffer,DWORD length,void *user)
cdef class BASSSTREAM:
 cdef readonly HSTREAM __stream
 cpdef __Evaluate(BASSSTREAM self)
 cpdef Free(BASSSTREAM self)