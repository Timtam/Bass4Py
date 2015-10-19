from libc.stdlib cimport malloc,free
cimport bass
from basschannelattribute cimport BASSCHANNELATTRIBUTE
from bassdevice cimport BASSDEVICE
from bassplugin cimport BASSPLUGIN
from bassposition cimport BASSPOSITION
from basssample cimport BASSSAMPLE
from bassexceptions import BassError,BassAPIError
cdef class BASSCHANNEL:
 def __cinit__(BASSCHANNEL self,HCHANNEL channel):
  self.__channel=channel
 cdef BASS_CHANNELINFO __getinfo(BASSCHANNEL self):
  cdef BASS_CHANNELINFO info
  cdef bint res
  res=bass.BASS_ChannelGetInfo(self.__channel,&info)
  return info
 cdef DWORD __getflags(BASSCHANNEL self):
  return bass.BASS_ChannelFlags(self.__channel,0,0)
 cpdef __setflags(BASSCHANNEL self,DWORD flag,bint switch):
  if switch:
   bass.BASS_ChannelFlags(self.__channel,flag,flag)
  else:
   bass.BASS_ChannelFlags(self.__channel,0,flag)
  bass.__Evaluate()
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
 cpdef GetLevels(BASSCHANNEL self,float length,DWORD flags):
  cdef int chans=self.Channels
  cdef int i=0
  cdef float *levels
  cdef list plevels=[]
  levels=<float*>malloc(chans*sizeof(float))
  if levels==NULL: return plevels
  bass.BASS_ChannelGetLevelEx(self.__channel,levels,length,flags)
  bass.__Evaluate()
  for i in range(chans):
   plevels.append(levels[i])
  free(<void*>levels)
  return tuple(plevels)
 cpdef Lock(BASSCHANNEL self):
  return bass.BASS_ChannelLock(self.__channel,True)
 cpdef Unlock(BASSCHANNEL self):
  return bass.BASS_ChannelLock(self.__channel,False)
 property DefaultFrequency:
  def __get__(BASSCHANNEL self):
   cdef BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.freq
 property Channels:
  def __get__(BASSCHANNEL self):
   cdef BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.chans
 property Flags:
  def __get__(BASSCHANNEL self):
   cdef BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.flags
 property Type:
  def __get__(BASSCHANNEL self):
   cdef BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.ctype
 property Resolution:
  def __get__(BASSCHANNEL self):
   cdef BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.origres
 property Plugin:
  def __get__(BASSCHANNEL self):
   cdef BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   if info.plugin:
    return BASSPLUGIN(info.plugin)
   else:
    return None
 property Name:
  def __get__(BASSCHANNEL self):
   cdef BASS_CHANNELINFO info=self.__getinfo()
   bass.__Evaluate()
   return info.filename
 property Sample:
  def __get__(BASSCHANNEL self):
   cdef BASS_CHANNELINFO info=self.__getinfo()
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
 IF UNAME_SYSNAME=="Windows":
  property EAXMix:
   def __get__(BASSCHANNEL self):
    return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_EAXMIX)
 property CPU:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_CPU)
 property Frequency:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_FREQ)
 property Active:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_MUSIC_ACTIVE)
 property Amplify:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_MUSIC_AMPLIFY)
 property BPM:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_MUSIC_BPM)
 property PanSeparation:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_MUSIC_PANSEP)
 property Scaler:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_MUSIC_PSCALER)
 property Speed:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_MUSIC_SPEED)
 property ChannelVolumes:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_MUSIC_VOL_CHAN)
 property GlobalVolume:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_MUSIC_VOL_GLOBAL)
 property InstrumentVolumes:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_MUSIC_VOL_INST)
 property NetResume:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_NET_RESUME)
 IF UNAME_SYSNAME!="Windows":
  property Buffering:
   def __get__(BASSCHANNEL self):
    return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_NOBUFFER)
 property Pan:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_PAN)
 property SRC:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_SRC)
 property Volume:
  def __get__(BASSCHANNEL self):
   return BASSCHANNELATTRIBUTE(self.__channel,bass.BASS_ATTRIB_VOL)
 property Loop:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_SAMPLE_LOOP==bass.BASS_SAMPLE_LOOP
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_SAMPLE_LOOP,switch)
 property AutoFree:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_STREAM_AUTOFREE==bass.BASS_STREAM_AUTOFREE
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_STREAM_AUTOFREE,switch)
 property RestrictDownload:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_STREAM_RESTRATE==bass.BASS_STREAM_RESTRATE
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_STREAM_RESTRATE,switch)
 property InterpolationNone:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_NONINTER==bass.BASS_MUSIC_NONINTER
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_NONINTER,switch)
 property InterpolationSinc:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_SINCINTER==bass.BASS_MUSIC_SINCINTER
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_SINCINTER,switch)
 property RampNormal:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_RAMP==bass.BASS_MUSIC_RAMP
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_RAMP,switch)
 property RampSensitive:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_RAMPS==bass.BASS_MUSIC_RAMPS
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_RAMPS,switch)
 property Surround:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_SURROUND==bass.BASS_MUSIC_SURROUND
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_SURROUND,switch)
 property Surround2:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_SURROUND2==bass.BASS_MUSIC_SURROUND2
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_SURROUND2,switch)
 property ModFT2:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_FT2MOD==bass.BASS_MUSIC_FT2MOD
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_FT2MOD,switch)
 property ModPT1:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_PT1MOD==bass.BASS_MUSIC_PT1MOD
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_PT1MOD,switch)
 property StopSeeking:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_POSRESET==bass.BASS_MUSIC_POSRESET
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_POSRESET,switch)
 property StopAllSeeking:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_POSRESETEX==bass.BASS_MUSIC_POSRESETEX
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_POSRESETEX,switch)
 property StopBackward:
  def __get__(BASSCHANNEL self):
   return self.__getflags()&bass.BASS_MUSIC_STOPBACK==bass.BASS_MUSIC_STOPBACK
  def __set__(BASSCHANNEL self,bint switch):
   self.__setflags(bass.BASS_MUSIC_STOPBACK,switch)
 property Device:
  def __get__(BASSCHANNEL self):
   return BASSDEVICE(bass.BASS_ChannelGetDevice(self.__channel))
 property Level:
  def __get__(BASSCHANNEL self):
   cdef WORD left,right
   cdef DWORD level=bass.BASS_ChannelGetLevel(self.__channel)
   bass.__Evaluate()
   left=LOWORD(level)
   right=HIWORD(level)
   return (left,right,)
 property Status:
  def __get__(BASSCHANNEL self):
   return bass.BASS_ChannelIsActive(self.__channel)
