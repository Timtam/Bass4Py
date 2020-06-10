from Bass4Py.BASS.bass cimport DWORD, HCHANNEL

cdef extern from "tags.h" nogil:

  DWORD TAGS_GetVersion()
  bint TAGS_SetUTF8(bint)
  char *TAGS_Read(DWORD, char *)
  char *TAGS_ReadEx(DWORD, char *fmt, DWORD, int)
  char *TAGS_GetLastErrorDesc()

cpdef GetVersion()

cdef class Tags:

  cdef HCHANNEL _channel
  cdef object _tagresult
  
  cpdef Read(Tags self, object fmt = ?, DWORD tagtype = ?)
  