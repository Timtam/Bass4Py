cimport bass
from bassexceptions import *
cdef class BASSPOSITION:
 def __cinit__(BASSPOSITION self):
  self.Inexact=False
  self.Scan=False
 cdef DWORD __applyflags(BASSPOSITION self,DWORD *flags):
  if self.Inexact:
   flags[0]=flags[0]&bass.BASS_POS_INEXACT
   self.Inexact=False
  if self.Scan:
   flags[0]=flags[0]&bass.BASS_POS_SCAN
   self.Scan=False
 cdef DWORD __gethandle(BASSPOSITION self):
  if type(self.__handle) is BASSCHANNEL:
   return self.__handle.__channel
  elif type(self.__handle) is BASSMUSIC:
   return self.__handle.__music
  elif type(self.__handle) is BASSSAMPLE:
   return self.__handle.__sample
  elif type(self.__handle) is BASSSTREAM:
   return self.__handle.__stream
 cpdef Link(BASSPOSITION self,Handles handle):
  if self.__handle==None:
   self.__handle=handle
  else:
   raise BassLinkError("link already established")
 cpdef GetOrder(BASSPOSITION self):
  cdef QWORD pos
  if self.__handle==None: raise BassLinkError("no link established yet")
  pos=bass.BASS_ChannelGetPosition(self.__gethandle(),bass.BASS_POS_MUSIC_ORDER)
  try:
   bass.__Evaluate()
  except BassError,e:
   if e.error==bass.BASS_ERROR_ILLTYPE: raise BassAPIError()
   raise e
  return (<int>bass.LOWORD(pos),<int>(bass.HIWORD(pos)/self.__handle.Scaler.Get()),)
 cpdef SetOrder(BASSPOSITION self,tuple order):
  cdef DWORD pos,flags=bass.BASS_POS_MUSIC_ORDER
  if len(order)!=2: raise BassAPIError()
  if self.__handle==None: raise BassLinkError("no link established yet")
  pos=bass.MAKELONG(<bass.WORD>(order[0]),<bass.WORD>((order[1])*self.__handle.Scaler.Get()))
  self.__applyflags(&flags)
  bass.BASS_ChannelSetPosition(self.__gethandle(),<bass.QWORD>pos,flags)
  try:
   bass.__Evaluate()
  except BassError,e:
   if e.error==bass.BASS_ERROR_ILLTYPE: raise BassAPIError()
   raise e
 cpdef Reset(BASSPOSITION self,bint resetex=False):
  cdef DWORD flags
  cdef QWORD pos
  if self.__handle==None: raise BassAPIError()
  flags=bass.BASS_MUSIC_POSRESETEX if resetex else bass.BASS_MUSIC_POSRESET
  pos=self.Bytes
  bass.BASS_ChannelSetPosition(self.__gethandle(),pos,flags)
  try:
   bass.__Evaluate()
  except BassError,e:
   if e.error==bass.BASS_ERROR_ILLTYPE: raise BassAPIError()
   raise e
 property Bytes:
  def __get__(BASSPOSITION self):
   cdef QWORD pos
   if self.__handle==None: raise BassLinkError("no link established yet")
   pos=bass.BASS_ChannelGetPosition(self.__gethandle(),bass.BASS_POS_BYTE)
   bass.__Evaluate()
   return pos
  def __set__(BASSPOSITION self,QWORD value):
   cdef DWORD flags=bass.BASS_POS_BYTE
   if self.__handle==None: raise BassLinkError("no link established yet")
   self.__applyflags(&flags)
   bass.BASS_ChannelSetPosition(self.__gethandle(),value,flags)
   bass.__Evaluate()
 property Seconds:
  def __get__(BASSPOSITION self):
   cdef double secs
   if self.__handle==None: raise BassLinkError("no link established yet")
   secs=bass.BASS_ChannelBytes2Seconds(self.__gethandle(),self.Bytes)
   bass.__Evaluate()
   return secs
  def __set__(BASSPOSITION self,double value):
   cdef QWORD bvalue
   if self.__handle==None: raise BassLinkError("no link established yet")
   bvalue=bass.BASS_ChannelSeconds2Bytes(self.__gethandle(),value)
   bass.__Evaluate()
   self.Bytes=bvalue
 property Decode:
  def __get__(BASSPOSITION self):
   cdef QWORD res
   if self.__handle==None: raise BassLinkError("no link established yet")
   res=bass.BASS_ChannelGetPosition(self.__gethandle(),bass.BASS_POS_DECODE)
   bass.__Evaluate()
   return res
  def __set__(BASSPOSITION self,QWORD value):
   cdef DWORD flags=bass.BASS_POS_DECODETO&bass.BASS_POS_BYTE
   if self.__handle==None: raise BassAPIError()
   self.__applyflags(&flags)
   bass.BASS_ChannelSetPosition(self.__gethandle(),value,flags)
   bass.__Evaluate()
 property Ogg:
  def __get__(BASSPOSITION self):
   raise BassAPIError()
  def __set__(BASSPOSITION self,QWORD value):
   cdef DWORD flags=bass.BASS_POS_OGG
   if self.__handle==None: raise BassLinkError("no link established yet")
   self.__applyflags(&flags)
   bass.BASS_ChannelSetPosition(self.__gethandle(),value,flags)
   bass.__Evaluate()
