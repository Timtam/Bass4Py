cimport bass
from bassdevice cimport BASSDEVICE
from bassexceptions import BassError,BassAPIError
from bassplugin cimport BASSPLUGIN
from bassversion cimport BASSVERSION
cdef extern from "Python.h":
 void PyEval_InitThreads()
cdef class BASS:
 def __cinit__(BASS self):
  PyEval_InitThreads()
 cpdef __Evaluate(BASS self):
  cdef bass.DWORD error=self.Error
  if error!=bass.BASS_OK: raise BassError(error)
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
     if odevice.Status&bass.BASS_DEVICE_DEFAULT==bass.BASS_DEVICE_DEFAULT: break
    except BassError:
     pass
    devicenumber=devicenumber+1
   if odevice.Status&bass.BASS_DEVICE_DEFAULT!=bass.BASS_DEVICE_DEFAULT: return None
   return odevice
  else:
   return None
 IF UNAME_SYSNAME=="Windows":
  cpdef GetDSoundObject(BASS self,int object):
   res=bass.BASS_GetDSoundObject(object)
   self.__Evaluate()
   return <int>res
 cpdef PluginLoad(BASS self, char *filename, bass.DWORD flags=0):
  cdef bass.HPLUGIN plugin=bass.BASS_PluginLoad(filename,flags)
  self.__Evaluate()
  return BASSPLUGIN(plugin)
 property CPU:
  def __get__(BASS self):
   return bass.BASS_GetCPU()
 property Device:
  def __get__(BASS self):
   cdef bass.DWORD device=bass.BASS_GetDevice()
   self.__Evaluate()
   return BASSDEVICE(device)
 property Error:
  def __get__(BASS self):
   return bass.BASS_ErrorGetCode()
 property Version:
  def __get__(BASS self):
   return BASSVERSION(bass.BASS_GetVersion())