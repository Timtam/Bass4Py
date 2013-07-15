from ctypes import *
from .exceptions import *
from basschannel import *
BOOL=c_long
DWORD=c_ulong
class BASSSTREAM(object):
 def __init__(self, **kwargs):
  self.__bass = kwargs['bass']
  self._stream = kwargs['stream']
  self.__bass_streamfree=self.__bass._bass.BASS_StreamFree
  self.__bass_streamfree.restype=BOOL
  self.__bass_streamfree.argtypes=[DWORD]
 def __del__(self):
  result=self.__bass_streamfree(self._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
 @property
 def Channel(self):
  return BASSCHANNEL(bass=self.__bass, stream=self._stream)