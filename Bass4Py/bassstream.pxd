from .bass cimport (
                    HSTREAM,
                    DWORD,
                    QWORD
                   )

from .basschannel cimport BASSCHANNEL
from .basschannelattribute cimport BASSCHANNELATTRIBUTE

cdef class BASSSTREAM(BASSCHANNEL):

  cdef object __downloadproc
  cdef object __file
  cdef object __streamproc

  # attributes
  cdef readonly BASSCHANNELATTRIBUTE Bitrate
  cdef readonly BASSCHANNELATTRIBUTE NetResume
  cdef readonly BASSCHANNELATTRIBUTE ScanInfo

  cpdef Free(BASSSTREAM self)
  cpdef QWORD GetFilePosition(BASSSTREAM self, DWORD mode)
  cpdef DWORD PutData(BASSSTREAM self, char *buffer, DWORD length)
  cpdef DWORD PutFileData(BASSSTREAM self, char *buffer, DWORD length)