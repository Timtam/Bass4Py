from .bass cimport DWORD, HCHANNEL

cdef extern from "tags.h" nogil:

  DWORD TAGS_GetVersion()
  bint TAGS_SetUTF8(bint)
  const char *TAGS_Read(DWORD, char *)
  const char *TAGS_ReadEx(DWORD, const char *fmt, DWORD, int)
  const char *TAGS_GetLastErrorDesc()

