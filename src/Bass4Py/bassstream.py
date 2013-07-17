from ctypes import *
from .exceptions import *
from basschannel import *
BOOL=c_long
DWORD=c_ulong
QWORD=c_longlong
class BASSSTREAM(object):
 def __init__(self, **kwargs):
  self.__bass = kwargs['bass']
  self._stream = kwargs['stream']
  self.__bass_streamfree=self.__bass._bass.BASS_StreamFree
  self.__bass_streamfree.restype=BOOL
  self.__bass_streamfree.argtypes=[DWORD]
  self.__bass_streamgetfileposition=self.__bass._bass.BASS_StreamGetFilePosition
  self.__bass_streamgetfileposition.restype=QWORD
  self.__bass_streamgetfileposition.argtypes=[DWORD,DWORD]
 def __del__(self):
  self.__bass_streamfree(self._stream)
 @property
 def Channel(self):
  return BASSCHANNEL(bass=self.__bass, stream=self._stream)
 def GetFilePosition(self,mode):
  result=self.__bass_streamgetfileposition(self._stream,mode)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def __repr__(self):
  return '<BASSSTREAM object at %s>'%(self._stream)