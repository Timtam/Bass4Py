from ....bindings.bass cimport (
  BASS_DX8_ECHO,
  _BASS_FX_DX8_ECHO)

from ...fx cimport FX


cdef class Echo(FX):
  cdef BASS_DX8_ECHO effect
  cdef void* _get_effect(self) nogil except NULL: return <void*>&self.effect

  def __cinit__(Echo self):


    self._type = _BASS_FX_DX8_ECHO




    self.effect.fWetDryMix = 50.0
    self.effect.fFeedback = 50.0
    self.effect.fLeftDelay = 500.0
    self.effect.fRightDelay = 500.0
    self.effect.lPanDelay = False

  property wet_dry_mix:
    def __get__(Echo self):

      return self.effect.fWetDryMix

    def __set__(Echo self, float value):

      self._validate_range(value, 0.0, 100.0)
      self.effect.fWetDryMix = value

  property feedback:
    def __get__(Echo self):

      return self.effect.fFeedback

    def __set__(Echo self, float value):

      self._validate_range(value, 0.0, 100.0)
      self.effect.fFeedback = value

  property left_delay:
    def __get__(Echo self):

      return self.effect.fLeftDelay

    def __set__(Echo self,float value):

      self._validate_range(value, 1.0, 2000.0)
      self.effect.fLeftDelay = value

  property right_delay:
    def __get__(Echo self):

      return self.effect.fRightDelay

    def __set__(Echo self, float value):

      self._validate_range(value, 1.0, 2000.0)
      self.effect.fRightDelay = value

  property pan_delay:
    def __get__(Echo self):

      return self.effect.lPanDelay

    def __set__(Echo self, bint value):

      self._validate_range(value, False, True)
      self.effect.lPanDelay = value
