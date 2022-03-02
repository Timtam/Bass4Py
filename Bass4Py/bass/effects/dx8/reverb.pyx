from ....bindings.bass cimport (
  BASS_DX8_REVERB,
  _BASS_FX_DX8_REVERB,
  DWORD)

from ...fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class Reverb(FX):
  cdef BASS_DX8_REVERB *effect


  cdef void* _get_effect(self) nogil except NULL: return <void*>&self.effect

  def __cinit__(Reverb self):


    self._type = _BASS_FX_DX8_REVERB


    


      


    self.effect.fInGain = 0.0
    self.effect.fReverbMix = 0.0
    self.effect.fReverbTime = 1000.0
    self.effect.fHighFreqRTRatio = 0.001

  property in_gain:
    def __get__(Reverb self):

      return self.effect.fInGain

    def __set__(Reverb self, float value):

      self._validate_range(value, -96.0, 0.0)
      self.effect.fInGain = value

  property reverb_mix:
    def __get__(Reverb self):

      return self.effect.fReverbMix

    def __set__(Reverb self, float value):

      self._validate_range(value, -96.0, 0.0)
      self.effect.fReverbMix = value

  property reverb_time:
    def __get__(Reverb self):

      return self.effect.fReverbTime

    def __set__(Reverb self, float value):

      self._validate_range(value, 0.001, 3000.0)
      self.effect.fReverbTime = value

  property high_freq_rt_ratio:
    def __get__(Reverb self):

      return self.effect.fHighFreqRTRatio

    def __set__(Reverb self, float value):

      self._validate_range(value, 0.01, 0.999)
      self.effect.fHighFreqRTRatio = value
