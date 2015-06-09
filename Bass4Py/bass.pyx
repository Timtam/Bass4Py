from bassdevice cimport BASSDEVICE
from bassexceptions import BassError,BassAPIError
from bassplugin cimport BASSPLUGIN
from bassversion cimport BASSVERSION
__PtrConfigs=[BASS_CONFIG_NET_AGENT,BASS_CONFIG_NET_PROXY]
cdef extern from "Python.h":
 void PyEval_InitThreads()
cdef class BASS:
 def __cinit__(BASS self):
  PyEval_InitThreads()
 cpdef __Evaluate(BASS self):
  cdef DWORD error=self.Error
  if error!=BASS_OK: raise BassError(error)
 cpdef __GetConfig(BASS self,DWORD key):
  cdef bytes sret
  cdef DWORD iret
  cdef void *pret
  if key in __PtrConfigs:
   pret=BASS_GetConfigPtr(key)
   self.__Evaluate()
   sret=<bytes>pret
   return sret
  else:
   iret=BASS_GetConfig(key)
   self.__Evaluate()
   return <int>iret
 cpdef __SetConfig(BASS self,DWORD key,object value):
  cdef char *s
  if key in __PtrConfigs:
   value=value+"\0"
   s=value
   BASS_SetConfigPtr(key,<void*>s)
  else:
   BASS_SetConfig(key,<DWORD>value)
  self.__Evaluate()
 cpdef GetDevice(BASS self, int device):
  cdef int devicenumber=0
  cdef BASSDEVICE odevice
  if device>=0:
   odevice=BASSDEVICE(device)
   try:
    odevice.Status
   except BassError:
    return None
   return odevice
  elif device==-1:
   while True:
    odevice=BASSDEVICE(devicenumber)
    try:
     if odevice.Status&BASS_DEVICE_DEFAULT==BASS_DEVICE_DEFAULT: break
    except BassError:
     pass
    devicenumber=devicenumber+1
   if odevice.Status&BASS_DEVICE_DEFAULT!=BASS_DEVICE_DEFAULT: return None
   return odevice
  else:
   return None
 IF UNAME_SYSNAME=="Windows":
  cpdef GetDSoundObject(BASS self,int object):
   res=BASS_GetDSoundObject(object)
   self.__Evaluate()
   return <int>res
 cpdef PluginLoad(BASS self, char *filename, DWORD flags=0):
  cdef HPLUGIN plugin=BASS_PluginLoad(filename,flags)
  self.__Evaluate()
  return BASSPLUGIN(plugin)
 property CPU:
  def __get__(BASS self):
   return BASS_GetCPU()
 property Device:
  def __get__(BASS self):
   cdef DWORD device=BASS_GetDevice()
   self.__Evaluate()
   return BASSDEVICE(device)
 property Error:
  def __get__(BASS self):
   return BASS_ErrorGetCode()
 property Version:
  def __get__(BASS self):
   return BASSVERSION(BASS_GetVersion())
 property NetAgent:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_NET_AGENT)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_NET_AGENT,value)
 property NetProxy:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_NET_PROXY)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_NET_PROXY,value)
 property Algorithm3D:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_3DALGORITHM)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_3DALGORITHM,value)
 property Airplay:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_AIRPLAY)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_AIRPLAY,value)
 property AsyncBuffer:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_ASYNCFILE_BUFFER)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_ASYNCFILE_BUFFER,value)
 property Buffer:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_BUFFER)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_BUFFER,value)
 property CurveVolume:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_CURVE_VOL)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_CURVE_VOL,value)
 property CurvePan:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_CURVE_PAN)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_CURVE_PAN,value)
 property DeviceBuffer:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_DEV_BUFFER)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_DEV_BUFFER,value)
 property DefaultDevice:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_DEV_DEFAULT)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_DEV_DEFAULT,value)
 property FloatDsp:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_FLOATDSP)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_FLOATDSP,value)
 property MusicVolume:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_GVOL_MUSIC)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_GVOL_MUSIC,value)
 property SampleVolume:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_GVOL_SAMPLE)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_GVOL_SAMPLE,value)
 property StreamVolume:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_GVOL_STREAM)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_GVOL_STREAM,value)
 property Video:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_MF_VIDEO)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_MF_VIDEO,value)
 property VirtualChannels:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_MUSIC_VIRTUAL)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_MUSIC_VIRTUAL,value)
 property NetBuffer:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_NET_BUFFER)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_NET_BUFFER,value)
 property NetPassive:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_NET_PASSIVE)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_NET_PASSIVE,value)
 property NetPlaylist:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_NET_PLAYLIST)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_NET_PLAYLIST,value)
 property NetPrebuf:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_NET_PREBUF)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_NET_PREBUF,value)
 property NetTimeout:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_NET_TIMEOUT)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_NET_TIMEOUT,value)
 property NetReadTimeout:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_NET_READTIMEOUT)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_NET_READTIMEOUT,value)
 property OggPrescan:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_OGG_PRESCAN)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_OGG_PRESCAN,value)
 property PauseNoplay:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_PAUSE_NOPLAY)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_PAUSE_NOPLAY,value)
 property RecordBuffer:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_REC_BUFFER)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_REC_BUFFER,value)
 property SRC:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_SRC)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_SRC,value)
 property SRCSample:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_SRC_SAMPLE)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_SRC_SAMPLE,value)
 property Unicode:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_UNICODE)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_UNICODE,value)
 property UpdatePeriod:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_UPDATEPERIOD)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_UPDATEPERIOD,value)
 property UpdateThreads:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_UPDATETHREADS)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_UPDATETHREADS,value)
 property Verify:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_VERIFY)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_VERIFY,value)
 property NetVerify:
  def __get__(BASS self):
   return self.__GetConfig(BASS_CONFIG_VERIFY_NET)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_VERIFY_NET,value)
 property VistaSpeakers:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_VISTA_SPEAKERS)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_VISTA_SPEAKERS,value)
 property VistaTruepos:
  def __get__(BASS self):
   return <bint>self.__GetConfig(BASS_CONFIG_VISTA_TRUEPOS)
  def __set__(BASS self,object value):
   self.__SetConfig(BASS_CONFIG_VISTA_TRUEPOS,value)