from ...bass cimport (
                      BASS_DX8_ECHO,
                      _BASS_FX_DX8_ECHO
                     )
from ...fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class Echo(FX):

  def __cinit__(Echo self):
    cdef BASS_DX8_ECHO *effect

    self.__type = _BASS_FX_DX8_ECHO

    effect = <BASS_DX8_ECHO*>PyMem_Malloc(sizeof(BASS_DX8_ECHO))
    
    if effect == NULL:
      raise MemoryError()
      
    self.__effect = effect

    effect.fWetDryMix = 50.0
    effect.fFeedback = 50.0
    effect.fLeftDelay = 500.0
    effect.fRightDelay = 500.0
    effect.lPanDelay = False

  property WetDryMix:
    def __get__(Echo self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.fWetDryMix

    def __set__(Echo self, float value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, 0.0, 100.0)
      effect.fWetDryMix = value

  property Feedback:
    def __get__(Echo self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.fFeedback

    def __set__(Echo self, float value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, 0.0, 100.0)
      effect.fFeedback = value

  property LeftDelay:
    def __get__(Echo self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.fLeftDelay

    def __set__(Echo self,float value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, 1.0, 2000.0)
      effect.fLeftDelay = value

  property RightDelay:
    def __get__(Echo self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.fRightDelay

    def __set__(Echo self, float value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, 1.0, 2000.0)
      effect.fRightDelay = value

  property PanDelay:
    def __get__(Echo self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.lPanDelay

    def __set__(Echo self, bint value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, False, True)
      effect.lPanDelay = value
