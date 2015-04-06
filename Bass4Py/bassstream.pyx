from libc.string cimport memmove
cimport bass
import basscallbacks
from basschannel cimport BASSCHANNEL
from bassexceptions import BassError
cdef void CDOWNLOADPROC(const void *buffer,bass.DWORD length,void *user) with gil:
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
 pythonf=cb['function']
 pythonbuf=pythonf(stream,length,cb['user'])
 blen=<bass.DWORD>len(pythonbuf)
 if blen>length:
  pythonbuf=pythonbuf[:length]
  blen=length
 cbuf=<char*>pythonbuf
 memmove(buffer,<const void*>cbuf,blen)
 return blen
cdef bass.DWORD __stdcall CSTREAMPROC_STD(bass.DWORD handle,void *buffer,bass.DWORD length,void *user) with gil:
 cdef bass.DWORD res
 res=CSTREAMPROC(handle,buffer,length,user)
 return res
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
 cpdef bass.QWORD GetFilePosition(BASSSTREAM self,bass.DWORD mode):
  cdef bass.QWORD res=bass.BASS_StreamGetFilePosition(self.__stream,mode)
  self.__Evaluate()
  return res
 cpdef bass.DWORD PutData(BASSSTREAM self,char *buffer,bass.DWORD length):
  cdef bass.DWORD res=bass.BASS_StreamPutData(self.__stream,<void*>buffer,length)
  self.__Evaluate()
  return res
 cpdef bass.DWORD PutFileData(BASSSTREAM self,char *buffer,bass.DWORD length):
  cdef bass.DWORD res=bass.BASS_StreamPutFileData(self.__stream,<void*>buffer,length)
  self.__Evaluate()
  return res
 property Channel:
  def __get__(BASSSTREAM self):
   return BASSCHANNEL(self.__stream)