from bassexceptions import BassError,BassAPIError
cdef class BASSCHANNELATTRIBUTE:
 def __cinit__(BASSCHANNELATTRIBUTE self,HCHANNEL channel,DWORD attribute):
  self.__channel=channel
  self.__attribute=attribute
 cpdef Get(BASSCHANNELATTRIBUTE self):
  cdef float value
  cdef bint res
  if self.__attribute==bass.BASS_ATTRIB_MUSIC_VOL_CHAN or self.__attribute==bass.BASS_ATTRIB_MUSIC_VOL_INST: return self.__getmusicvolchan()
  elif self.__attribute==bass.BASS_ATTRIB_NOBUFFER: return self.__getnobuffer()
  res=bass.BASS_ChannelGetAttribute(self.__channel,self.__attribute,&value)
  try:
   bass.__Evaluate()
  except BassError,e:
   if e.error==bass.BASS_ERROR_ILLTYPE: raise BassAPIError()
   raise e
  return value
 cpdef Set(BASSCHANNELATTRIBUTE self,object value):
  cdef bint res
  if self.__attribute==bass.BASS_ATTRIB_MUSIC_VOL_CHAN or self.__attribute==bass.BASS_ATTRIB_MUSIC_VOL_INST: return self.__setmusicvolchan(<list>value)
  elif self.__attribute==bass.BASS_ATTRIB_NOBUFFER: return self.__setnobuffer(<bint>value)
  res=bass.BASS_ChannelSetAttribute(self.__channel,self.__attribute,<float>value)
  try:
   bass.__Evaluate()
  except BassError,e:
   if e.error==bass.BASS_ERROR_ILLTYPE: raise BassAPIError()
   raise e
  return res
 cpdef Slide(BASSCHANNELATTRIBUTE self,object value,DWORD time):
  cdef bint res
  if self.__attribute==bass.BASS_ATTRIB_MUSIC_VOL_CHAN or self.__attribute==bass.BASS_ATTRIB_MUSIC_VOL_INST: return self.__slidemusicvolchan(<list>value,time)
  res=bass.BASS_ChannelSlideAttribute(self.__channel,self.__attribute,<float>value,time)
  bass.__Evaluate()
  return res
 cpdef __getmusicvolchan(BASSCHANNELATTRIBUTE self):
  cdef list volumes=[]
  cdef int channel=0
  cdef float res
  try:
   while True:
    bass.BASS_ChannelGetAttribute(self.__channel,self.__attribute+channel,&res)
    bass.__Evaluate()
    volumes.append(res)
    channel+=1
  except BassError,e:
   if e.error!=bass.BASS_ERROR_ILLTYPE: raise e
   if len(volumes)==0: raise e
  return volumes
 cpdef __setmusicvolchan(BASSCHANNELATTRIBUTE self,list value):
  cdef list current=self.__getmusicvolchan()
  cdef int i
  if len(value)!=len(current): raise BassAPIError()
  for i in range(len(value)):
   bass.BASS_ChannelSetAttribute(self.__channel,self.__attribute+i,value[i])
  return True
 cpdef __getnobuffer(BASSCHANNELATTRIBUTE self):
  cdef float res
  bass.BASS_ChannelGetAttribute(self.__channel,self.__attribute,&res)
  bass.__Evaluate()
  return True if res==0 else False
 cpdef __setnobuffer(BASSCHANNELATTRIBUTE self,bint value):
  bass.BASS_ChannelSetAttribute(self.__channel,self.__attribute,0.0 if value==True else 1.0)
  bass.__Evaluate()
  return True
 cpdef __slidemusicvolchan(BASSCHANNELATTRIBUTE self,list value,DWORD time):
  cdef list current=self.__getmusicvolchan()
  cdef int i
  if len(value)!=len(current): raise BassAPIError()
  for i in range(len(value)):
   bass.BASS_ChannelSlideAttribute(self.__channel,self.__attribute+i,value[i],time)
  return True
 property Sliding:
  def __get__(BASSCHANNELATTRIBUTE self):
   return bass.BASS_ChannelIsSliding(self.__channel,self.__attribute)