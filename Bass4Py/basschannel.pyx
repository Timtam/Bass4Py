cimport bass
from bassplugin cimport BASSPLUGIN
from bassposition cimport BASSPOSITION
from basssample cimport BASSSAMPLE
from bassexceptions import BassError,BassAPIError
cdef class BASSCHANNEL:
 def __cinit__(BASSCHANNEL self,bass.HCHANNEL channel):
  self.__channel=channel
 cdef bass.BASS_CHANNELINFO __getinfo(BASSCHANNEL self):
  cdef bass.BASS_CHANNELINFO info
  cdef bint res
  res=bass.BASS_ChannelGetInfo(self.__channel,&info)
  return info
 cpdef __getattribute(BASSCHANNEL self,bass.DWORD attrib):
  cdef float value
  cdef bint res
  res=bass.BASS_ChannelGetAttribute(self.__channel,attrib,&value)
  try:
   bass.__Evaluate()
  except BassError,e:
   if e.error==bass.BASS_ERROR_ILLTYPE: raise BassAPIError()
   raise e
  return value
 cpdef __setattribute(BASSCHANNEL self,bass.DWORD attrib,float value):
  cdef bint res
  res=bass.BASS_ChannelSetAttribute(self.__channel,attrib,value)
  try:
   bass.__Evaluate()
  except BassError,e:
   if e.error==bass.BASS_ERROR_ILLTYPE: raise BassAPIError()
   raise e
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
 property DefaultFrequency:
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
 IF UNAME_SYSNAME=="Windows":
  property EAXMix:
   def __get__(BASSCHANNEL self):
    return self.__getattribute(bass.BASS_ATTRIB_EAXMIX)
   def __set__(BASSCHANNEL self,float value):
    self.__setattribute(bass.BASS_ATTRIB_EAXMIX,value)
 property CPU:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_CPU)
 property Frequency:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_FREQ)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_FREQ,value)
 property Active:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_MUSIC_ACTIVE)
 property Amplify:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_MUSIC_AMPLIFY)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_MUSIC_AMPLIFY,value)
 property BPM:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_MUSIC_BPM)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_MUSIC_BPM,value)
 property PanSeparation:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_MUSIC_PANSEP)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_MUSIC_PANSEP,value)
 property Scaler:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_MUSIC_PSCALER)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_MUSIC_PSCALER,value)
 property Speed:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_MUSIC_SPEED)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_MUSIC_SPEED,value)
 property ChannelVolumes:
  def __get__(BASSCHANNEL self):
   cdef list volumes=[]
   cdef int channel=0
   cdef float res
   try:
    while True:
     res=self.__getattribute(bass.BASS_ATTRIB_MUSIC_VOL_CHAN+channel)
     volumes.append(res)
     channel+=1
   except BassAPIError,e:
    if len(volumes)==0: raise e
   return volumes
  def __set__(BASSCHANNEL self,list value):
   cdef list current=self.ChannelVolumes
   cdef int i
   if len(value)!=len(current): raise BassAPIError()
   for i in range(len(value)):
    self.__setattribute(bass.BASS_ATTRIB_MUSIC_VOL_CHAN+i,value[i])
 property GlobalVolume:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_MUSIC_VOL_GLOBAL)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_MUSIC_VOL_GLOBAL,value)
 property InstrumentVolumes:
  def __get__(BASSCHANNEL self):
   cdef list instruments=[]
   cdef int inst=0
   cdef float res
   try:
    while True:
     res=self.__getattribute(bass.BASS_ATTRIB_MUSIC_VOL_INST+inst)
     instruments.append(res)
     inst+=1
   except BassAPIError,e:
    if len(instruments)==0: raise e
   return instruments
  def __set__(BASSCHANNEL self,list value):
   cdef list current=self.InstrumentVolumes
   cdef int i=0
   if len(current)!=len(value): raise BassAPIError()
   for i in range(len(current)):
    self.__setattribute(bass.BASS_ATTRIB_MUSIC_VOL_INST+i,value[i])
 property NetResume:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_NET_RESUME)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_NET_RESUME,value)
 IF UNAME_SYSNAME!="Windows":
  property Buffering:
   def __get__(BASSCHANNEL self):
    cdef float res
    res=self.__getattribute(bass.BASS_ATTRIB_NOBUFFER)
    return True if res==0 else False
   def __set__(BASSCHANNEL self,bint value):
    self.__setattribute(bass.BASS_ATTRIB_NOBUFFER,1.0 if value==True else 0.0)
 property Pan:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_PAN)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_PAN,value)
 property SRC:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_SRC)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_SRC,value)
 property Volume:
  def __get__(BASSCHANNEL self):
   return self.__getattribute(bass.BASS_ATTRIB_VOL)
  def __set__(BASSCHANNEL self,float value):
   self.__setattribute(bass.BASS_ATTRIB_VOL,value)