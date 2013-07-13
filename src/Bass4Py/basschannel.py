from ctypes import *
from .exceptions import *
from .constants import *
try:
 from ctypes.wintypes import *
except:
 BOOL=c_long
 DWORD=c_ulong
 HWND=c_void_p
 WINFUNCTYPE=CFUNCTYPE
from .bassposition import BASSPOSITION
QWORD=c_longlong
class BASSCHANNEL:
 def __init__(self, **kwargs):
  self.__bass = kwargs['bass']
  self._stream = kwargs['stream']
  self.__bass_channelplay=self.__bass._bass.BASS_ChannelPlay
  self.__bass_channelplay.restype=BOOL
  self.__bass_channelplay.argtypes=[DWORD, BOOL]
  self.__bass_channelpause=self.__bass._bass.BASS_ChannelPause
  self.__bass_channelpause.restype=BOOL
  self.__bass_channelpause.argtype=[DWORD]
  self.__bass_channelstop=self.__bass._bass.BASS_ChannelStop
  self.__bass_channelstop.restype=BOOL
  self.__bass_channelstop.argtypes=[DWORD]
  self.__bass_channelgetposition=self.__bass._bass.BASS_ChannelGetPosition
  self.__bass_channelgetposition.restype=QWORD
  self.__bass_channelgetposition.argtypes=[DWORD,DWORD]
  self.__bass_channelsetposition=self.__bass._bass.BASS_ChannelSetPosition
  self.__bass_channelsetposition.restype=BOOL
  self.__bass_channelsetposition.argtypes=[DWORD,QWORD,DWORD]
 def Play(self, restart=False):
  result=self.__bass_channelplay(self._stream, restart)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def Pause(self):
  result=self.__bass_channelpause(self._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def Stop(self):
  result=self.__bass_channelstop(self._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def __GetPosition(self):
  result=self.__bass_channelgetposition(self._stream,BASS_POS_BYTE)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return BASSPOSITION(bass=self.__bass,stream=self._stream,pos=result)
 def __SetPosition(self, positionobject):
  if positionobject._stream!=self._stream: raise BassMatchingError('This position object doesn\'t match this channel object.')
  result=self.__bass_channelsetposition(self._stream,positionobject._pos_bytes,BASS_POS_BYTE)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
 Position=property(__GetPosition,__SetPosition)