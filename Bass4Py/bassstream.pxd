from .bass cimport (
                    HSTREAM,
                    DWORD,
                    QWORD
                   )

from .basschannel cimport BASSCHANNEL
from .basschannelattribute cimport BASSCHANNELATTRIBUTE

cdef void CDOWNLOADPROC(const void *buffer,DWORD length,void *user) with gil
cdef void __stdcall CDOWNLOADPROC_STD(const void *buffer,DWORD length,void *user) with gil
cdef DWORD CSTREAMPROC(DWORD handle,void *buffer,DWORD length,void *user) with gil
cdef DWORD __stdcall CSTREAMPROC_STD(DWORD handle,void *buffer,DWORD length,void *user) with gil
cdef void CFILECLOSEPROC(void *user) with gil
cdef void __stdcall CFILECLOSEPROC_STD(void *user) with gil
cdef QWORD CFILELENPROC(void *user) with gil
cdef QWORD __stdcall CFILELENPROC_STD(void *user) with gil
cdef DWORD CFILEREADPROC(void *buffer,DWORD length,void *user) with gil
cdef DWORD __stdcall CFILEREADPROC_STD(void *buffer,DWORD length,void *user) with gil
cdef bint CFILESEEKPROC(QWORD offset,void *user) with gil
cdef bint __stdcall CFILESEEKPROC_STD(QWORD offset,void *user) with gil

cdef class BASSSTREAM(BASSCHANNEL):

  # attributes
  cdef readonly BASSCHANNELATTRIBUTE Bitrate
  cdef readonly BASSCHANNELATTRIBUTE NetResume

  cpdef Free(BASSSTREAM self)
  cpdef QWORD GetFilePosition(BASSSTREAM self, DWORD mode)
  cpdef DWORD PutData(BASSSTREAM self, char *buffer, DWORD length)
  cpdef DWORD PutFileData(BASSSTREAM self, char *buffer, DWORD length)