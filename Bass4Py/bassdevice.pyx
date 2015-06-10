cimport bass
import basscallbacks
from bassexceptions import BassAPIError
from bassstream cimport *
from basssample cimport BASSSAMPLE
from bassmusic cimport BASSMUSIC
cimport bassvector
from types import FunctionType
__EAXPresets={
 bass.EAX_PRESET_GENERIC:(bass.EAX_ENVIRONMENT_GENERIC,0.5,1.493,0.5),
 bass.EAX_PRESET_PADDEDCELL:(bass.EAX_ENVIRONMENT_PADDEDCELL,0.25,0.1,0.0),
 bass.EAX_PRESET_ROOM:(bass.EAX_ENVIRONMENT_ROOM,0.417,0.4,0.666),
 bass.EAX_PRESET_BATHROOM:(bass.EAX_ENVIRONMENT_BATHROOM,0.653,1.499,0.166),
 bass.EAX_PRESET_LIVINGROOM:(bass.EAX_ENVIRONMENT_LIVINGROOM,0.208,0.478,0.0),
 bass.EAX_PRESET_STONEROOM:(bass.EAX_ENVIRONMENT_STONEROOM,0.5,2.309,0.888),
 bass.EAX_PRESET_AUDITORIUM:(bass.EAX_ENVIRONMENT_AUDITORIUM,0.403,4.279,0.5),
 bass.EAX_PRESET_CONCERTHALL:(bass.EAX_ENVIRONMENT_CONCERTHALL,0.5,3.961,0.5),
 bass.EAX_PRESET_CAVE:(bass.EAX_ENVIRONMENT_CAVE,0.5,2.886,1.304),
 bass.EAX_PRESET_ARENA:(bass.EAX_ENVIRONMENT_ARENA,0.361,7.284,0.332),
 bass.EAX_PRESET_HANGAR:(bass.EAX_ENVIRONMENT_HANGAR,0.5,10.0,0.3),
 bass.EAX_PRESET_CARPETEDHALLWAY:(bass.EAX_ENVIRONMENT_CARPETEDHALLWAY,0.153,0.259,2.0),
 bass.EAX_PRESET_HALLWAY:(bass.EAX_ENVIRONMENT_HALLWAY,0.361,1.493,0.0),
 bass.EAX_PRESET_STONECORRIDOR:(bass.EAX_ENVIRONMENT_STONECORRIDOR,0.444,2.697,0.638),
 bass.EAX_PRESET_ALLEY:(bass.EAX_ENVIRONMENT_ALLEY,0.25,1.752,0.776),
 bass.EAX_PRESET_FOREST:(bass.EAX_ENVIRONMENT_FOREST,0.111,3.145,0.472),
 bass.EAX_PRESET_CITY:(bass.EAX_ENVIRONMENT_CITY,0.111,2.767,0.224),
 bass.EAX_PRESET_MOUNTAINS:(bass.EAX_ENVIRONMENT_MOUNTAINS,0.194,7.841,0.472),
 bass.EAX_PRESET_QUARRY:(bass.EAX_ENVIRONMENT_QUARRY,1.0,1.499,0.5),
 bass.EAX_PRESET_PLAIN:(bass.EAX_ENVIRONMENT_PLAIN,0.097,2.767,0.224),
 bass.EAX_PRESET_PARKINGLOT:(bass.EAX_ENVIRONMENT_PARKINGLOT,0.208,1.652,1.5),
 bass.EAX_PRESET_SEWERPIPE:(bass.EAX_ENVIRONMENT_SEWERPIPE,0.652,2.886,0.25),
 bass.EAX_PRESET_UNDERWATER:(bass.EAX_ENVIRONMENT_UNDERWATER,1.0,1.499,0.0),
 bass.EAX_PRESET_DRUGGED:(bass.EAX_ENVIRONMENT_DRUGGED,0.875,8.392,1.388),
 bass.EAX_PRESET_DIZZY:(bass.EAX_ENVIRONMENT_DIZZY,0.139,17.234,0.666),
 bass.EAX_PRESET_PSYCHOTIC:(bass.EAX_ENVIRONMENT_PSYCHOTIC,0.486,7.563,0.806)
}

