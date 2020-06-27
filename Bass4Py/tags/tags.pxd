from ..bindings.bass cimport (
  DWORD,
  HCHANNEL)

cpdef GetVersion()

cdef class Tags:

  cdef HCHANNEL _channel
  cdef object _tagresult
  
  cpdef Read(Tags self, object fmt = ?, DWORD tagtype = ?)
  