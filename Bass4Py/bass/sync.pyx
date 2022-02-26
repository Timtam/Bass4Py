from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  _BASS_SYNC_MIXTIME,
  _BASS_SYNC_ONETIME,
  _BASS_SYNC_THREAD,
  BASS_ChannelRemoveSync,
  BASS_ChannelSetSync)

from .channel cimport Channel
from ..exceptions import BassAPIError, BassSyncError

cdef void CSYNCPROC(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  cdef Sync sync = <Sync?>user

  (<object>sync)._call_callback(data)

  if sync._one_time:
    sync.Channel = None
    sync._sync = 0

cdef void __stdcall CSYNCPROC_STD(HSYNC handle, DWORD channel, DWORD data, void *user) with gil:
  CSYNCPROC(handle, channel, data, user)

cdef class Sync(Evaluable):

  cpdef set(Sync self, Channel chan):
    """
    Sets up this synchronizer to a channel. 
    
    Parameters
    ----------
    chan : :obj:`Bass4Py.bass.Channel`
      Any channel object or one of its subclasses.

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassSyncError`
      Either a :attr:`Bass4Py.bass.Sync.callback` wasn't provided or the 
      required parameters weren't set beforehand. Please read the documentation 
      of the according sync object and read the raised exception for more 
      details.


    Multiple synchronizers may be used per channel, and they can be set before 
    and while playing. Equally, synchronizers can also be removed at any time, 
    using :meth:`~Bass4Py.bass.Sync.remove`. If the 
    :attr:`~Bass4Py.bass.Sync.one_time` attribute is used then the sync is 
    automatically removed after its first occurrence. 
    The method :meth:`~Bass4Py.bass.Sync.set_mix_time` (with threading disabled) 
    can be used with :class:`Bass4Py.bass.syncs.End` or 
    :class:`Bass4Py.bass.syncs.Position` / 
    :class:`Bass4Py.bass.syncs.MusicPosition` syncs to implement custom 
    looping, by using :meth:`Bass4Py.bass.Channel.set_position` in the callback. 
    A mixtime sync can also be used to make DSP/FX changes at specific points, 
    or change a :class:`Bass4Py.bass.Music` channel's attributes. The 
    :meth:`~Bass4Py.bass.Sync.set_mix_time` method can also be useful with a 
    :class:`Bass4Py.bass.syncs.SetPosition` sync, to reset DSP states after 
    seeking. 
    Several of the sync types are triggered in the process of rendering the 
    channel's sample data; for example, :class:`Bass4Py.bass.syncs.Position` 
    and :class:`Bass4Py.bass.syncs.End` syncs, when the rendering reaches the 
    sync position or the end, respectively. Those sync types should be set 
    before starting playback or pre-buffering (ie. before any rendering), to 
    avoid missing any early sync events. 
    A channel does not need to be playing for its 
    :class:`Bass4Py.bass.syncs.DeviceFail` and 
    :class:`Bass4Py.bass.syncs.DeviceFormat` syncs to be triggered but the 
    device does need to be active, which means it needs to be playing other 
    channels or the :attr:`Bass4Py.bass.BASS.device_nonstop` option needs to be 
    enabled. 
    With recording channels, :class:`Bass4Py.bass.syncs.Position` syncs are 
    triggered just before the callback receives the block of data containing 
    the sync position. 
    """
    cdef DWORD type = self._type
    cdef HSYNC sync
    cdef SYNCPROC *cproc

    if not callable(self._func):
      raise BassSyncError("a callable callback is required for this sync")
    
    if self._force_param and self._param == 0:
      raise BassSyncError("this sync requires a parameter to be defined. Please check the documentation for more information.")

    if self._sync:
      raise BassAPIError()

    if self._one_time:
      type = type & _BASS_SYNC_ONETIME

    IF UNAME_SYSNAME == "Windows":
      cproc = <SYNCPROC*>CSYNCPROC_STD
    ELSE:
      cproc = <SYNCPROC*>CSYNCPROC

    with nogil:
      sync = BASS_ChannelSetSync(chan._channel, type, self._param, cproc, <void*>self)

    self._evaluate()
    
    self._sync = sync
    
    self.channel = chan

  cpdef remove(Sync self):
    cdef bint res

    if self._sync == 0:
      raise BassAPIError()

    with nogil:
      res = BASS_ChannelRemoveSync(self.channel._channel, self._sync)
    self._evaluate()
    self.channel = None
    self._sync = 0
    return res

  cpdef set_mix_time(Sync self, bint enable, bint threaded = False):

    cdef DWORD type = self._type
    
    if self._force_mix_time and not enable:
      raise BassSyncError('sync needs to be mix time')

    if enable:

      type = type | _BASS_SYNC_MIXTIME

      if threaded:
        type = type | _BASS_SYNC_THREAD
      elif type & _BASS_SYNC_THREAD:
        type = type ^ _BASS_SYNC_THREAD
    else:
      if type & _BASS_SYNC_THREAD:
        type = type ^ _BASS_SYNC_THREAD
      if type & _BASS_SYNC_MIXTIME:
        type = type ^ _BASS_SYNC_MIXTIME

    self._type = type

  cpdef _call_callback(Sync self, DWORD data):
    self._func(self)

  def __eq__(Sync self, object y):
    cdef Sync sync
    if isinstance(y, Sync):
      sync = <Sync>y

      if self._sync == 0 and sync._sync == 0:
        return self._func == sync._func and self._param == sync._param and self._type == sync._type and self._one_time == sync._one_time and self.channel._channel == sync.channel._channel
      else:
        return self._sync == sync._sync
    return NotImplemented

  cdef void _set_mix_time(Sync self, bint enable, bint threaded = False):

    self.set_mix_time(enable, threaded)
    self._force_mix_time = True

  property one_time:
    def __get__(Sync self):
      return self._one_time
    
    def __set__(Sync self, bint value):
      if self._sync:
        raise BassAPIError()

      self._one_time = value

  property callback:
    def __get__(Sync self):
      return self._func
    
    def __set__(Sync self, object value):
    
      if not callable(value):
        raise TypeError("value must be callable")
        
      if self._sync:
        raise BassAPIError()
      
      self._func = value
