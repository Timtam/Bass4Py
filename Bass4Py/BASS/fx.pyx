from .bass cimport __Evaluate
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

cdef class FX:

  def __dealloc__(FX self):
    if self._effect != NULL:
      PyMem_Free(self._effect)
      self._effect = NULL

  cpdef Set(FX self, Channel chan, bint update = True):
    cdef HFX fx

    if self._fx:
      raise BassAPIError()

    with nogil:
      fx = BASS_ChannelSetFX(chan._channel, self._type, self._priority)

    __Evaluate()

    self.Channel = chan

    self._fx = fx

    if update:
      with nogil:
        BASS_FXSetParameters(self._fx, self._effect)

      try:
        __Evaluate()
      except Exception, e:
        self.Remove()
        raise e

  cpdef Remove(FX self):
    cdef bint res

    if self._fx == 0:
      raise BassAPIError()

    with nogil:
      res = BASS_ChannelRemoveFX(self.Channel._channel, self._fx)
    __Evaluate()
    self._fx = 0
    self.Channel = None
    return res

  cpdef Reset(FX self):
    cdef bint res 

    if self._fx == 0:
      raise BassAPIError()

    with nogil:
      res = BASS_FXReset(self._fx)
    __Evaluate()
    BASS_FXGetParameters(self._fx, self._effect)
    return res

  cpdef Update(FX self):

    if self._fx == 0:
      raise BassAPIError()

    BASS_FXSetParameters(self._fx, self._effect)
    __Evaluate()

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

  property Priority:
    def __get__(FX self):
      return self._priority
    
    def __set__(FX self, int priority):
      cdef int old_priority = self._priority

      self._priority = priority

      if self._fx:
        with nogil:
          BASS_FXSetPriority(self._fx, priority)

        try:
          __Evaluate()
        except Exception as e:
          self._priority = old_priority
          raise e
