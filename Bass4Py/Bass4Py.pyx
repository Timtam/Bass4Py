cimport bass
import basscallbacks
from bassdevice cimport BASSDEVICE
from bassexceptions import BassError,BassAPIError
from bassplugin cimport BASSPLUGIN
from bassstream cimport *
from bassversion cimport BASSVERSION
from types import FunctionType
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
 cpdef StreamCreate(BASS self,bass.DWORD freq,bass.DWORD chans,bass.DWORD flags,proc,object user):
  cdef int cbpos,iproc
  cdef bass.STREAMPROC *cproc
  cdef bass.HSTREAM stream
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
 cpdef StreamCreateFile(BASS self,bint mem,const char *file,bass.QWORD offset=0,bass.QWORD length=0,bass.DWORD flags=0):
  cdef bass.HSTREAM stream
  cdef void *ptr=<void*>file
  if mem and length==0: length=len(file)
  stream=bass.BASS_StreamCreateFile(mem,ptr,offset,length,flags)
  self.__Evaluate()
  return BASSSTREAM(stream)
 cpdef StreamCreateURL(BASS self,const char *url,bass.DWORD offset,bass.DWORD flags,proc=0,user=None):
  cdef bass.DOWNLOADPROC *cproc
  cdef int pos
  cdef void *ptr
  cdef bass.HSTREAM stream
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