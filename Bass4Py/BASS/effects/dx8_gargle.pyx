from ..bass cimport (
                     BASS_DX8_GARGLE,
                     _BASS_FX_DX8_GARGLE,
                     DWORD
                    )
from ..fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class FX_DX8_GARGLE(FX):

  def __cinit__(FX_DX8_GARGLE self):
    cdef BASS_DX8_GARGLE *effect

    self.__type = _BASS_FX_DX8_GARGLE

    effect = <BASS_DX8_GARGLE*>PyMem_Malloc(sizeof(BASS_DX8_GARGLE))
    
    if effect == NULL:
      raise MemoryError()
      
    self.__effect = effect

    effect.dwRateHz = 20
    effect.dwWaveShape = 0

  property RateHz:
    def __get__(FX_DX8_GARGLE self):
      cdef BASS_DX8_GARGLE *effect = <BASS_DX8_GARGLE*>(self.__effect)
      return effect.dwRateHz

    def __set__(FX_DX8_GARGLE self, DWORD value):
      cdef BASS_DX8_GARGLE *effect = <BASS_DX8_GARGLE*>(self.__effect)
      self.__validate_range(value, 1, 1000)
      effect.dwRateHz = value

  property WaveShape:
    def __get__(FX_DX8_GARGLE self):
      cdef BASS_DX8_GARGLE *effect = <BASS_DX8_GARGLE*>(self.__effect)
      return effect.dwWaveShape

    def __set__(FX_DX8_GARGLE self, DWORD value):
      cdef BASS_DX8_GARGLE *effect = <BASS_DX8_GARGLE*>(self.__effect)
      self.__validate_range(value, 0, 1)
      effect.dwWaveShape = value
