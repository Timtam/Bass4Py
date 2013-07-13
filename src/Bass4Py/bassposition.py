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
class BASSPOSITION:
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
 def __GetPosAsBytes(self):
  return self._pos_bytes
 def __SetPosAsBytes(self, bytes):
  self._pos_bytes=bytes
 def __GetPosAsSeconds(self):
  result=self.__bass_channelbytes2seconds(self._stream,self._pos_bytes)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def __SetPosAsSeconds(self, seconds):
  result=self.__bass_channelseconds2bytes(self._stream,seconds)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  self._pos_bytes=result
 Bytes=property(__GetPosAsBytes,__SetPosAsBytes)
 Seconds=property(__GetPosAsSeconds,__SetPosAsSeconds)