cdef class BASSDEVICE:
 def __cinit__(BASSDEVICE self,int device):
  self.__device=device
 def __richcmp__(BASSDEVICE self,other,int op):
  if op==2:
   return (type(self)==type(other)) and (self.__device==other.__device)
 cpdef __EvaluateSelected(BASSDEVICE self):
  cdef int currentdevice
  cdef bass.DWORD error
  currentdevice=bass.BASS_GetDevice()
  error=bass.BASS_ErrorGetCode()
  if error!=bass.BASS_OK:
   raise BassAPIError()
  if currentdevice!=self.__device:
   raise BassAPIError()
 cdef inline bass.BASS_DEVICEINFO __getdeviceinfo(BASSDEVICE self):
  cdef bass.BASS_DEVICEINFO info
  bass.BASS_GetDeviceInfo(self.__device,&info)
  return info
 cdef inline bass.BASS_INFO __getinfo(BASSDEVICE self):
  cdef bass.BASS_INFO info
  cdef bint res=bass.BASS_GetInfo(&info)
  return info
 cpdef Free(BASSDEVICE self):
   cdef bint res
   self.__EvaluateSelected()
   res=bass.BASS_Free()
   bass.__Evaluate()
   return res
 cpdef Init(BASSDEVICE self,bass.DWORD freq, bass.DWORD flags, int win):
  cdef bass.HWND cwin=&win
  if win==0: cwin=NULL
  cdef bint res=bass.BASS_Init(self.__device,freq,flags,cwin,NULL)
  bass.__Evaluate()
  return res
 cpdef Pause(BASSDEVICE self):
  cdef bint res
  self.__EvaluateSelected()
  res=bass.BASS_Pause()
  bass.__Evaluate()
  return res
 cpdef Set(BASSDEVICE self):
  cdef bint res=bass.BASS_SetDevice(self.__device)
  bass.__Evaluate()
  return res
 cpdef Start(BASSDEVICE self):
  cdef bint res
  self.__EvaluateSelected()
  res=bass.BASS_Start()
  bass.__Evaluate()
  return res
 cpdef Stop(BASSDEVICE self):
  cdef bint res
  self.__EvaluateSelected()
  res=bass.BASS_Stop()
  bass.__Evaluate()
  return res
 cpdef Update(BASSDEVICE self, bass.DWORD length):
  cdef bint res
  self.__EvaluateSelected()
  res=bass.BASS_Update(length)
  bass.__Evaluate()
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
  bass.__Evaluate()
  return BASSSTREAM(stream)
 cpdef StreamCreateFile(BASSDEVICE self,bint mem,const char *file,bass.QWORD offset=0,bass.QWORD length=0,bass.DWORD flags=0):
  cdef bass.HSTREAM stream
  cdef void *ptr=<void*>file
  self.__EvaluateSelected()
  if mem and length==0: length=len(file)
  stream=bass.BASS_StreamCreateFile(mem,ptr,offset,length,flags)
  bass.__Evaluate()
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
  bass.__Evaluate()
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
  bass.__Evaluate()
  return BASSSTREAM(stream)
 cpdef SampleLoad(BASSDEVICE self,bint mem,char *file,bass.QWORD offset=0,bass.DWORD length=0,bass.DWORD max=65535,bass.DWORD flags=0):
  cdef void *ptr=<void*>file
  cdef bass.HSAMPLE res
  self.__EvaluateSelected()
  if mem and length==0: length=len(file)
  res=bass.BASS_SampleLoad(mem,ptr,offset,length,max,flags)
  bass.__Evaluate()
  return BASSSAMPLE(res)
 cpdef SampleCreate(BASSDEVICE self,bass.DWORD length,bass.DWORD freq,bass.DWORD chans,bass.DWORD max,bass.DWORD flags):
  cdef bass.HSAMPLE res
  self.__EvaluateSelected()
  res=bass.BASS_SampleCreate(length,freq,chans,max,flags)
  bass.__Evaluate()
  return BASSSAMPLE(res)
 cpdef MusicLoad(BASSDEVICE self,bint mem,char *file,bass.QWORD offset,bass.DWORD length,bass.DWORD flags,bass.DWORD freq):
  cdef void *ptr=<void*>file
  cdef bass.HMUSIC res
  self.__EvaluateSelected()
  res=bass.BASS_MusicLoad(mem,ptr,offset,length,flags,freq)
  bass.__Evaluate()
  return BASSMUSIC(res)
 IF UNAME_SYSNAME=="Windows":
  cpdef EAXPreset(BASSDEVICE self,int preset):
   cdef int env
   cdef float vol,decay,damp
   self.__EvaluateSelected()
   if not preset in __EAXPresets:
    raise BassAPIError
   env=<int>__EAXPresets[preset][0]
   vol=<float>__EAXPresets[preset][1]
   decay=<float>__EAXPresets[preset][2]
   damp=<float>__EAXPresets[preset][3]
   bass.BASS_SetEAXParameters(env,vol,decay,damp)
   bass.__Evaluate()
 property Name:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_DEVICEINFO info=self.__getdeviceinfo()
   bass.__Evaluate()
   return info.name
 property Driver:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_DEVICEINFO info=self.__getdeviceinfo()
   bass.__Evaluate()
   return info.driver
 property Status:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_DEVICEINFO info=self.__getdeviceinfo()
   bass.__Evaluate()
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
   bass.__Evaluate()
   return volume
  def __set__(BASSDEVICE self,float value):
   cdef bint res
   self.__EvaluateSelected()
   res=bass.BASS_SetVolume(value)
   bass.__Evaluate()
 property Position:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_3DVECTOR pos
   self.__EvaluateSelected()
   bass.BASS_Get3DPosition(&pos,NULL,NULL,NULL)
   bass.__Evaluate()
   return bassvector.BASSVECTOR_Create(&pos)
  def __set__(BASSDEVICE self,bassvector.BASSVECTOR value):
   cdef bass.BASS_3DVECTOR pos
   cdef bint res
   self.__EvaluateSelected()
   value.Resolve(&pos)
   res=bass.BASS_Set3DPosition(&pos,NULL,NULL,NULL)
   bass.__Evaluate()
   bass.BASS_Apply3D()
 property Velocity:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_3DVECTOR vel
   self.__EvaluateSelected()
   bass.BASS_Get3DPosition(NULL,&vel,NULL,NULL)
   bass.__Evaluate()
   return bassvector.BASSVECTOR_Create(&vel)
  def __set__(BASSDEVICE self,bassvector.BASSVECTOR value):
   cdef bass.BASS_3DVECTOR vel
   cdef bint res
   self.__EvaluateSelected()
   value.Resolve(&vel)
   res=bass.BASS_Set3DPosition(NULL,&vel,NULL,NULL)
   bass.__Evaluate()
   bass.BASS_Apply3D()
 property Front:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_3DVECTOR front,top
   self.__EvaluateSelected()
   bass.BASS_Get3DPosition(NULL,NULL,&front,&top)
   bass.__Evaluate()
   return bassvector.BASSVECTOR_Create(&front)
  def __set__(BASSDEVICE self,bassvector.BASSVECTOR value):
   cdef bass.BASS_3DVECTOR front,top
   cdef bint res
   self.__EvaluateSelected()
   bass.BASS_Get3DPosition(NULL,NULL,&front,&top)
   value.Resolve(&front)
   res=bass.BASS_Set3DPosition(NULL,NULL,&front,&top)
   bass.__Evaluate()
   bass.BASS_Apply3D()
 property Top:
  def __get__(BASSDEVICE self):
   cdef bass.BASS_3DVECTOR front,top
   self.__EvaluateSelected()
   bass.BASS_Get3DPosition(NULL,NULL,&front,&top)
   bass.__Evaluate()
   return bassvector.BASSVECTOR_Create(&top)
  def __set__(BASSDEVICE self,bassvector.BASSVECTOR value):
   cdef bass.BASS_3DVECTOR front,top
   cdef bint res
   self.__EvaluateSelected()
   bass.BASS_Get3DPosition(NULL,NULL,&front,&top)
   value.Resolve(&top)
   res=bass.BASS_Set3DPosition(NULL,NULL,&front,&top)
   bass.__Evaluate()
   bass.BASS_Apply3D()
 property Distance:
  def __get__(BASSDEVICE self):
   cdef float distf
   self.__EvaluateSelected()
   bass.BASS_Get3DFactors(&distf,NULL,NULL)
   bass.__Evaluate()
   return distf
  def __set__(BASSDEVICE self,float value):
   cdef float distf=value
   self.__EvaluateSelected()
   bass.BASS_Set3DFactors(distf,-1.0,-1.0)
   bass.__Evaluate()
   bass.BASS_Apply3D()
 property Rolloff:
  def __get__(BASSDEVICE self):
   cdef float rollf
   self.__EvaluateSelected()
   bass.BASS_Get3DFactors(NULL,&rollf,NULL)
   bass.__Evaluate()
   return rollf
  def __set__(BASSDEVICE self,float value):
   cdef float rollf=value
   self.__EvaluateSelected()
   bass.BASS_Set3DFactors(-1.0,rollf,-1.0)
   bass.__Evaluate()
   bass.BASS_Apply3D()
 property Doppler:
  def __get__(BASSDEVICE self):
   cdef float doppf
   self.__EvaluateSelected()
   bass.BASS_Get3DFactors(NULL,NULL,&doppf)
   bass.__Evaluate()
   return doppf
  def __set__(BASSDEVICE self,float value):
   cdef float doppf=value
   self.__EvaluateSelected()
   bass.BASS_Set3DFactors(-1.0,-1.0,doppf)
   bass.__Evaluate()
   bass.BASS_Apply3D()
 IF UNAME_SYSNAME=="Windows":
  property EAXEnvironment:
   def __get__(BASSDEVICE self):
    cdef bass.DWORD env
    self.__EvaluateSelected()
    bass.BASS_GetEAXParameters(&env,NULL,NULL,NULL)
    bass.__Evaluate()
    return <int>env
   def __set__(BASSDEVICE self,int value):
    cdef int env=value
    self.__EvaluateSelected()
    bass.BASS_SetEAXParameters(env,-1.0,-1.0,-1.0)
    bass.__Evaluate()
  property EAXVolume:
   def __get__(BASSDEVICE self):
    cdef float vol
    self.__EvaluateSelected()
    bass.BASS_GetEAXParameters(NULL,&vol,NULL,NULL)
    bass.__Evaluate()
    return vol
   def __set__(BASSDEVICE self,float value):
    cdef float vol=value
    self.__EvaluateSelected()
    bass.BASS_SetEAXParameters(-1,vol,-1.0,-1.0)
    bass.__Evaluate()
  property EAXDecay:
   def __get__(BASSDEVICE self):
    cdef float decay
    self.__EvaluateSelected()
    bass.BASS_GetEAXParameters(NULL,NULL,&decay,NULL)
    bass.__Evaluate()
    return decay
   def __set__(BASSDEVICE self,float value):
    cdef float decay=value
    self.__EvaluateSelected()
    bass.BASS_SetEAXParameters(-1,-1.0,decay,-1.0)
    bass.__Evaluate()
  property EAXDamping:
   def __get__(BASSDEVICE self):
    cdef float damp
    self.__EvaluateSelected()
    bass.BASS_GetEAXParameters(NULL,NULL,NULL,&damp)
    bass.__Evaluate()
    return damp
   def __set__(BASSDEVICE self,float value):
    cdef float damp=value
    self.__EvaluateSelected()
    bass.BASS_SetEAXParameters(-1,-1.0,-1.0,damp)
    bass.__Evaluate()
