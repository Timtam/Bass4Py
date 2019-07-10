from . cimport bass
from .basschannel cimport BASSCHANNEL
from .exceptions import BassError, BassAPIError, BassOutOfRangeError

cdef class BASSFX:
  cpdef Set(BASSFX self, BASSCHANNEL chan, bint update = True):
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

  cpdef Remove(BASSFX self):
    cdef bint res

    if self.__fx == 0:
      raise BassAPIError()

    res = bass.BASS_ChannelRemoveFX(self.Channel.__channel, self.__fx)
    bass.__Evaluate()
    self.__fx = 0
    self.Channel = None
    return res

  cpdef Reset(BASSFX self):
    cdef bint res 

    if self.__fx == 0:
      raise BassAPIError()

    res = bass.BASS_FXReset(self.__fx)
    bass.__Evaluate()
    bass.BASS_FXGetParameters(self.__fx, self.__effect)
    return res

  cpdef Update(BASSFX self):

    if self.__fx == 0:
      raise BassAPIError()

    bass.BASS_FXSetParameters(self.__hfx, self.__effect)
    bass.__Evaluate()

  cpdef __validate_range(BASSFX self, PARAMETER_TYPE value, PARAMETER_TYPE lbound, PARAMETER_TYPE ubound):

    if value < lbound or value > ubound:
      raise BassOutOfRangeError("FX parameter value {0} must range from {1} to {2}".format(value, lbound, ubound))

  def __eq__(BASSFX self, object y):
    cdef BASSFX fx
    if isinstance(y, BASSFX):
      fx = <BASSFX>y
      if self.__fx == 0 and fx.__fx == 0:
        return self.__effect == fx.__effect
      else:
        return self.__fx == fx.__fx
    return NotImplemented

  property Priority:
    def __get__(BASSFX self):
      return self.__priority
    
    def __set__(BASSFX self, int priority):
      cdef int old_priority = self.__priority

      self.__priority = priority

      if self.__fx:
        bass.BASS_FXSetPriority(self.__fx, priority)

        try:
          bass.__Evaluate()
        except BassError, e:
          self.__priority = old_priority
          raise e
