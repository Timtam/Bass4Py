from ..bass cimport (
                     BASS_DX8_COMPRESSOR,
                     _BASS_FX_DX8_COMPRESSOR
                    )
from ..bassfx cimport BASSFX
from cpython.mem cimport PyMem_Malloc, PyMem_Free

cdef class BASSFX_DX8COMPRESSOR(BASSFX):

  def __cinit__(BASSFX_DX8COMPRESSOR self):
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

  def __dealloc__(BASSFX_DX8COMPRESSOR self):
    if self.__effect != NULL:
      PyMem_Free(self.__effect)
      self.__effect = NULL

  property Gain:
    def __get__(BASSFX_DX8COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fGain

    def __set__(BASSFX_DX8COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, -60.0, 60.0)
      effect.fGain = value

  property Attack:
    def __get__(BASSFX_DX8COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fAttack

    def __set__(BASSFX_DX8COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, 0.01, 500.0)
      effect.fAttack = value

  property Release:
    def __get__(BASSFX_DX8COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fRelease

    def __set__(BASSFX_DX8COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, 50.0, 3000.0)
      effect.fRelease = value

  property Threshold:
    def __get__(BASSFX_DX8COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fThreshold

    def __set__(BASSFX_DX8COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, -60.0, 0.0)
      effect.fThreshold = value

  property Ratio:
    def __get__(BASSFX_DX8COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fRatio

    def __set__(BASSFX_DX8COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, 1.0, 100.0)
      effect.fRatio = value

  property Predelay:
    def __get__(BASSFX_DX8COMPRESSOR self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      return effect.fPredelay

    def __set__(BASSFX_DX8COMPRESSOR self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self.__effect)
      self.__validate_range(value, 0.0, 4.0)
      effect.fPredelay = value
