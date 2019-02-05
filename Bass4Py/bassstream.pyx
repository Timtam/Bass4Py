from libc.string cimport memmove
cimport bass
import basscallbacks
from basschannel cimport BASSCHANNEL
cdef void CDOWNLOADPROC(const void *buffer,DWORD length,void *user) with gil:
 cdef object cb
 cdef char *cbuffer
 cbuffer=<char *>buffer
 cb=basscallbacks.Callbacks.GetCallback(<int>user)
 pythonf=cb['function'][0]
 pythonf(<bytes>cbuffer[:length],length,cb['user'])
cdef void __stdcall CDOWNLOADPROC_STD(const void *buffer,DWORD length,void *user) with gil:
 CDOWNLOADPROC(buffer,length,user)
cdef DWORD CSTREAMPROC(DWORD handle,void *buffer,DWORD length,void *user) with gil:
 cdef DWORD blen
 cdef object cb,pythonf
 cdef char *cbuf
 cdef int i
 cdef bytes pythonbuf
 cdef BASSSTREAM stream=BASSSTREAM(handle)
 cb=basscallbacks.Callbacks.GetCallback(<int>user)
 pythonf=cb['function'][0]
 pythonbuf=pythonf(stream,length,cb['user'])
 blen=len(pythonbuf)
 if <DWORD>blen>length:
  pythonbuf=pythonbuf[:length]
  blen=<int>length
 cbuf=<char*>pythonbuf
 memmove(buffer,<const void*>cbuf,blen)
 return blen
cdef DWORD __stdcall CSTREAMPROC_STD(DWORD handle,void *buffer,DWORD length,void *user) with gil:
 cdef DWORD res=CSTREAMPROC(handle,buffer,length,user)
 return res
cdef void CFILECLOSEPROC(void *user) with gil:
 cdef object cb
 cdef object pythonf
 cb=basscallbacks.Callbacks.GetCallback(<int>user)
 pythonf=cb['function'][0]
 pythonf(cb['user'])
cdef void __stdcall CFILECLOSEPROC_STD(void *user) with gil:
 CFILECLOSEPROC(user)
cdef QWORD CFILELENPROC(void *user) with gil:
 cdef object cb,pythonf
 cdef QWORD res
 cb=basscallbacks.Callbacks.GetCallback(<int>user)
 pythonf=cb['function'][2]
 res=pythonf(cb['user'])
 return res
cdef QWORD __stdcall CFILELENPROC_STD(void *user) with gil:
 cdef QWORD res=CFILELENPROC(user)
 return res
cdef DWORD CFILEREADPROC(void *buffer,DWORD length,void *user) with gil:
 cdef object cb,pythonf
 cdef bytes str
 cdef char *cbuf
 cdef DWORD blen
 cb=basscallbacks.Callbacks.GetCallback(<int>user)
 pythonf=cb['function'][1]
 str=pythonf(length,cb['user'])
 blen=<DWORD>len(str)
 if blen>length:
  str=str[:length]
  blen=length
 cbuf=<char*>str
 memmove(buffer,<const void*>cbuf,blen)
 return blen
cdef DWORD __stdcall CFILEREADPROC_STD(void *buffer,DWORD length,void *user) with gil:
 cdef DWORD res=CFILEREADPROC(buffer,length,user)
 return res
cdef bint CFILESEEKPROC(QWORD offset,void *user) with gil:
 cdef object cb,pythonf
 cdef bint res
 cb=basscallbacks.Callbacks.GetCallback(<int>user)
 pythonf=cb['function'][3]
 res=pythonf(offset,cb['user'])
 return res
cdef bint __stdcall CFILESEEKPROC_STD(QWORD offset,void *user) with gil:
 cdef bint res=CFILESEEKPROC(offset,user)
 return res

cdef class BASSSTREAM(BASSCHANNEL):
  cpdef Free(BASSSTREAM self):
    cdef bint res = bass.BASS_StreamFree(self.__channel)
    bass.__Evaluate()
    return res

  cpdef QWORD GetFilePosition(BASSSTREAM self, DWORD mode):
    cdef QWORD res = bass.BASS_StreamGetFilePosition(self.__channel, mode)
    bass.__Evaluate()
    return res

  cpdef DWORD PutData(BASSSTREAM self, char *buffer, DWORD length):
    cdef DWORD res = bass.BASS_StreamPutData(self.__channel, <void*>buffer, length)
    bass.__Evaluate()
    return res

  cpdef DWORD PutFileData(BASSSTREAM self, char *buffer, DWORD length):
    cdef DWORD res = bass.BASS_StreamPutFileData(self.__channel, <void*>buffer, length)
    bass.__Evaluate()
    return res