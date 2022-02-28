from libc.string cimport memmove

from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  BASS_ChannelSetDSP,
  BASS_ChannelRemoveDSP,
  DSPPROC)

from .channel cimport Channel
from ..exceptions import BassAPIError

cdef void CDSPPROC(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil:
  cdef DSP odsp = <DSP?>user
  cdef bytes result
  cdef char *cbuffer

  cbuffer=<char *>buffer
  result = odsp._func(odsp, <bytes>cbuffer[:length])

  if (<DWORD>len(result)) > length:
    result = result[:length]
  memmove(buffer, (<char *>result), length)

cdef void __stdcall CDSPPROC_STD(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil:
  CDSPPROC(dsp, channel, buffer, length, user)

cdef class DSP(Evaluable):

  cpdef remove(DSP self):
    cdef bint res
    with nogil:
      res = BASS_ChannelRemoveDSP(self.channel._channel, self._dsp)
    self._evaluate()
    return res

  cpdef set(DSP self, Channel chan):
    """
    Applies this DSP to a channel. 

    Parameters
    ----------
    chan : :obj:`Bass4Py.bass.Channel`
      the channel to which the DSP should be applied
    
    
    DSPs can be set and removed at any time, including mid-playback. Use 
    :meth:`~Bass4Py.bass.DSP.remove` to remove a DSP from its channel. 
    Multiple DSP functions may be used per channel, in which case the order 
    that the callbacks are called is determined by their priorities. The 
    priorities can be changed via the :attr:`~Bass4Py.bass.DSP.priority` 
    attribute. Any DSPs that have the same priority are called in the order 
    that they were given that priority. 
    DSPs can be applied to :class:`Bass4Py.bass.Music` and 
    :class:`Bass4Py.bass.Stream`, but not :class:`Bass4Py.bass.Sample`. If you 
    want to apply a DSP to a sample then you should stream it instead. 
    """
    cdef HDSP dsp
    cdef DSPPROC *cproc
    
    if self.__dsp:
      raise BassAPIError()

    IF UNAME_SYSNAME == "Windows":
      cproc = <DSPPROC*>CDSPPROC_STD
    ELSE:
      cproc = <DSPPROC*>CDSPPROC

    dsp = BASS_ChannelSetDSP(chan._channel, cproc, <void*>self, self._priority)
    
    self._evaluate()
    
    self._dsp = dsp
    self.channel = chan

  property priority:
    def __get__(DSP self):
      return self._priority
    
    def __set__(DSP self, int priority):
      if self._dsp:
        raise BassAPIError()
        
      self._priority = priority

  property callback:
    def __get__(DSP self):
      return self._func
    
    def __set__(DSP self, object value):
    
      if not callable(value):
        raise TypeError("value must be callable")
        
      if self._dsp:
        raise BassAPIError()
      
      self._func = value
