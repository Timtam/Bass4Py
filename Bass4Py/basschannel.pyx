cimport bass
from bassexceptions import BassError
from bassplugin cimport BASSPLUGIN
from basssample cimport BASSSAMPLE
cdef class BASSCHANNEL:
 def __cinit__(BASSCHANNEL self,bass.HCHANNEL channel):
  self.__channel=channel
 cpdef __Evaluate(BASSCHANNEL self):
  cdef bass.DWORD error=bass.BASS_ErrorGetCode()
  if error!=bass.BASS_OK: raise BassError(error)
 cdef bass.BASS_CHANNELINFO __getinfo(BASSCHANNEL self):
  cdef bass.BASS_CHANNELINFO info
  cdef bint res
  res=bass.BASS_ChannelGetInfo(self.__channel,&info)
  return info
 cpdef Play(BASSCHANNEL self,bint restart):
  cdef bint res=bass.BASS_ChannelPlay(self.__channel,restart)
  self.__Evaluate()
  return res
 cpdef Pause(BASSCHANNEL self):
  cdef bint res=bass.BASS_ChannelPause(self.__channel)
  self.__Evaluate()
  return res
 cpdef Stop(BASSCHANNEL self):
  cdef bint res=bass.BASS_ChannelStop(self.__channel)
  self.__Evaluate()
  return res
 property Frequency:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   self.__Evaluate()
   return info.freq
 property Channels:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   self.__Evaluate()
   return info.chans
 property Flags:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   self.__Evaluate()
   return info.flags
 property Type:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   self.__Evaluate()
   return info.ctype
 property Resolution:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   self.__Evaluate()
   return info.origres
 property Plugin:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   self.__Evaluate()
   if info.plugin:
    return BASSPLUGIN(info.plugin)
   else:
    return None
 property Name:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   self.__Evaluate()
   return info.filename
 property Sample:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   self.__Evaluate()
   if info.sample:
    return BASSSAMPLE(info.sample)
   else:
    return None