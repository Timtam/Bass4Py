from ..bass cimport (
                     BASS_DX8_ECHO,
                     _BASS_FX_DX8_ECHO
                    )
from ..bassfx cimport BASSFX
from cpython.mem cimport PyMem_Malloc, PyMem_Free

cdef class BASSFX_DX8ECHO(BASSFX):

  def __cinit__(BASSFX_DX8ECHO self):
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

  def __dealloc__(BASSFX_DX8ECHO self):
    if self.__effect != NULL:
      PyMem_Free(self.__effect)
      self.__effect = NULL

  property WetDryMix:
    def __get__(BASSFX_DX8ECHO self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.fWetDryMix

    def __set__(BASSFX_DX8ECHO self, float value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, 0.0, 100.0)
      effect.fWetDryMix = value

  property Feedback:
    def __get__(BASSFX_DX8ECHO self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.fFeedback

    def __set__(BASSFX_DX8ECHO self, float value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, 0.0, 100.0)
      effect.fFeedback = value

  property LeftDelay:
    def __get__(BASSFX_DX8ECHO self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.fLeftDelay

    def __set__(BASSFX_DX8ECHO self,float value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, 1.0, 2000.0)
      effect.fLeftDelay = value

  property RightDelay:
    def __get__(BASSFX_DX8ECHO self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.fRightDelay

    def __set__(BASSFX_DX8ECHO self, float value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, 1.0, 2000.0)
      effect.fRightDelay = value

  property PanDelay:
    def __get__(BASSFX_DX8ECHO self):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      return effect.lPanDelay

    def __set__(BASSFX_DX8ECHO self, bint value):
      cdef BASS_DX8_ECHO *effect = <BASS_DX8_ECHO*>(self.__effect)
      self.__validate_range(value, False, True)
      effect.lPanDelay = value
