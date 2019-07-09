from . cimport bass
from .basschannel cimport BASSCHANNEL
from .exceptions import BassAPIError, BassSyncError

cdef void CSYNCPROC(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  cdef BASSSYNC sync = <BASSSYNC?>user

  (<object>sync)._call_callback(data)

  if sync.__onetime:
    sync.__channel = 0
    sync.__sync = 0

cdef void __stdcall CSYNCPROC_STD(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  CSYNCPROC(handle, channel, data, user)

cdef class BASSSYNC:

  cpdef Set(BASSSYNC self, FUSED_CHANNEL chan):
    cdef DWORD type = self.__type
    cdef HSYNC sync
    cdef SYNCPROC *cproc

    if not callable(self.__func):
      raise BassSyncError("a callable callback is required for this sync")
    
    if self.__forceparam and self.__param == 0:
      raise BassSyncError("this sync requires a parameter to be defined. Please check the documentation for more information.")

    if self.__sync:
      raise BassAPIError()

    if self.__onetime:
      type = type & bass._BASS_SYNC_ONETIME
    if self.__mixtime:
      type = type & bass._BASS_SYNC_MIXTIME

    IF UNAME_SYSNAME == "Windows":
      cproc = <SYNCPROC*>CSYNCPROC_STD
    ELSE:
      cproc = <SYNCPROC*>CSYNCPROC

    if FUSED_CHANNEL is HCHANNEL:
      sync = bass.BASS_ChannelSetSync(chan, self.__type, self.__param, cproc, <void*>self)
    elif FUSED_CHANNEL is BASSCHANNEL:
      sync = bass.BASS_ChannelSetSync(chan.__channel, self.__type, self.__param, cproc, <void*>self)

    bass.__Evaluate()
    
    self.__sync = sync
    
    if FUSED_CHANNEL is HCHANNEL:
      self.__channel = chan
    elif FUSED_CHANNEL is BASSCHANNEL:
      self.__channel = chan.__channel

  cpdef Remove(BASSSYNC self):
    cdef bint res

    if self.__sync == 0:
      raise BassAPIError()

    res = bass.BASS_ChannelRemoveSync(self.__channel, self.__sync)
    bass.__Evaluate()
    return res

  cpdef _call_callback(BASSSYNC self, DWORD data):
    self.__func(self)

  def __eq__(BASSSYNC self, object y):
    cdef BASSSYNC sync
    if isinstance(y, BASSSYNC):
      sync = <BASSSYNC>y

      if self.__sync == 0 and sync.__sync == 0:
        return self.__func == sync.__func and self.__param == sync.__param and self.__type == sync.__type and self.__onetime == sync.__onetime and self.__mixtime == sync.__mixtime
      else:
        return self.__sync == sync.__sync
    return NotImplemented

  property Channel:
    def __get__(BASSSYNC self):
      return BASSCHANNEL(self.__channel)

  property Mixtime:
    def __get__(BASSSYNC self):
      return self.__mixtime

    def __set__(BASSSYNC self, bint value):

      if not value and self.__forcemixtime:
        raise BassSyncError("this sync is mixtime-only")

      if self.__sync:
        raise BassAPIError()

      self.__mixtime = value

  property Onetime:
    def __get__(BASSSYNC self):
      return self.__onetime
    
    def __set__(BASSSYNC self, bint value):
      if self.__sync:
        raise BassAPIError()

      self.__onetime = value

  property Callback:
    def __get__(BASSSYNC self):
      return self.__func
    
    def __set__(BASSSYNC self, object value):
    
      if not callable(value):
        raise TypeError("value must be callable")
        
      if self.__sync:
        raise BassAPIError()
      
      self.__func = value
