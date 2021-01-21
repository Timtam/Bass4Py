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
  cdef readonly Attribute bitrate
  cdef readonly Attribute net_resume
  cdef readonly Attribute scan_info

  cdef readonly object tags

  cpdef free(Stream self)
  cpdef QWORD get_file_position(Stream self, DWORD mode)
  cpdef DWORD put_data(Stream self, const unsigned char[:] buffer, DWORD length)
  cpdef DWORD put_file_data(Stream self, const unsigned char[:] buffer, DWORD length)
  cpdef update(Stream self, DWORD length)