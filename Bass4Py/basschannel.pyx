cimport bass
from bassplugin cimport BASSPLUGIN
from bassposition cimport BASSPOSITION
from basssample cimport BASSSAMPLE
cdef class BASSCHANNEL:
 def __cinit__(BASSCHANNEL self,bass.HCHANNEL channel):
  self.__channel=channel
 cdef bass.BASS_CHANNELINFO __getinfo(BASSCHANNEL self):
  cdef bass.BASS_CHANNELINFO info
  cdef bint res
  res=bass.BASS_ChannelGetInfo(self.__channel,&info)
  return info
 cpdef Play(BASSCHANNEL self,bint restart):
  cdef bint res=bass.BASS_ChannelPlay(self.__channel,restart)
  bass.__Evaluate()
  return res
 cpdef Pause(BASSCHANNEL self):
  cdef bint res=bass.BASS_ChannelPause(self.__channel)
  bass.__Evaluate()
  return res
 cpdef Stop(BASSCHANNEL self):
  cdef bint res=bass.BASS_ChannelStop(self.__channel)
  bass.__Evaluate()
  return res
 property Frequency:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.freq
 property Channels:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.chans
 property Flags:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.flags
 property Type:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.ctype
 property Resolution:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.origres
 property Plugin:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   if info.plugin:
    return BASSPLUGIN(info.plugin)
   else:
    return None
 property Name:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.filename
 property Sample:
  def __get__(BASSCHANNEL self):
   cdef bass.BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   if info.sample:
    return BASSSAMPLE(info.sample)
   else:
    return None
 property Position:
  def __get__(BASSCHANNEL self):
   cdef BASSPOSITION pos
   pos=BASSPOSITION()
   pos.Link(self)
   return pos