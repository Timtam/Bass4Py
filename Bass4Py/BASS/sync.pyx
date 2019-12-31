from . cimport bass
from .channel cimport Channel
from ..exceptions import BassApiError, BassSyncError

cdef void CSYNCPROC(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  cdef Sync sync = <Sync?>user

  (<object>sync)._call_callback(data)

  if sync.__onetime:
    sync.Channel = None
    sync.__sync = 0

cdef void __stdcall CSYNCPROC_STD(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  CSYNCPROC(handle, channel, data, user)

cdef class Sync:

  cpdef Set(Sync self, Channel chan):
    cdef DWORD type = self.__type
    cdef HSYNC sync
    cdef SYNCPROC *cproc

    if not callable(self.__func):
      raise BassSyncError("a callable callback is required for this sync")
    
    if self.__forceparam and self.__param == 0:
      raise BassSyncError("this sync requires a parameter to be defined. Please check the documentation for more information.")

    if self.__sync:
      raise BassApiError()

    if self.__onetime:
      type = type & bass._BASS_SYNC_ONETIME

    IF UNAME_SYSNAME == "Windows":
      cproc = <SYNCPROC*>CSYNCPROC_STD
    ELSE:
      cproc = <SYNCPROC*>CSYNCPROC

    with nogil:
      sync = bass.BASS_ChannelSetSync(chan.__channel, type, self.__param, cproc, <void*>self)

    bass.__Evaluate()
    
    self.__sync = sync
    
    self.Channel = chan

  cpdef Remove(Sync self):
    cdef bint res

    if self.__sync == 0:
      raise BassApiError()

    with nogil:
      res = bass.BASS_ChannelRemoveSync(self.Channel.__channel, self.__sync)
    bass.__Evaluate()
    self.Channel = None
    self.__sync = 0
    return res

  cpdef SetMixtime(Sync self, bint enable, bint threaded = False):

    cdef DWORD type = self.__type
    
    if self.__forcemixtime and not enable:
      raise BassSyncError('sync needs to be mixtime')

    if enable:

      type = type | bass._BASS_SYNC_MIXTIME

      if threaded:
        type = type | bass._BASS_SYNC_THREAD
      elif type & bass._BASS_SYNC_THREAD:
        type = type ^ bass._BASS_SYNC_THREAD
    else:
      if type & bass._BASS_SYNC_THREAD:
        type = type ^ bass._BASS_SYNC_THREAD
      if type & bass._BASS_SYNC_MIXTIME:
        type = type ^ bass._BASS_SYNC_MIXTIME

    self.__type = type

  cpdef _call_callback(Sync self, DWORD data):
    self.__func(self)

  def __eq__(Sync self, object y):
    cdef Sync sync
    if isinstance(y, Sync):
      sync = <Sync>y

      if self.__sync == 0 and sync.__sync == 0:
        return self.__func == sync.__func and self.__param == sync.__param and self.__type == sync.__type and self.__onetime == sync.__onetime and self.Channel.__channel == sync.Channel.__channel
      else:
        return self.__sync == sync.__sync
    return NotImplemented

  cdef void _set_mixtime(Sync self, bint enable, bint threaded = False):

    self.SetMixtime(enable, threaded)
    self.__forcemixtime = True

  property Onetime:
    def __get__(Sync self):
      return self.__onetime
    
    def __set__(Sync self, bint value):
      if self.__sync:
        raise BassApiError()

      self.__onetime = value

  property Callback:
    def __get__(Sync self):
      return self.__func
    
    def __set__(Sync self, object value):
    
      if not callable(value):
        raise TypeError("value must be callable")
        
      if self.__sync:
        raise BassApiError()
      
      self.__func = value
