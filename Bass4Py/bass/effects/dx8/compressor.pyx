from ....bindings.bass cimport (
  BASS_DX8_COMPRESSOR,
  _BASS_FX_DX8_COMPRESSOR)

from ...fx cimport FX


cdef class Compressor(FX):
  cdef BASS_DX8_COMPRESSOR effect
  cdef void* _get_effect(self) nogil except NULL: return <void*>&self.effect



  def __cinit__(Compressor self):


    self._type = _BASS_FX_DX8_COMPRESSOR


    


      


    self.effect.fGain = 0.0
    self.effect.fAttack = 10.0
    self.effect.fRelease = 200.0
    self.effect.fThreshold = -20.0
    self.effect.fRatio = 3.0
    self.effect.fPredelay = 4.0

  property gain:
    def __get__(Compressor self):

      return self.effect.fGain

    def __set__(Compressor self, float value):

      self._validate_range(value, -60.0, 60.0)
      self.effect.fGain = value

  property attack:
    def __get__(Compressor self):

      return self.effect.fAttack

    def __set__(Compressor self, float value):

      self._validate_range(value, 0.01, 500.0)
      self.effect.fAttack = value

  property release:
    def __get__(Compressor self):
      return self.effect.fRelease

    def __set__(Compressor self, float value):

      self._validate_range(value, 50.0, 3000.0)
      self.effect.fRelease = value

  property threshold:
    def __get__(Compressor self):

      return self.effect.fThreshold

    def __set__(Compressor self, float value):

      self._validate_range(value, -60.0, 0.0)
      self.effect.fThreshold = value

  property ratio:
    def __get__(Compressor self):

      return self.effect.fRatio

    def __set__(Compressor self, float value):

      self._validate_range(value, 1.0, 100.0)
      self.effect.fRatio = value

  property predelay:
    def __get__(Compressor self):

      return self.effect.fPredelay

    def __set__(Compressor self, float value):

      self._validate_range(value, 0.0, 4.0)
      self.effect.fPredelay = value
