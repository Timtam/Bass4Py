from ....bindings.bass cimport (
  BASS_DX8_CHORUS,
  _BASS_DX8_PHASE_NEG_180,
  _BASS_DX8_PHASE_90,
  _BASS_DX8_PHASE_180,
  _BASS_FX_DX8_CHORUS,
  DWORD)

from ...fx cimport FX


cdef class Chorus(FX):
  cdef BASS_DX8_CHORUS effect
  cdef void* _get_effect(self) nogil except NULL: return <void*>&self.effect

  def __cinit__(Chorus self):


    self._type = _BASS_FX_DX8_CHORUS


    


      


    self.effect.fWetDryMix = 50.0
    self.effect.fDepth = 10.0
    self.effect.fFeedback = 25.0
    self.effect.fFrequency = 1.1
    self.effect.lWaveform = 1
    self.effect.fDelay = 16.0
    self.effect.lPhase = _BASS_DX8_PHASE_90

  property wet_dry_mix:
    def __get__(Chorus self):

      return self.effect.fWetDryMix

    def __set__(Chorus self, float value):

      self._validate_range(value, 0.0, 100.0)
      self.effect.fWetDryMix = value

  property depth:
    def __get__(Chorus self):

      return self.effect.fDepth

    def __set__(Chorus self, float value):

      self._validate_range(value, 0.0, 100.0)
      self.effect.fDepth = value

  property feedback:
    def __get__(Chorus self):

      return self.effect.fFeedback

    def __set__(Chorus self, float value):

      self._validate_range(value, -99.0, 99.0)
      self.effect.fFeedback = value

  property frequency:
    def __get__(Chorus self):

      return self.effect.fFrequency

    def __set__(Chorus self, float value):

      self._validate_range(value, 0.0, 10.0)
      self.effect.fFrequency = value

  property waveform:
    def __get__(Chorus self):

      return self.effect.lWaveform

    def __set__(Chorus self, DWORD value):

      self._validate_range(value, 0, 1)
      self.effect.lWaveform = value

  property delay:
    def __get__(Chorus self):

      return self.effect.fDelay

    def __set__(Chorus self, float value):

      self._validate_range(value, 0, 20)
      self.effect.fDelay = value

  property phase:
    def __get__(Chorus self):

      return self.effect.lPhase

    def __set__(Chorus self, DWORD value):

      self._validate_range(value, _BASS_DX8_PHASE_NEG_180, _BASS_DX8_PHASE_180)
      self.effect.lPhase = value
