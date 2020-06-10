from . cimport bass
from .channel cimport Channel
from ..exceptions import BassAPIError, BassSyncError

cdef void CSYNCPROC(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  cdef Sync sync = <Sync?>user

  (<object>sync)._call_callback(data)

  if sync._onetime:
    sync.Channel = None
    sync._sync = 0

cdef void __stdcall CSYNCPROC_STD(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  CSYNCPROC(handle, channel, data, user)

cdef class Sync:

  cpdef Set(Sync self, Channel chan):
    cdef DWORD type = self._type
    cdef HSYNC sync
    cdef SYNCPROC *cproc

    if not callable(self._func):
      raise BassSyncError("a callable callback is required for this sync")
    
    if self._forceparam and self._param == 0:
      raise BassSyncError("this sync requires a parameter to be defined. Please check the documentation for more information.")

    if self._sync:
      raise BassAPIError()

    if self._onetime:
      type = type & bass._BASS_SYNC_ONETIME

    IF UNAME_SYSNAME == "Windows":
      cproc = <SYNCPROC*>CSYNCPROC_STD
    ELSE:
      cproc = <SYNCPROC*>CSYNCPROC

    with nogil:
      sync = bass.BASS_ChannelSetSync(chan._channel, type, self._param, cproc, <void*>self)

    bass.__Evaluate()
    
    self._sync = sync
    
    self.Channel = chan

  cpdef Remove(Sync self):
    cdef bint res

    if self._sync == 0:
      raise BassAPIError()

    with nogil:
      res = bass.BASS_ChannelRemoveSync(self.Channel._channel, self._sync)
    bass.__Evaluate()
    self.Channel = None
    self._sync = 0
    return res

  cpdef SetMixtime(Sync self, bint enable, bint threaded = False):

    cdef DWORD type = self._type
    
    if self._forcemixtime and not enable:
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

    self._type = type

  cpdef _call_callback(Sync self, DWORD data):
    self._func(self)

  def __eq__(Sync self, object y):
    cdef Sync sync
    if isinstance(y, Sync):
      sync = <Sync>y

      if self._sync == 0 and sync._sync == 0:
        return self._func == sync._func and self._param == sync._param and self._type == sync._type and self._onetime == sync._onetime and self.Channel._channel == sync.Channel._channel
      else:
        return self._sync == sync._sync
    return NotImplemented

  cdef void _set_mixtime(Sync self, bint enable, bint threaded = False):

    self.SetMixtime(enable, threaded)
    self._forcemixtime = True

  property Onetime:
    def __get__(Sync self):
      return self._onetime
    
    def __set__(Sync self, bint value):
      if self._sync:
        raise BassAPIError()

      self._onetime = value

  property Callback:
    def __get__(Sync self):
      return self._func
    
    def __set__(Sync self, object value):
    
      if not callable(value):
        raise TypeError("value must be callable")
        
      if self._sync:
        raise BassAPIError()
      
      self._func = value
