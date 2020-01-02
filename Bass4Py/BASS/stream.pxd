from .bass cimport (
                    HSTREAM,
                    DWORD,
                    QWORD
                   )

from .channel cimport Channel
from .attribute cimport Attribute

cdef class Stream(Channel):

  cdef object __downloadproc
  cdef object __file
  cdef object __streamproc

  # attributes
  cdef readonly Attribute Bitrate
  cdef readonly Attribute NetResume
  cdef readonly Attribute ScanInfo

  cpdef Free(Stream self)
  cpdef QWORD GetFilePosition(Stream self, DWORD mode)
  cpdef DWORD PutData(Stream self, const unsigned char[:] buffer, DWORD length)
  cpdef DWORD PutFileData(Stream self, const unsigned char[:] buffer, DWORD length)
  cpdef Update(Stream self, DWORD length)