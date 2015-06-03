cimport bass
import basscallbacks
from bassexceptions import BassError, BassAPIError
from bassstream cimport *
from basssample cimport BASSSAMPLE
from types import FunctionType
cdef class BASSDEVICE:
 def __cinit__(BASSDEVICE self,int device):
  self.__device=device
 def __richcmp__(BASSDEVICE self,other,int op):
  if op==2:
   return (type(self)==type(other)) and (self.__device==other.__device)
 cpdef __Evaluate(BASSDEVICE self):
  cdef bass.DWORD error=bass.BASS_ErrorGetCode()
  if error!=bass.BASS_OK: raise BassError(error)
 cpdef __EvaluateSelected(BASSDEVICE self):
  cdef int currentdevice
  cdef bass.DWORD error
  currentdevice=bass.BASS_GetDevice()
  error=bass.BASS_ErrorGetCode()
  if error!=bass.BASS_OK:
   raise BassAPIError()
  if currentdevice!=self.__device:
   raise BassAPIError()
 cdef bass.BASS_DEVICEINFO __getdeviceinfo(BASSDEVICE self):
  cdef bass.BASS_DEVICEINFO info
  bass.BASS_GetDeviceInfo(self.__device,&info)
  return info
 cdef bass.BASS_INFO __getinfo(BASSDEVICE self):
  cdef bass.BASS_INFO info
  cdef bint res=bass.BASS_GetInfo(&info)
  return info
 cpdef Free(BASSDEVICE self):
   cdef bint res
   self.__EvaluateSelected()
   res=bass.BASS_Free()
   self.__Evaluate()
   return res
 cpdef Init(BASSDEVICE self,bass.DWORD freq, bass.DWORD flags, int win):
  cdef bass.HWND cwin=&win
  if win==0: cwin=NULL
  cdef bint res=bass.BASS_Init(self.__device,freq,flags,cwin,NULL)
  self.__Evaluate()
  return res
 cpdef Pause(BASSDEVICE self):
  cdef bint res
  self.__EvaluateSelected()
  res=bass.BASS_Pause()
  self.__Evaluate()
  return res
 cpdef Set(BASSDEVICE self):
  cdef bint res=bass.BASS_SetDevice(self.__device)
  self.__Evaluate()
  return res
 cpdef Start(BASSDEVICE self):
  cdef bint res
  self.__EvaluateSelected()
  res=bass.BASS_Start()
  self.__Evaluate()
  return res
 cpdef Stop(BASSDEVICE self):
  cdef bint res
  self.__EvaluateSelected()
  res=bass.BASS_Stop()
  self.__Evaluate()
  return res
 cpdef Update(BASSDEVICE self, bass.DWORD length):
  cdef bint res
  self.__EvaluateSelected()
  res=bass.BASS_Update(length)
  self.__Evaluate()
  return res
 cpdef StreamCreate(BASSDEVICE self,bass.DWORD freq,bass.DWORD chans,bass.DWORD flags,object proc,object user=None):
  cdef int cbpos,iproc
  cdef bass.STREAMPROC *cproc
  cdef bass.HSTREAM stream
  self.__EvaluateSelected()
  if type(proc)==FunctionType:
   cbpos=basscallbacks.Callbacks.AddCallback(proc,user)
   IF UNAME_SYSNAME=="Windows":
    cproc=<bass.STREAMPROC*>CSTREAMPROC_STD
   ELSE:
    cproc=<bass.STREAMPROC*>CSTREAMPROC
   stream=bass.BASS_StreamCreate(freq,chans,flags,cproc,<void*>cbpos)
  else:
   iproc=<int>proc
   stream=bass.BASS_StreamCreate(freq,chans,flags,<bass.STREAMPROC*>iproc,NULL)
  self.__Evaluate()
  return BASSSTREAM(stream)
 cpdef StreamCreateFile(BASSDEVICE self,bint mem,const char *file,bass.QWORD offset=0,bass.QWORD length=0,bass.DWORD flags=0):
  cdef bass.HSTREAM stream
  cdef void *ptr=<void*>file
  self.__EvaluateSelected()
  if mem and length==0: length=len(file)
  stream=bass.BASS_StreamCreateFile(mem,ptr,offset,length,flags)
  self.__Evaluate()
  return BASSSTREAM(stream)
 cpdef StreamCreateURL(BASSDEVICE self,const char *url,bass.DWORD offset,bass.DWORD flags,object proc=0,object user=None):
  cdef bass.DOWNLOADPROC *cproc
  cdef int pos
  cdef void *ptr
  cdef bass.HSTREAM stream
  self.__EvaluateSelected()
  if type(proc)==FunctionType:
   pos=basscallbacks.Callbacks.AddCallback(proc,user)
   ptr=<void*>pos
   IF UNAME_SYSNAME=="Windows":
    cproc=<bass.DOWNLOADPROC*>CDOWNLOADPROC_STD
   ELSE:
    cproc=<bass.DOWNLOADPROC*>CDOWNLOADPROC
   stream=bass.BASS_StreamCreateURL(url,offset,flags,cproc,ptr)
  else:
   stream=bass.BASS_StreamCreateURL(url,offset,flags,NULL,NULL)
  self.__Evaluate()
  return BASSSTREAM(stream)
 cpdef StreamCreateFileUser(BASSDEVICE self,bass.DWORD system,bass.DWORD flags,object close,object length,object read,object seek,object user=None):
  cdef int pos
  cdef bass.BASS_FILEPROCS procs
  cdef bass.HSTREAM stream
  self.__EvaluateSelected()
  if type(close)!=FunctionType or type(read)!=FunctionType or type(length)!=FunctionType or type(seek)!=FunctionType:
   raise BassAPIError()
  IF UNAME_SYSNAME=="Windows":
   procs.close=<bass.FILECLOSEPROC*>CFILECLOSEPROC_STD
   procs.read=<bass.FILEREADPROC*>CFILEREADPROC_STD
   procs.length=<bass.FILELENPROC*>CFILELENPROC_STD
   procs.seek=<bass.FILESEEKPROC*>CFILESEEKPROC_STD
  ELSE:
   procs.close=<bass.FILECLOSEPROC*>CFILECLOSEPROC
   procs.read=<bass.FILEREADPROC*>CFILEREADPROC
   procs.length=<bass.FILELENPROC*>CFILELENPROC
   procs.seek=<bass.FILESEEKPROC*>CFILESEEKPROC
  pos=basscallbacks.Callbacks.AddCallback(close,user)
  basscallbacks.Callbacks.AddCallback(read,user,pos)
  basscallbacks.Callbacks.AddCallback(length,user,pos)
  basscallbacks.Callbacks.AddCallback(seek,user,pos)
  stream=bass.BASS_StreamCreateFileUser(system,flags,&procs,<void*>pos)
  self.__Evaluate()
  return BASSSTREAM(stream)
 cpdef SampleLoad(BASSDEVICE self,bint mem,char *file,bass.QWORD offset=0,bass.DWORD length=0,bass.DWORD max=65535,bass.DWORD flags=0):
  cdef void *ptr=<void*>file
  cdef bass.HSAMPLE res
  self.__EvaluateSelected()
  if mem and length==0: length=len(file)
  res=bass.BASS_SampleLoad(mem,ptr,offset,length,max,flags)
  self.__Evaluate()
  return BASSSAMPLE(res)
 property Name:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_DEVICEINFO info=self.__getdeviceinfo()
   self.__Evaluate()
   return info.name
 property Driver:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_DEVICEINFO info=self.__getdeviceinfo()
   self.__Evaluate()
   return info.driver
 property Status:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_DEVICEINFO info=self.__getdeviceinfo()
   self.__Evaluate()
   return info.flags
 property Flags:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.flags
 property Memory:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.hwsize
 property MemoryFree:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.hwfree
 property FreeSamples:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.freesam
 property Free3D:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.free3d
 property MinimumRate:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.minrate
 property MaximumRate:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.maxrate
 property EAX:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.eax
 property DirectX:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.dsver
 property Buffer:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.minbuf
 property Latency:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.latency
 property InitFlags:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.initflags
 property Speakers:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.speakers
 property Frequency:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_INFO info=self.__getinfo()
   self.__EvaluateSelected()
   return info.freq
 property Volume:
  def __get__(BASSDEVICE self):
   cdef float volume
   self.__EvaluateSelected()
   volume=bass.BASS_GetVolume()
   self.__Evaluate()
   return volume
  def __set__(BASSDEVICE self,float value):
   cdef bint res
   self.__EvaluateSelected()
   res=bass.BASS_SetVolume(value)
   self.__Evaluate()