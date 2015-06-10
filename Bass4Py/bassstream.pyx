from libc.string cimport memmove
cimport bass
import basscallbacks
from basschannel cimport BASSCHANNEL
cdef void CDOWNLOADPROC(const void *buffer,bass.DWORD length,void *user) with gil:
 cdef object cb
 cdef int pos
 cdef char *cbuffer
 pos=<int>user
 cbuffer=<char *>buffer
 cb=basscallbacks.Callbacks.GetCallback(pos)
 pythonf=cb['function'][0]
 pythonf(<bytes>cbuffer[:length],length,cb['user'])
cdef void __stdcall CDOWNLOADPROC_STD(const void *buffer,bass.DWORD length,void *user) with gil:
 CDOWNLOADPROC(buffer,length,user)
cdef bass.DWORD CSTREAMPROC(bass.DWORD handle,void *buffer,bass.DWORD length,void *user) with gil:
 cdef bass.DWORD blen
 cdef object cb,pythonf
 cdef char *cbuf
 cdef int pos,i
 cdef bytes pythonbuf
 cdef BASSSTREAM stream
 stream=BASSSTREAM(handle)
 pos=<int>user
 cb=basscallbacks.Callbacks.GetCallback(pos)
 pythonf=cb['function'][0]
 pythonbuf=pythonf(stream,length,cb['user'])
 blen=<bass.DWORD>len(pythonbuf)
 if blen>length:
  pythonbuf=pythonbuf[:length]
  blen=length
 cbuf=<char*>pythonbuf
 memmove(buffer,<const void*>cbuf,blen)
 return blen
cdef bass.DWORD __stdcall CSTREAMPROC_STD(bass.DWORD handle,void *buffer,bass.DWORD length,void *user) with gil:
 cdef bass.DWORD res=CSTREAMPROC(handle,buffer,length,user)
 return res
cdef void CFILECLOSEPROC(void *user) with gil:
 cdef object cb
 cdef int pos
 cdef object pythonf
 pos=<int>user
 cb=basscallbacks.Callbacks.GetCallback(pos)
 pythonf=cb['function'][0]
 pythonf(cb['user'])
cdef void __stdcall CFILECLOSEPROC_STD(void *user) with gil:
 CFILECLOSEPROC(user)
cdef bass.QWORD CFILELENPROC(void *user) with gil:
 cdef object cb,pythonf
 cdef int pos
 cdef bass.QWORD res
 pos=<int>user
 cb=basscallbacks.Callbacks.GetCallback(pos)
 pythonf=cb['function'][2]
 res=pythonf(cb['user'])
 return res
cdef bass.QWORD __stdcall CFILELENPROC_STD(void *user) with gil:
 cdef bass.QWORD res=CFILELENPROC(user)
 return res
cdef bass.DWORD CFILEREADPROC(void *buffer,bass.DWORD length,void *user) with gil:
 cdef object cb,pythonf
 cdef int pos
 cdef bytes str
 cdef char *cbuf
 cdef bass.DWORD blen
 pos=<int>user
 cb=basscallbacks.Callbacks.GetCallback(pos)
 pythonf=cb['function'][1]
 str=pythonf(length,cb['user'])
 blen=<bass.DWORD>len(str)
 if blen>length:
  str=str[:length]
  blen=length
 cbuf=<char*>str
 memmove(buffer,<const void*>cbuf,blen)
 return blen
cdef bass.DWORD __stdcall CFILEREADPROC_STD(void *buffer,bass.DWORD length,void *user) with gil:
 cdef bass.DWORD res=CFILEREADPROC(buffer,length,user)
 return res
cdef bint CFILESEEKPROC(bass.QWORD offset,void *user) with gil:
 cdef object cb,pythonf
 cdef int pos
 cdef bint res
 pos=<int>user
 cb=basscallbacks.Callbacks.GetCallback(pos)
 pythonf=cb['function'][3]
 res=pythonf(offset,cb['user'])
 return res
cdef bint __stdcall CFILESEEKPROC_STD(bass.QWORD offset,void *user) with gil:
 cdef bint res=CFILESEEKPROC(offset,user)
 return res
cdef class BASSSTREAM(BASSCHANNEL):
 def __cinit__(BASSSTREAM self,bass.HSTREAM stream):
  self.__stream=stream
 cpdef Free(BASSSTREAM self):
  cdef bint res=bass.BASS_StreamFree(self.__stream)
  bass.__Evaluate()
  return res
 cpdef bass.QWORD GetFilePosition(BASSSTREAM self,bass.DWORD mode):
  cdef bass.QWORD res=bass.BASS_StreamGetFilePosition(self.__stream,mode)
  bass.__Evaluate()
  return res
 cpdef bass.DWORD PutData(BASSSTREAM self,char *buffer,bass.DWORD length):
  cdef bass.DWORD res=bass.BASS_StreamPutData(self.__stream,<void*>buffer,length)
  bass.__Evaluate()
  return res
 cpdef bass.DWORD PutFileData(BASSSTREAM self,char *buffer,bass.DWORD length):
  cdef bass.DWORD res=bass.BASS_StreamPutFileData(self.__stream,<void*>buffer,length)
  bass.__Evaluate()
  return res