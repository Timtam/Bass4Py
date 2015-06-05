cimport bass
from basschannel cimport BASSCHANNEL
from bassexceptions import BassError
from libc.stdlib cimport malloc,free
from libc.string cimport memmove
cdef class BASSSAMPLE:
 def __cinit__(BASSSAMPLE self,bass.HSAMPLE sample):
  self.__sample=sample
 cdef bass.BASS_SAMPLE __getinfo(BASSSAMPLE self):
  cdef bass.BASS_SAMPLE info
  cdef bint res=bass.BASS_SampleGetInfo(self.__sample,&info)
  return info
 cpdef __Evaluate(BASSSAMPLE self):
  cdef bass.DWORD error=bass.BASS_ErrorGetCode()
  if error!=bass.BASS_OK: raise BassError(error)
 cpdef Free(BASSSAMPLE self):
  cdef bint res=bass.BASS_SampleFree(self.__sample)
  self.__Evaluate()
  return res
 cpdef GetChannel(BASSSAMPLE self,bint onlynew):
  cdef bass.HCHANNEL res=bass.BASS_SampleGetChannel(self.__sample,onlynew)
  self.__Evaluate()
  return BASSCHANNEL(res)
 cpdef Stop(BASSSAMPLE self):
  cdef bint res=bass.BASS_SampleStop(self.__sample)
  self.__Evaluate()
  return res
 property ChannelCount:
  def __get__(BASSSAMPLE self):
   cdef bass.DWORD res=bass.BASS_SampleGetChannels(self.__sample,NULL)
   self.__Evaluate()
   return res
 property Frequency:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.freq
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.freq=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property Volume:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.volume
  def __set__(BASSSAMPLE self,float value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.volume=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property Pan:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.pan
  def __set__(BASSSAMPLE self,float value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.pan=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property Flags:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.flags
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.flags=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property Length:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.length
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.length=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property Max:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.max
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.max=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property Resolution:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.origres
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.origres=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property InitChannelCount:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.chans
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.chans=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property MinimumGap:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.mingap
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.mingap=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property Mode3D:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.mode3d
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.mode3d=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property MinimumDistance:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.mindist
  def __set__(BASSSAMPLE self,float value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.mindist=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property MaximumDistance:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.maxdist
  def __set__(BASSSAMPLE self,float value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.maxdist=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property InnerAngle:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.iangle
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.iangle=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property OuterAngle:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.oangle
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.oangle=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property OuterVolume:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.outvol
  def __set__(BASSSAMPLE self,float value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.outvol=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property VAM:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.vam
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.vam=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property Priority:
  def __get__(BASSSAMPLE self):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   self.__Evaluate()
   return info.priority
  def __set__(BASSSAMPLE self,bass.DWORD value):
   cdef bass.BASS_SAMPLE info=self.__getinfo()
   info.priority=value
   bass.BASS_SampleSetInfo(self.__sample,&info)
   self.__Evaluate()
 property Channels:
  def __get__(BASSSAMPLE self):
   cdef int chans,i
   cdef bass.HCHANNEL *channels
   cdef bass.DWORD res
   cdef object ret=[]
   chans=self.InitChannelCount
   channels=<bass.HCHANNEL*>malloc(chans*sizeof(bass.HCHANNEL))
   if channels==NULL: return []
   res=bass.BASS_SampleGetChannels(self.__sample,channels)
   if res==-1:
    free(<void*>channels)
    self.__Evaluate()
   for i in range(chans):
    ret.append(BASSCHANNEL(channels[i]))
   free(<void*>channels)
   return ret
 property Data:
  def __get__(BASSSAMPLE self):
   cdef int len
   cdef bint res
   cdef bytes ret
   cdef void *buffer
   cdef char *cbuffer
   len=self.Length
   buffer=malloc(len)
   if buffer==NULL: return ''
   res=bass.BASS_SampleGetData(self.__sample,buffer)
   if not res:
    free(buffer)
    self.__Evaluate()
   cbuffer=<char*>buffer
   ret=cbuffer[:len-1]
   free(buffer)
   return ret
  def __set__(BASSSAMPLE self,bytes data):
   cdef bint res
   cdef void *buffer
   cdef int length
   length=self.Length
   buffer=malloc(length)
   if buffer==NULL: return
   if len(data)>length: data=data[:length]
   length=len(data)
   memmove(buffer,<const void *>data,length)
   res=bass.BASS_SampleSetData(self.__sample,buffer)
   free(buffer)
   self.__Evaluate()