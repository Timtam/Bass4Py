from ctypes import *
try:
 from ctypes.wintypes import *
except:
 BOOL=c_long
 DWORD=c_ulong
 WINFUNCTYPE=CFUNCTYPE
from basschannel import *
HMUSIC=DWORD
class BASSMUSIC:
 def __init__(self, bass, music):
  self.__bass = bass
  self.__music = music
  self.__bass_musicfree = self.__bass.BASS_MusicFree
  self.__bass_musicfree.restype=BOOL
  self.__bass_musicload.argtypes=[HMUSIC]
 def Free(self):
  return self.__bass_musicfree(self.__music)
 def __GetChannelObject(self):
  return BASSCHANNEL(self.__bass, self.__music)
 Channel = property(__GetChannelObject)