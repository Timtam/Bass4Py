cimport bass
import basscallbacks
from basschannel cimport BASSCHANNEL
cdef void CSYNCPROC(HSYNC handle,DWORD channel,DWORD data,void *user) with gil:
 cdef object cb
 cdef BASSSYNC osync=BASSSYNC(channel,handle)
 cdef BASSCHANNEL ochannel=BASSCHANNEL(channel)
 cb=basscallbacks.Callbacks.GetCallback(<int>user)
 cb['function'][0](osync,ochannel,data,cb['user'])
cdef void __stdcall CSYNCPROC_STD(HSYNC handle,DWORD channel,DWORD data,void *user) with gil:
 CSYNCPROC(handle,channel,data,user)
cdef class BASSSYNC:
 def __cinit__(BASSSYNC self,DWORD channel,HSYNC sync):
  self.__channel=channel
  self.__sync=sync
 cpdef Remove(BASSSYNC self):
  cdef bint res
  res=bass.BASS_ChannelRemoveSync(self.__channel,self.__sync)
  bass.__Evaluate()
  return res
 property Channel:
  def __get__(BASSSYNC self):
   return BASSCHANNEL(self.__channel)