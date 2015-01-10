cimport bass
from bassdevice cimport BASSDEVICE
from bassexceptions import BassError,BassAPIError
from bassversion cimport BASSVERSION

cdef class BASS:
 cpdef __Evaluate(self):
  cdef bass.DWORD error=self.Error
  if error: raise BassError(error)
 cpdef GetDevice(self, int device):
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
     if odevice.Status&bass.BASS_DEVICE_DEFAULT==bass.BASS_DEVICE_DEFAULT: break
    except BassError:
     pass
    devicenumber=devicenumber+1
   return odevice
  else:
   raise BassAPIError()
 IF UNAME_SYSNAME=='Windows':
  cpdef GetDSoundObject(self,int object):
   res=bass.BASS_GetDSoundObject(object)
   self.__Evaluate()
   return <int>res
 property CPU:
  def __get__(self):
   return bass.BASS_GetCPU()
 property Device:
  def __get__(self):
   cdef bass.DWORD device=bass.BASS_GetDevice()
   self.__Evaluate()
   return BASSDEVICE(device)
 property Error:
  def __get__(self):
   return bass.BASS_ErrorGetCode()
 property Version:
  def __get__(self):
   return BASSVERSION(bass.BASS_GetVersion())
