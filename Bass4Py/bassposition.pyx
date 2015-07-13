cimport bass
from bassexceptions import BassLinkError
cdef class BASSPOSITION:
 cdef DWORD __gethandle(BASSPOSITION self):
  if type(self._handle) is BASSCHANNEL:
   return self._handle.__channel
  elif type(self._handle) is BASSMUSIC:
   return self._handle.__music
  elif type(self._handle) is BASSSAMPLE:
   return self._handle.__sample
  elif type(self._handle) is BASSSTREAM:
   return self._handle.__stream
 cpdef Link(BASSPOSITION self,Handles handle):
  if self._handle==None:
   self._handle=handle
  else:
   raise BassLinkError("link already established")
 property Bytes:
  def __get__(BASSPOSITION self):
   cdef bass.QWORD pos
   if self._handle==None: raise BassLinkError("no link established yet")
   pos=bass.BASS_ChannelGetPosition(self.__gethandle(),bass.BASS_POS_BYTE)
   bass.__Evaluate()
   return pos
  def __set__(BASSPOSITION self,bass.QWORD value):
   if self._handle==None: raise BassLinkError("no link established yet")
   bass.BASS_ChannelSetPosition(self.__gethandle(),bass.BASS_POS_BYTE,value)
   bass.__Evaluate()
 property Seconds:
  def __get__(BASSPOSITION self):
   cdef double secs
   if self._handle==None: raise BassLinkError("no link established yet")
   secs=bass.BASS_ChannelBytes2Seconds(self.__gethandle(),self.Bytes)
   bass.__Evaluate()
   return secs
  def __set__(BASSPOSITION self,double value):
   cdef bass.QWORD bvalue
   if self._handle==None: raise BassLinkError("no link established yet")
   bvalue=bass.BASS_ChannelSeconds2Bytes(self.__gethandle(),value)
   bass.__Evaluate()
   self.Bytes=bvalue