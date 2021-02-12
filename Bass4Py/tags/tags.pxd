from ..bindings.bass cimport (
  DWORD,
  HCHANNEL)

cpdef get_version()

cdef class Tags:

  cdef HCHANNEL _channel
  cdef object _tag_result
  
  cpdef read(Tags self, object fmt = ?, DWORD tagtype = ?)
  