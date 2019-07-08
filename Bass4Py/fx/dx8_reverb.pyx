from ..bass cimport (
                     BASS_DX8_REVERB,
                     _BASS_FX_DX8_REVERB,
                     DWORD
                    )
from ..bassfx cimport BASSFX
from libc.stdlib cimport malloc, free

cdef class BASSFX_DX8REVERB(BASSFX):

  def __cinit__(BASSFX_DX8REVERB self):
    cdef BASS_DX8_REVERB *effect

    self.__type = _BASS_FX_DX8_REVERB

    effect = <BASS_DX8_REVERB*>malloc(sizeof(BASS_DX8_REVERB))
    
    if effect == NULL:
      raise MemoryError()
      
    self.__effect = effect

    effect.fInGain = 0.0
    effect.fReverbMix = 0.0
    effect.fReverbTime = 1000.0
    effect.fHighFreqRTRatio = 0.001

  def __dealloc__(BASSFX_DX8REVERB self):
    if self.__effect != NULL:
      free(self.__effect)
      self.__effect = NULL

  property InGain:
    def __get__(BASSFX_DX8REVERB self):
      cdef BASS_DX8_REVERB *effect = <BASS_DX8_REVERB*>(self.__effect)
      return effect.fInGain

    def __set__(BASSFX_DX8REVERB self, float value):
      cdef BASS_DX8_REVERB *effect = <BASS_DX8_REVERB*>(self.__effect)
      self.__validate_range(value, -96.0, 0.0)
      effect.fInGain = value

  property ReverbMix:
    def __get__(BASSFX_DX8REVERB self):
      cdef BASS_DX8_REVERB *effect = <BASS_DX8_REVERB*>(self.__effect)
      return effect.fReverbMix

    def __set__(BASSFX_DX8REVERB self, float value):
      cdef BASS_DX8_REVERB *effect = <BASS_DX8_REVERB*>(self.__effect)
      self.__validate_range(value, -96.0, 0.0)
      effect.fReverbMix = value

  property ReverbTime:
    def __get__(BASSFX_DX8REVERB self):
      cdef BASS_DX8_REVERB *effect = <BASS_DX8_REVERB*>(self.__effect)
      return effect.fReverbTime

    def __set__(BASSFX_DX8REVERB self, float value):
      cdef BASS_DX8_REVERB *effect = <BASS_DX8_REVERB*>(self.__effect)
      self.__validate_range(value, 0.001, 3000.0)
      effect.fReverbTime = value

  property HighFreqRTRatio:
    def __get__(BASSFX_DX8REVERB self):
      cdef BASS_DX8_REVERB *effect = <BASS_DX8_REVERB*>(self.__effect)
      return effect.fHighFreqRTRatio

    def __set__(BASSFX_DX8REVERB self, float value):
      cdef BASS_DX8_REVERB *effect = <BASS_DX8_REVERB*>(self.__effect)
      self.__validate_range(value, 0.01, 0.999)
      effect.fHighFreqRTRatio = value
