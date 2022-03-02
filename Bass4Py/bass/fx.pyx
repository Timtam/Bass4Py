from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  BASS_ChannelRemoveFX,
  BASS_ChannelSetFX,
  BASS_FXGetParameters,
  BASS_FXReset,
  BASS_FXSetParameters,
  BASS_FXSetPriority)

from .channel cimport Channel
from ..exceptions import BassAPIError, BassOutOfRangeError
from cpython.mem cimport PyMem_Free

cdef class FX(Evaluable):






  cdef void _set_fx(FX self, Channel channel):
    cdef HFX fx

    if self._fx:
      raise BassAPIError()

    fx = BASS_ChannelSetFX(channel._channel, self._type, self._priority)

    self._evaluate()

    self.channel = channel

    self._fx = fx

  # virtual method which should be overridden by subclasses
  # returns a pointer to the effect params struct for this effect
  cdef void* _get_effect(self) nogil except NULL:
    with gil: raise NotImplementedError

  cpdef set(FX self, Channel chan):
    """
    Apply this effect to a channel. 

    Parameters
    ----------
    chan : :obj:`Bass4Py.bass.Channel`
      one of the various channel implementations.

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassNoFXError`
      The specified DX8 effect is unavailable. 
    :exc:`Bass4Py.exceptions.BassFormatError`
      The channel's format is not supported by the effect. 
    :exc:`Bass4Py.exceptions.BassUnknownError`
      Some other mystery problem! 


    Multiple effects may be used per channel. Use 
    :meth:`~Bass4Py.bass.FX.remove` to remove an effect. Use the effect-specific 
    attributes to set an effect's parameters. An effect's priority value can be 
    changed via the :attr:`~Bass4Py.bass.FX.priority` attribute. 
    Effects can be applied to :class:`Bass4Py.bass.Music` and 
    :class:`Bass4Py.bass.Stream`, but not :class:`Bass4Py.bass.Sample`. If you 
    want to apply an effect to a sample, you could use a stream instead. 

    Platform-specific

    DX8 effects are a Windows feature requiring DirectX 8, or DirectX 9 for 
    floating-point support. On other platforms, they are emulated by BASS, 
    except for the following which are currently unsupported: 
    :class:`Bass4Py.bass.effects.dx8.Compressor`, 
    :class:`Bass4Py.bass.effects.dx8.Gargle`, and 
    :class:`Bass4Py.bass.effects.dx8.I3DL2Reverb`. 
    """

    self._set_fx(chan)

    try:
      self.update()
    except Exception:
      self.remove()
      raise

  cpdef remove(FX self):
    cdef bint res

    if self._fx == 0:
      raise BassAPIError()

    with nogil:
      res = BASS_ChannelRemoveFX(self.channel._channel, self._fx)
    self._evaluate()
    self._fx = 0
    self.channel = None
    return res

  cpdef reset(FX self):
    cdef bint res 

    if self._fx == 0:
      raise BassAPIError()

    with nogil:
      res = BASS_FXReset(self._fx)
    self._evaluate()
    BASS_FXGetParameters(self._fx, self._get_effect())
    return res

  cpdef update(FX self):

    if self._fx == 0:
      raise BassAPIError()

    BASS_FXSetParameters(self._fx, self._get_effect())
    self._evaluate()

  cpdef _validate_range(FX self, PARAMETER_TYPE value, PARAMETER_TYPE lbound, PARAMETER_TYPE ubound):

    if value < lbound or value > ubound:
      raise BassOutOfRangeError("FX parameter value {0} must range from {1} to {2}".format(value, lbound, ubound))

  def __eq__(FX self, object y):
    cdef FX fx
    if isinstance(y, FX):
      fx = <FX>y
      if self._fx == 0 and fx._fx == 0:
        return self._effect == fx._effect
      else:
        return self._fx == fx._fx
    return NotImplemented

  property priority:
    def __get__(FX self):
      return self._priority
    
    def __set__(FX self, int priority):
      cdef int old_priority = self._priority

      self._priority = priority

      if self._fx:
        with nogil:
          BASS_FXSetPriority(self._fx, priority)

        try:
          self._evaluate()
        except Exception as e:
          self._priority = old_priority
          raise e
