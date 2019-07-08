from .exceptions import BassError,BassAPIError

from libc.stdlib cimport malloc, free

cdef class BASSCHANNELATTRIBUTE:
  def __cinit__(BASSCHANNELATTRIBUTE self, HCHANNEL channel, DWORD attribute, bint readonly = False):
    self.__channel = channel
    self.__attrib = attribute
    self.__readonly = readonly

  cpdef Get(BASSCHANNELATTRIBUTE self):
    cdef float value
    cdef bint res

    if self.__attrib == bass._BASS_ATTRIB_MUSIC_VOL_CHAN or \
       self.__attrib == bass._BASS_ATTRIB_MUSIC_VOL_INST:
      return self.__getmusicvolchan()
    elif self.__attrib == bass._BASS_ATTRIB_BUFFER:
      return self.__getbuffer()
    elif self.__attrib == bass._BASS_ATTRIB_NORAMP:
      return self.__getramping()
    elif self.__attrib == bass._BASS_ATTRIB_SCANINFO:
      return self.__getscaninfo()

    res = bass.BASS_ChannelGetAttribute(self.__channel, self.__attrib, &value)
    try:
      bass.__Evaluate()
    except BassError, e:
      if e.error == bass._BASS_ERROR_ILLTYPE:
        raise BassAPIError()
      raise e
    return value

  cpdef Set(BASSCHANNELATTRIBUTE self, object value):
    cdef bint res

    if self.__readonly:
      raise BassError("attribute is readonly and thus cannot be set")

    if self.__attrib == bass._BASS_ATTRIB_MUSIC_VOL_CHAN or \
       self.__attrib==bass._BASS_ATTRIB_MUSIC_VOL_INST:
      return self.__setmusicvolchan(<list>value)
    elif self.__attrib == bass._BASS_ATTRIB_BUFFER:
      return self.__setbuffer(<float>value)
    elif self.__attrib == bass._BASS_ATTRIB_NORAMP:
      return self.__setramping(<bint>value)

    res = bass.BASS_ChannelSetAttribute(self.__channel, self.__attrib, <float>value)
    try:
      bass.__Evaluate()
    except BassError, e:
      if e.error == bass._BASS_ERROR_ILLTYPE:
        raise BassAPIError()
      raise e
    return res

  cpdef Slide(BASSCHANNELATTRIBUTE self, object value, DWORD time):
    cdef bint res

    if self.__readonly:
      raise BassError("attribute is readonly and thus cannot be set")

    if self.__attrib == bass._BASS_ATTRIB_MUSIC_VOL_CHAN or \
       self.__attrib == bass._BASS_ATTRIB_MUSIC_VOL_INST:
      return self.__slidemusicvolchan(<list>value, time)
    elif self.__attrib == bass._BASS_ATTRIB_BUFFER:
      return self.__slidebuffer(<float>value, time)
    res = bass.BASS_ChannelSlideAttribute(self.__channel, self.__attrib, <float>value, time)
    bass.__Evaluate()
    return res

  cpdef __getmusicvolchan(BASSCHANNELATTRIBUTE self):
    cdef list volumes=[]
    cdef int channel=0
    cdef float res
    try:
      while True:
        bass.BASS_ChannelGetAttribute(self.__channel, self.__attrib+channel, &res)
        bass.__Evaluate()
        volumes.append(res)
        channel+=1
    except BassError, e:
      if e.error != bass._BASS_ERROR_ILLTYPE:
        raise e
      if len(volumes) == 0:
        raise e
    return volumes

  cpdef __setmusicvolchan(BASSCHANNELATTRIBUTE self, list value):
    cdef list current = self.__getmusicvolchan()
    cdef int i
    if len(value) != len(current):
      raise BassAPIError()
    for i in range(len(value)):
      bass.BASS_ChannelSetAttribute(self.__channel, self.__attrib+i, value[i])
    return True

  cpdef __getbuffer(BASSCHANNELATTRIBUTE self):
    cdef float res
    bass.BASS_ChannelGetAttribute(self.__channel, self.__attrib, &res)
    bass.__Evaluate()
    return res

  cpdef __setbuffer(BASSCHANNELATTRIBUTE self, float value):
    bass.BASS_ChannelSetAttribute(self.__channel, self.__attrib, value)
    bass.__Evaluate()
    if value == 0:
      bass.BASS_ChannelSetAttribute(self.__channel, bass._BASS_ATTRIB_NOBUFFER, 1.0)
    else:
      bass.BASS_ChannelSetAttribute(self.__channel, bass._BASS_ATTRIB_NOBUFFER, 0.0)
    bass.__Evaluate()
    return True

  cpdef __slidemusicvolchan(BASSCHANNELATTRIBUTE self, list value, DWORD time):
    cdef list current = self.__getmusicvolchan()
    cdef int i
    if len(value) != len(current):
      raise BassAPIError()
    for i in range(len(value)):
      bass.BASS_ChannelSlideAttribute(self.__channel, self.__attrib+i, value[i], time)
    return True

  cpdef __slidebuffer(BASSCHANNELATTRIBUTE self, float value, DWORD time):
    bass.BASS_ChannelSlideAttribute(self.__channel, self.__attrib, value, time)
    bass.__Evaluate()
    return True

  property Sliding:
    def __get__(BASSCHANNELATTRIBUTE self):
      return bass.BASS_ChannelIsSliding(self.__channel, self.__attrib)
      
  cpdef __getramping(BASSCHANNELATTRIBUTE self):
    cdef float res
    bass.BASS_ChannelGetAttribute(self.__channel, bass._BASS_ATTRIB_NORAMP, &res)
    bass.__Evaluate()
    return False if res == 1 else True

  cpdef __setramping(BASSCHANNELATTRIBUTE self, bint value):
    bass.BASS_ChannelSetAttribute(self.__channel, bass._BASS_ATTRIB_NORAMP, 0.0 if value == True else 1.0)
    bass.__Evaluate()
    return True

  cpdef __getscaninfo(BASSCHANNELATTRIBUTE self):
    cdef bytes res
    cdef DWORD size
    cdef void * info

    size = bass.BASS_ChannelGetAttributeEx(self.__channel, self.__attrib, NULL, 0)
    bass.__Evaluate()

    info = malloc(size)

    if info == NULL:
      raise MemoryError()

    bass.BASS_ChannelGetAttributeEx(self.__channel, self.__attrib, info, size)

    try:
      bass.__Evaluate()
    except Exception, e:
      free(info)
      raise e
    
    res = (<char*>info)[:size]
    free(info)
    return res

  cpdef __setscaninfo(BASSCHANNELATTRIBUTE self, bytes info):
    cdef DWORD size = len(info)
    cdef DWORD res = bass.BASS_ChannelSetAttributeEx(self.__channel, self.__attrib, <void*>info, size)
    bass.__Evaluate()
    return res
