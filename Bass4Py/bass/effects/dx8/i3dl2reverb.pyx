from ....bindings.bass cimport (
  BASS_DX8_I3DL2REVERB,
  _BASS_FX_DX8_I3DL2REVERB,
  DWORD)

from ...fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class I3DL2Reverb(FX):
  cdef BASS_DX8_I3DL2REVERB effect
  cdef void* _get_effect(self) nogil except NULL: return <void*>&self.effect





  def __cinit__(I3DL2Reverb self):


    self._type = _BASS_FX_DX8_I3DL2REVERB


    


      


    self.effect.lRoom = -1000
    self.effect.lRoomHF = -100
    self.effect.flRoomRolloffFactor = 0.0
    self.effect.flDecayTime = 1.49
    self.effect.flDecayHFRatio = 0.83
    self.effect.lReflections = -2602
    self.effect.flReflectionsDelay = 0.007
    self.effect.lReverb = 200
    self.effect.flReverbDelay = 0.011
    self.effect.flDiffusion = 100.0
    self.effect.flDensity = 100.0
    self.effect.flHFReference = 5000.0

  property room:
    def __get__(I3DL2Reverb self):

      return self.effect.lRoom

    def __set__(I3DL2Reverb self, int value):

      self._validate_range(value, -10000, 0)
      self.effect.lRoom = value

  property room_hf:
    def __get__(I3DL2Reverb self):

      return self.effect.lRoomHF

    def __set__(I3DL2Reverb self, int value):

      self._validate_range(value, -10000, 0)
      self.effect.lRoomHF = value

  property room_rolloff_factor:
    def __get__(I3DL2Reverb self):

      return self.effect.flRoomRolloffFactor

    def __set__(I3DL2Reverb self, float value):

      self._validate_range(value, 0.0, 10.0)
      self.effect.flRoomRolloffFactor = value

  property decay_time:
    def __get__(I3DL2Reverb self):

      return self.effect.flDecayTime

    def __set__(I3DL2Reverb self, float value):

      self._validate_range(value, 0.1, 20.0)
      self.effect.flDecayTime = value

  property decay_hf_ratio:
    def __get__(I3DL2Reverb self):

      return self.effect.flDecayHFRatio

    def __set__(I3DL2Reverb self, float value):

      self._validate_range(value, 0.1, 2.0)
      self.effect.flDecayHFRatio = value

  property reflections:
    def __get__(I3DL2Reverb self):

      return self.effect.lReflections

    def __set__(I3DL2Reverb self, int value):

      self._validate_range(value, -10000, 1000)
      self.effect.lReflections = value

  property reeflections_delay:
    def __get__(I3DL2Reverb self):

      return self.effect.flReflectionsDelay

    def __set__(I3DL2Reverb self, float value):

      self._validate_range(value, 0.0, 0.3)
      self.effect.flReflectionsDelay = value

  property reverb:
    def __get__(I3DL2Reverb self):

      return self.effect.lReverb

    def __set__(I3DL2Reverb self, int value):

      self._validate_range(value, -10000, 2000)
      self.effect.lReverb = value

  property reverb_delay:
    def __get__(I3DL2Reverb self):

      return self.effect.flReverbDelay

    def __set__(I3DL2Reverb self, float value):

      self._validate_range(value, 0.0, 0.1)
      self.effect.flReverbDelay = value

  property diffusion:
    def __get__(I3DL2Reverb self):

      return self.effect.flDiffusion

    def __set__(I3DL2Reverb self, float value):

      self._validate_range(value, 0.0, 100.0)
      self.effect.flDiffusion = value

  property density:
    def __get__(I3DL2Reverb self):

      return self.effect.flDensity

    def __set__(I3DL2Reverb self, float value):

      self._validate_range(value, 0.0, 100.0)
      self.effect.flDensity = value

  property hf_reference:
    def __get__(I3DL2Reverb self):

      return self.effect.flHFReference

    def __set__(I3DL2Reverb self, float value):

      self._validate_range(value, 20.0, 20000.0)
      self.effect.flHFReference = value
