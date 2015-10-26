from libc.string cimport memmove
cimport bass
from basschannel cimport BASSCHANNEL
import basscallbacks
cdef void CDSPPROC(HDSP dsp, DWORD channel, void *buffer,DWORD length,void *user) with gil:
 cdef BASSDSP odsp=BASSDSP(channel,dsp)
 cdef bytes result
 cdef object cb
 cdef char *cbuffer
 cbuffer=<char *>buffer
 cb=basscallbacks.Callbacks.GetCallback(<int>user)
 result=cb['function'][0](odsp,<bytes>cbuffer[:length],cb['user'])
 if <DWORD>len(result)>length:
  result=result[:length]
 memmove(buffer,<const void *>result,length)
cdef void __stdcall CDSPPROC_STD(HDSP dsp, DWORD channel, void *buffer,DWORD length,void *user) with gil:
 CDSPPROC(dsp,channel,buffer,length,user)
cdef class BASSDSP:
 def __cinit__(BASSDSP self,DWORD channel,HDSP dsp):
  self.__dsp=dsp
  self.__channel=channel
 cpdef Remove(BASSDSP self):
  cdef bint res=bass.BASS_ChannelRemoveDSP(self.__channel,self.__dsp)
  bass.__Evaluate()
  return res
 property Channel:
  def __get__(BASSDSP self):
   return BASSCHANNEL(self.__channel)