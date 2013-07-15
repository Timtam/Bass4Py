from ctypes import *
from .exceptions import *
try:
 from ctypes.wintypes import *
except:
 BOOL=c_long
 DWORD=c_ulong
 HWND=c_void_p
 WINFUNCTYPE=CFUNCTYPE
QWORD=c_longlong
class BASSPOSITION(object):
 def __init__(self, **kwargs):
  self.__bass=kwargs['bass']
  self._stream=kwargs['stream']
  self._pos_bytes=kwargs['pos']
  self.__bass_channelbytes2seconds=self.__bass._bass.BASS_ChannelBytes2Seconds
  self.__bass_channelbytes2seconds.restype=c_double
  self.__bass_channelbytes2seconds.argtypes=[DWORD,QWORD]
  self.__bass_channelseconds2bytes=self.__bass._bass.BASS_ChannelSeconds2Bytes
  self.__bass_channelseconds2bytes.restype=QWORD
  self.__bass_channelseconds2bytes.argtypes=[DWORD,c_double]
 @property
 def Bytes(self):
  return self._pos_bytes
 @Bytes.setter
 def Bytes(self, value):
  self._pos_bytes=value
 @property
 def Seconds(self):
  result=self.__bass_channelbytes2seconds(self._stream,self._pos_bytes)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 @Seconds.setter
 def Seconds(self, value):
  result=self.__bass_channelseconds2bytes(self._stream,value)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  self._pos_bytes=result