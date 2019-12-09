from ...bass cimport (
                      BASS_DX8_DISTORTION,
                      _BASS_FX_DX8_DISTORTION
                     )
from ...fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class Distortion(FX):

  def __cinit__(Distortion self):
    cdef BASS_DX8_DISTORTION *effect

    self.__type = _BASS_FX_DX8_DISTORTION

    effect = <BASS_DX8_DISTORTION*>PyMem_Malloc(sizeof(BASS_DX8_DISTORTION))
    
    if effect == NULL:
      raise MemoryError()
      
    self.__effect = effect

    effect.fGain = -18.0
    effect.fEdge = 15.0
    effect.fPostEQCenterFrequency = 2400.0
    effect.fPostEQBandwidth = 2400.0
    effect.fPreLowpassCutoff = 8000.0

  property Gain:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      return effect.fGain

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      self.__validate_range(value, -60.0, 0.0)
      effect.fGain = value

  property Edge:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      return effect.fEdge

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      self.__validate_range(value, 0.0, 100.0)
      effect.fEdge = value

  property PostEQCenterFrequency:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      return effect.fPostEQCenterFrequency

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      self.__validate_range(value, 100.0, 8000.0)
      effect.fPostEQCenterFrequency = value

  property PostEQBandwidth:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      return effect.fPostEQBandwidth

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      self.__validate_range(value, 100.0, 8000.0)
      effect.fPostEQBandwidth = value

  property PreLowpassCutoff:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      return effect.fPreLowpassCutoff

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self.__effect)
      self.__validate_range(value, 100.0, 8000.0)
      effect.fPreLowpassCutoff = value
