cimport bass
import basscallbacks
from bassexceptions import BassError
cdef void CDOWNLOADPROC(const void *buffer,bass.DWORD length,void *user):
 cdef object cb
 cdef int pos
 cdef char *cbuffer
 pos=<int>user
 cbuffer=<char *>buffer
 cb=basscallbacks.Callbacks.GetCallback(pos)
 pythonf=cb['function']
 pythonf(<bytes>cbuffer[:length],length,cb['user'])
 if buffer==NULL:
  basscallbacks.Callbacks.DeleteCallback(pos)
cdef void __stdcall CDOWNLOADPROC_STD(const void *buffer,bass.DWORD length,void *user):
 CDOWNLOADPROC(buffer,length,user)
cdef void __cdecl CDOWNLOADPROC_CDE(const void *buffer,bass.DWORD length,void *user):
 CDOWNLOADPROC(buffer,length,user)
cdef class BASSSTREAM:
 def __cinit__(BASSSTREAM self,bass.HSTREAM stream):
  self.__stream=stream
 cpdef __Evaluate(BASSSTREAM self):
  cdef bass.DWORD error=bass.BASS_ErrorGetCode()
  if error!=bass.BASS_OK: raise BassError(error)
 cpdef Free(BASSSTREAM self):
  cdef bint res=bass.BASS_StreamFree(self.__stream)
  self.__Evaluate()
  return res