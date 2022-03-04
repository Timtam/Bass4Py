from ....bindings.bass cimport (
  BASS_DX8_DISTORTION,
  _BASS_FX_DX8_DISTORTION)

from ...fx cimport FX


cdef class Distortion(FX):
  cdef BASS_DX8_DISTORTION effect

  cdef void* _get_effect(self) nogil except NULL: return <void*>&self.effect


  def __cinit__(Distortion self):


    self._type = _BASS_FX_DX8_DISTORTION


    


      


    self.effect.fGain = -18.0
    self.effect.fEdge = 15.0
    self.effect.fPostEQCenterFrequency = 2400.0
    self.effect.fPostEQBandwidth = 2400.0
    self.effect.fPreLowpassCutoff = 8000.0

  property gain:
    def __get__(Distortion self):

      return self.effect.fGain

    def __set__(Distortion self, float value):

      self._validate_range(value, -60.0, 0.0)
      self.effect.fGain = value

  property edge:
    def __get__(Distortion self):

      return self.effect.fEdge

    def __set__(Distortion self, float value):

      self._validate_range(value, 0.0, 100.0)
      self.effect.fEdge = value

  property post_eq_center_frequency:
    def __get__(Distortion self):

      return self.effect.fPostEQCenterFrequency

    def __set__(Distortion self, float value):

      self._validate_range(value, 100.0, 8000.0)
      self.effect.fPostEQCenterFrequency = value

  property post_eq_bandwidth:
    def __get__(Distortion self):

      return self.effect.fPostEQBandwidth

    def __set__(Distortion self, float value):

      self._validate_range(value, 100.0, 8000.0)
      self.effect.fPostEQBandwidth = value

  property pre_lowpass_cutoff:
    def __get__(Distortion self):

      return self.effect.fPreLowpassCutoff

    def __set__(Distortion self, float value):

      self._validate_range(value, 100.0, 8000.0)
      self.effect.fPreLowpassCutoff = value
