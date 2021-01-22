from ....bindings.bass cimport (
  BASS_DX8_COMPRESSOR,
  _BASS_FX_DX8_COMPRESSOR)

from ...fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class Compressor(FX):

  def __cinit__(Compressor self):
    cdef BASS_DX8_COMPRESSOR *effect

    self._type = _BASS_FX_DX8_COMPRESSOR

    effect = <BASS_DX8_COMPRESSOR*>PyMem_Malloc(sizeof(BASS_DX8_COMPRESSOR))
    
    if effect == NULL:
      raise MemoryError()
      
    self._effect = effect

    effect.fGain = 0.0
    effect.fAttack = 10.0
    effect.fRelease = 200.0
    effect.fThreshold = -20.0
    effect.fRatio = 3.0
    effect.fPredelay = 4.0

  property gain:
    def __get__(Compressor self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      return effect.fGain

    def __set__(Compressor self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      self._validate_range(value, -60.0, 60.0)
      effect.fGain = value

  property attack:
    def __get__(Compressor self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      return effect.fAttack

    def __set__(Compressor self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      self._validate_range(value, 0.01, 500.0)
      effect.fAttack = value

  property release:
    def __get__(Compressor self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      return effect.fRelease

    def __set__(Compressor self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      self._validate_range(value, 50.0, 3000.0)
      effect.fRelease = value

  property threshold:
    def __get__(Compressor self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      return effect.fThreshold

    def __set__(Compressor self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      self._validate_range(value, -60.0, 0.0)
      effect.fThreshold = value

  property ratio:
    def __get__(Compressor self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      return effect.fRatio

    def __set__(Compressor self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      self._validate_range(value, 1.0, 100.0)
      effect.fRatio = value

  property predelay:
    def __get__(Compressor self):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      return effect.fPredelay

    def __set__(Compressor self, float value):
      cdef BASS_DX8_COMPRESSOR *effect = <BASS_DX8_COMPRESSOR*>(self._effect)
      self._validate_range(value, 0.0, 4.0)
      effect.fPredelay = value
