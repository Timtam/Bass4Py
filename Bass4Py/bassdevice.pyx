cimport bass
from bassexceptions import BassError, BassAPIError

cdef class BASSDEVICE:
 def __cinit__(BASSDEVICE self,int device):
  self.__device=device
 def __richcmp__(BASSDEVICE self,other,int op):
  if op==2:
   return (type(self)==type(other)) and (self.__device==other.__device)
 cpdef __Evaluate(BASSDEVICE self):
  cdef bass.DWORD error=bass.BASS_ErrorGetCode()
  if error: raise BassError(error)
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