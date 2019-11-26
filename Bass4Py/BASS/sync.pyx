from . cimport bass
from .channel cimport CHANNEL
from ..exceptions import BassAPIError, BassSyncError

cdef void CSYNCPROC(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  cdef SYNC sync = <SYNC?>user

  (<object>sync)._call_callback(data)

  if sync.__onetime:
    sync.Channel = None
    sync.__sync = 0

cdef void __stdcall CSYNCPROC_STD(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  CSYNCPROC(handle, channel, data, user)

cdef class SYNC:

  cpdef Set(SYNC self, CHANNEL chan):
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

    with nogil:
      sync = bass.BASS_ChannelSetSync(chan.__channel, self.__type, self.__param, cproc, <void*>self)

    bass.__Evaluate()
    
    self.__sync = sync
    
    self.Channel = chan

  cpdef Remove(SYNC self):
    cdef bint res

    if self.__sync == 0:
      raise BassAPIError()

    with nogil:
      res = bass.BASS_ChannelRemoveSync(self.Channel.__channel, self.__sync)
    bass.__Evaluate()
    self.Channel = None
    self.__sync = 0
    return res

  cpdef _call_callback(SYNC self, DWORD data):
    self.__func(self)

  def __eq__(SYNC self, object y):
    cdef SYNC sync
    if isinstance(y, SYNC):
      sync = <SYNC>y

      if self.__sync == 0 and sync.__sync == 0:
        return self.__func == sync.__func and self.__param == sync.__param and self.__type == sync.__type and self.__onetime == sync.__onetime and self.__mixtime == sync.__mixtime and self.Channel.__channel == sync.Channel.__channel
      else:
        return self.__sync == sync.__sync
    return NotImplemented

  property Mixtime:
    def __get__(SYNC self):
      return self.__mixtime

    def __set__(SYNC self, bint value):

      if not value and self.__forcemixtime:
        raise BassSyncError("this sync is mixtime-only")

      if self.__sync:
        raise BassAPIError()

      self.__mixtime = value

  property Onetime:
    def __get__(SYNC self):
      return self.__onetime
    
    def __set__(SYNC self, bint value):
      if self.__sync:
        raise BassAPIError()

      self.__onetime = value

  property Callback:
    def __get__(SYNC self):
      return self.__func
    
    def __set__(SYNC self, object value):
    
      if not callable(value):
        raise TypeError("value must be callable")
        
      if self.__sync:
        raise BassAPIError()
      
      self.__func = value