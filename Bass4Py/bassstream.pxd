from bass cimport HSTREAM,DWORD,QWORD
cdef void CDOWNLOADPROC(const void *buffer,DWORD length,void *user)
cdef void __stdcall CDOWNLOADPROC_STD(const void *buffer,DWORD length,void *user)
cdef DWORD CSTREAMPROC(HSTREAM handle,void *buffer,DWORD length,void *user)
cdef DWORD __stdcall CSTREAMPROC_STD(HSTREAM handle,void *buffer,DWORD length,void *user)
cdef class BASSSTREAM:
 cdef readonly HSTREAM __stream
 cpdef __Evaluate(BASSSTREAM self)
 cpdef Free(BASSSTREAM self)
 cpdef QWORD GetFilePosition(BASSSTREAM self,DWORD mode)
 cpdef DWORD PutData(BASSSTREAM self,char *buffer,DWORD length)
 cpdef DWORD PutFileData(BASSSTREAM self,char *buffer,DWORD length)