from . cimport bass
from .channel cimport CHANNEL
from ..exceptions import BassError, BassAPIError, BassOutOfRangeError

cdef class FX:
  cpdef Set(FX self, CHANNEL chan, bint update = True):
    cdef HFX fx

    if self.__fx:
      raise BassAPIError()

    fx = bass.BASS_ChannelSetFX(chan.__channel, self.__type, self.__priority)

    bass.__Evaluate()

    self.Channel = chan

    self.__fx = fx

    if update:
      bass.BASS_FXSetParameters(self.__fx, self.__effect)

      try:
        bass.__Evaluate()
      except Exception, e:
        self.Remove()
        raise e

  cpdef Remove(FX self):
    cdef bint res

    if self.__fx == 0:
      raise BassAPIError()

    res = bass.BASS_ChannelRemoveFX(self.Channel.__channel, self.__fx)
    bass.__Evaluate()
    self.__fx = 0
    self.Channel = None
    return res

  cpdef Reset(FX self):
    cdef bint res 

    if self.__fx == 0:
      raise BassAPIError()

    res = bass.BASS_FXReset(self.__fx)
    bass.__Evaluate()
    bass.BASS_FXGetParameters(self.__fx, self.__effect)
    return res

  cpdef Update(FX self):

    if self.__fx == 0:
      raise BassAPIError()

    bass.BASS_FXSetParameters(self.__hfx, self.__effect)
    bass.__Evaluate()

  cpdef __validate_range(FX self, PARAMETER_TYPE value, PARAMETER_TYPE lbound, PARAMETER_TYPE ubound):

    if value < lbound or value > ubound:
      raise BassOutOfRangeError("FX parameter value {0} must range from {1} to {2}".format(value, lbound, ubound))

  def __eq__(FX self, object y):
    cdef FX fx
    if isinstance(y, FX):
      fx = <FX>y
      if self.__fx == 0 and fx.__fx == 0:
        return self.__effect == fx.__effect
      else:
        return self.__fx == fx.__fx
    return NotImplemented

  property Priority:
    def __get__(FX self):
      return self.__priority
    
    def __set__(FX self, int priority):
      cdef int old_priority = self.__priority

      self.__priority = priority

      if self.__fx:
        bass.BASS_FXSetPriority(self.__fx, priority)

        try:
          bass.__Evaluate()
        except BassError, e:
          self.__priority = old_priority
          raise e
