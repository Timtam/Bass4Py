from ctypes import *
try:
 from ctypes.wintypes import *
except:
 BOOL=c_long
 DWORD=c_ulong
 WINFUNCTYPE=CFUNCTYPE
from basschannel import *
from .exceptions import *
HMUSIC=DWORD
class BASSMUSIC:
 def __init__(self, **kwargs):
  self.__bass = kwargs['bass']
  self._music = kwargs['music']
  self.__bass_musicfree = self.__bass._bass.BASS_MusicFree
  self.__bass_musicfree.restype=BOOL
  self.__bass_musicfree.argtypes=[HMUSIC]
 def __del__(self):
  self.__bass_musicfree(self._music)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
 def __GetChannelObject(self):
  return BASSCHANNEL(bass=self.__bass, stream=self._music)
 Channel = property(__GetChannelObject)