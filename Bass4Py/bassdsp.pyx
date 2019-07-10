from libc.string cimport memmove

from .bass cimport (
                    __Evaluate,
                    BASS_ChannelSetDSP,
                    BASS_ChannelRemoveDSP,
                    DSPPROC
                   )

from .basschannel cimport BASSCHANNEL
from .exceptions import BassAPIError

cdef void CDSPPROC(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil:
  cdef BASSDSP odsp = <BASSDSP?>user
  cdef bytes result
  cdef char *cbuffer

  cbuffer=<char *>buffer
  result = odsp.__func(odsp, <bytes>cbuffer[:length])

  if (<DWORD>len(result)) > length:
    result = result[:length]
  memmove(buffer, (<const void *>result), length)

cdef void __stdcall CDSPPROC_STD(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil:
  CDSPPROC(dsp, channel, buffer, length, user)

cdef class BASSDSP:
  cpdef Remove(BASSDSP self):
    cdef bint res=BASS_ChannelRemoveDSP(self.Channel.__channel, self.__dsp)
    __Evaluate()
    return res

  cpdef Set(BASSDSP self, BASSCHANNEL chan):
    cdef HDSP dsp
    cdef DSPPROC *cproc
    
    if self.__dsp:
      raise BassAPIError()

    IF UNAME_SYSNAME == "Windows":
      cproc = <DSPPROC*>CDSPPROC_STD
    ELSE:
      cproc = <DSPPROC*>CDSPPROC

    dsp = BASS_ChannelSetDSP(chan.__channel, cproc, <void*>self, self.__priority)
    
    __Evaluate()
    
    self.__dsp = dsp
    self.Channel = chan

  property Priority:
    def __get__(BASSDSP self):
      return self.__priority
    
    def __set__(BASSDSP self, int priority):
      if self.__dsp:
        raise BassAPIError()
        
      self.__priority = priority

  property Callback:
    def __get__(BASSDSP self):
      return self.__func
    
    def __set__(BASSDSP self, object value):
    
      if not callable(value):
        raise TypeError("value must be callable")
        
      if self.__dsp:
        raise BassAPIError()
      
      self.__func = value
