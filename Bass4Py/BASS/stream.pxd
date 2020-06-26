from ..bindings.bass cimport (
  HSTREAM,
  DWORD,
  QWORD)

from .channel cimport Channel
from .attribute cimport Attribute

cdef class Stream(Channel):

  cdef object _downloadproc
  cdef object _file
  cdef object _streamproc

  # attributes
  cdef readonly Attribute Bitrate
  cdef readonly Attribute NetResume
  cdef readonly Attribute ScanInfo

  cdef readonly object Tags

  cpdef Free(Stream self)
  cpdef QWORD GetFilePosition(Stream self, DWORD mode)
  cpdef DWORD PutData(Stream self, const unsigned char[:] buffer, DWORD length)
  cpdef DWORD PutFileData(Stream self, const unsigned char[:] buffer, DWORD length)
  cpdef Update(Stream self, DWORD length)