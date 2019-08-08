from ..bass cimport (
                     BASS_DX8_COMPRESSOR,
                     _BASS_FX_DX8_COMPRESSOR
                    )
from ..fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class FX_DX8_COMPRESSOR(FX):

  def __cinit__(FX_DX8_COMPRESSOR self):
    cdef BASS_DX8_COMPRESSOR *effect

    self.__type = _BASS_FX_DX8_COMPRESSOR

    effect = <BASS_DX8_COMPRESSOR*>PyMem_Malloc(sizeof(BASS_DX8_COMPRESSOR))
    
    if effect == NULL:
      raise MemoryError()
      
    self.__effect = effect

    effect.fGain = 0.0
    effect.fAttack = 10.0
    effect.fRelease = 200.0
    effect.fThreshold = -20.0
    effect.fRatio = 3.0
    effect.fPredelay = 4.0

  property Gain:
    def __get__(FX_DX8_COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fGain

    def __set__(FX_DX8_COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, -60.0, 60.0)
      effect.fGain = value

  property Attack:
    def __get__(FX_DX8_COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fAttack

    def __set__(FX_DX8_COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, 0.01, 500.0)
      effect.fAttack = value

  property Release:
    def __get__(FX_DX8_COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fRelease

    def __set__(FX_DX8_COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, 50.0, 3000.0)
      effect.fRelease = value

  property Threshold:
    def __get__(FX_DX8_COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fThreshold

    def __set__(FX_DX8_COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, -60.0, 0.0)
      effect.fThreshold = value

  property Ratio:
    def __get__(FX_DX8_COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fRatio

    def __set__(FX_DX8_COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, 1.0, 100.0)
      effect.fRatio = value

  property Predelay:
    def __get__(FX_DX8_COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fPredelay

    def __set__(FX_DX8_COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, 0.0, 4.0)
      effect.fPredelay = value
