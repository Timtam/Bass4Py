from ....bindings.bass cimport (
  BASS_DX8_FLANGER,
  _BASS_DX8_PHASE_NEG_180,
  _BASS_DX8_PHASE_ZERO,
  _BASS_DX8_PHASE_180,
  _BASS_FX_DX8_FLANGER,
  DWORD)

from ...fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class Flanger(FX):

  def __cinit__(Flanger self):
    cdef BASS_DX8_FLANGER *effect

    self._type = _BASS_FX_DX8_FLANGER

    effect = <BASS_DX8_FLANGER*>PyMem_Malloc(sizeof(BASS_DX8_FLANGER))
    
    if effect == NULL:
      raise MemoryError()
      
    self._effect = effect

    effect.fWetDryMix = 50.0
    effect.fDepth = 100.0
    effect.fFeedback = -50.0
    effect.fFrequency = 0.25
    effect.lWaveform = 1
    effect.fDelay = 2.0
    effect.lPhase = _BASS_DX8_PHASE_ZERO

  property wet_dry_mix:
    def __get__(Flanger self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      return effect.fWetDryMix

    def __set__(Flanger self, float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      self._validate_range(value, 0.0, 100.0)
      effect.fWetDryMix = value

  property depth:
    def __get__(Flanger self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      return effect.fDepth

    def __set__(Flanger self,float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      self._validate_range(value, 0.0, 100.0)
      effect.fDepth = value

  property feedback:
    def __get__(Flanger self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      return effect.fFeedback

    def __set__(Flanger self, float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      self._validate_range(value, -99.0, 99.0)
      effect.fFeedback = value

  property frequency:
    def __get__(Flanger self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      return effect.fFrequency

    def __set__(Flanger self,float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      self._validate_range(value, 0.0, 10.0)
      effect.fFrequency = value

  property waveform:
    def __get__(Flanger self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      return effect.lWaveform

    def __set__(Flanger self, DWORD value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      self._validate_range(value, 0, 1)
      effect.lWaveform = value

  property delay:
    def __get__(Flanger self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      return effect.fDelay

    def __set__(Flanger self, float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      self._validate_range(value, 0.0, 4.0)
      effect.fDelay = value

  property phase:
    def __get__(Flanger self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      return effect.lPhase

    def __set__(Flanger self, DWORD value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self._effect)
      self._validate_range(value, _BASS_DX8_PHASE_NEG_180, _BASS_DX8_PHASE_180)
      effect.lPhase = value
