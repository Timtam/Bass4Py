from .bass cimport (
                    HSTREAM,
                    DWORD,
                    QWORD
                   )

from .channel cimport CHANNEL
from .attribute cimport ATTRIBUTE

cdef class STREAM(CHANNEL):

  cdef object __downloadproc
  cdef object __file
  cdef object __streamproc

  # attributes
  cdef readonly ATTRIBUTE Bitrate
  cdef readonly ATTRIBUTE NetResume
  cdef readonly ATTRIBUTE ScanInfo

  cpdef Free(STREAM self)
  cpdef QWORD GetFilePosition(STREAM self, DWORD mode)
  cpdef DWORD PutData(STREAM self, const unsigned char[:] buffer, DWORD length)
  cpdef DWORD PutFileData(STREAM self, const unsigned char[:] buffer, DWORD length)