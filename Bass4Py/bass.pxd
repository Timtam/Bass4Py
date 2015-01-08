ctypedef unsigned long DWORD
ctypedef void* HWND
ctypedef unsigned long long QWORD

cdef extern from "bass.h":
 cdef DWORD BASS_GetVersion()
cdef inline unsigned int LOWORD(DWORD a):
 return a&0x0000ffff
cdef inline unsigned int HIWORD(DWORD a):
 return a>>16