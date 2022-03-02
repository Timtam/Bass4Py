from ....bindings.bass cimport (
  BASS_DX8_GARGLE,
  _BASS_FX_DX8_GARGLE,
  DWORD)

from ...fx cimport FX


cdef class Gargle(FX):
  cdef BASS_DX8_GARGLE effect

  cdef void* _get_effect(self) nogil except NULL: return <void*>&self.effect

  def __cinit__(Gargle self):


    self._type = _BASS_FX_DX8_GARGLE


    


      


    self.effect.dwRateHz = 20
    self.effect.dwWaveShape = 0

  property rate_hz:
    def __get__(Gargle self):

      return self.effect.dwRateHz

    def __set__(Gargle self, DWORD value):

      self._validate_range(value, 1, 1000)
      self.effect.dwRateHz = value

  property wave_shape:
    def __get__(Gargle self):

      return self.effect.dwWaveShape

    def __set__(Gargle self, DWORD value):

      self._validate_range(value, 0, 1)
      self.effect.dwWaveShape = value
