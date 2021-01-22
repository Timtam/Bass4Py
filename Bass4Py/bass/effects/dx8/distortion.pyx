from ....bindings.bass cimport (
  BASS_DX8_DISTORTION,
  _BASS_FX_DX8_DISTORTION)

from ...fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class Distortion(FX):

  def __cinit__(Distortion self):
    cdef BASS_DX8_DISTORTION *effect

    self._type = _BASS_FX_DX8_DISTORTION

    effect = <BASS_DX8_DISTORTION*>PyMem_Malloc(sizeof(BASS_DX8_DISTORTION))
    
    if effect == NULL:
      raise MemoryError()
      
    self._effect = effect

    effect.fGain = -18.0
    effect.fEdge = 15.0
    effect.fPostEQCenterFrequency = 2400.0
    effect.fPostEQBandwidth = 2400.0
    effect.fPreLowpassCutoff = 8000.0

  property gain:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      return effect.fGain

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      self._validate_range(value, -60.0, 0.0)
      effect.fGain = value

  property edge:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      return effect.fEdge

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      self._validate_range(value, 0.0, 100.0)
      effect.fEdge = value

  property post_eq_center_frequency:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      return effect.fPostEQCenterFrequency

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      self._validate_range(value, 100.0, 8000.0)
      effect.fPostEQCenterFrequency = value

  property post_eq_bandwidth:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      return effect.fPostEQBandwidth

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      self._validate_range(value, 100.0, 8000.0)
      effect.fPostEQBandwidth = value

  property pre_lowpass_cutoff:
    def __get__(Distortion self):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      return effect.fPreLowpassCutoff

    def __set__(Distortion self, float value):
      cdef BASS_DX8_DISTORTION *effect = <BASS_DX8_DISTORTION*>(self._effect)
      self._validate_range(value, 100.0, 8000.0)
      effect.fPreLowpassCutoff = value
