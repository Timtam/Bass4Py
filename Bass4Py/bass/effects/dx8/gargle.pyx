from ....bindings.bass cimport (
  BASS_DX8_GARGLE,
  _BASS_FX_DX8_GARGLE,
  DWORD)

from ...fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class Gargle(FX):

  def __cinit__(Gargle self):
    cdef BASS_DX8_GARGLE *effect

    self._type = _BASS_FX_DX8_GARGLE

    effect = <BASS_DX8_GARGLE*>PyMem_Malloc(sizeof(BASS_DX8_GARGLE))
    
    if effect == NULL:
      raise MemoryError()
      
    self._effect = effect

    effect.dwRateHz = 20
    effect.dwWaveShape = 0

  property RateHz:
    def __get__(Gargle self):
      cdef BASS_DX8_GARGLE *effect = <BASS_DX8_GARGLE*>(self._effect)
      return effect.dwRateHz

    def __set__(Gargle self, DWORD value):
      cdef BASS_DX8_GARGLE *effect = <BASS_DX8_GARGLE*>(self._effect)
      self._validate_range(value, 1, 1000)
      effect.dwRateHz = value

  property WaveShape:
    def __get__(Gargle self):
      cdef BASS_DX8_GARGLE *effect = <BASS_DX8_GARGLE*>(self._effect)
      return effect.dwWaveShape

    def __set__(Gargle self, DWORD value):
      cdef BASS_DX8_GARGLE *effect = <BASS_DX8_GARGLE*>(self._effect)
      self._validate_range(value, 0, 1)
      effect.dwWaveShape = value
