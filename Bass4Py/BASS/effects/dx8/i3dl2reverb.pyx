from ...bass cimport (
                      BASS_DX8_I3DL2REVERB,
                      _BASS_FX_DX8_I3DL2REVERB,
                      DWORD
                     )
from ...fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class I3DL2Reverb(FX):

  def __cinit__(I3DL2Reverb self):
    cdef BASS_DX8_I3DL2REVERB *effect

    self._type = _BASS_FX_DX8_I3DL2REVERB

    effect = <BASS_DX8_I3DL2REVERB*>PyMem_Malloc(sizeof(BASS_DX8_I3DL2REVERB))
    
    if effect == NULL:
      raise MemoryError()
      
    self._effect = effect

    effect.lRoom = -1000
    effect.lRoomHF = -100
    effect.flRoomRolloffFactor = 0.0
    effect.flDecayTime = 1.49
    effect.flDecayHFRatio = 0.83
    effect.lReflections = -2602
    effect.flReflectionsDelay = 0.007
    effect.lReverb = 200
    effect.flReverbDelay = 0.011
    effect.flDiffusion = 100.0
    effect.flDensity = 100.0
    effect.flHFReference = 5000.0

  property Room:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.lRoom

    def __set__(I3DL2Reverb self, int value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, -10000, 0)
      effect.lRoom = value

  property RoomHF:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.lRoomHF

    def __set__(I3DL2Reverb self, int value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, -10000, 0)
      effect.lRoomHF = value

  property RoomRolloffFactor:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.flRoomRolloffFactor

    def __set__(I3DL2Reverb self, float value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, 0.0, 10.0)
      effect.flRoomRolloffFactor = value

  property DecayTime:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.flDecayTime

    def __set__(I3DL2Reverb self, float value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, 0.1, 20.0)
      effect.flDecayTime = value

  property DecayHFRatio:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.flDecayHFRatio

    def __set__(I3DL2Reverb self, float value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, 0.1, 2.0)
      effect.flDecayHFRatio = value

  property Reflections:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.lReflections

    def __set__(I3DL2Reverb self, int value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, -10000, 1000)
      effect.lReflections = value

  property ReflectionsDelay:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.flReflectionsDelay

    def __set__(I3DL2Reverb self, float value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, 0.0, 0.3)
      effect.flReflectionsDelay = value

  property Reverb:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.lReverb

    def __set__(I3DL2Reverb self, int value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, -10000, 2000)
      effect.lReverb = value

  property ReverbDelay:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.flReverbDelay

    def __set__(I3DL2Reverb self, float value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, 0.0, 0.1)
      effect.flReverbDelay = value

  property Diffusion:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.flDiffusion

    def __set__(I3DL2Reverb self, float value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, 0.0, 100.0)
      effect.flDiffusion = value

  property Density:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.flDensity

    def __set__(I3DL2Reverb self, float value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, 0.0, 100.0)
      effect.flDensity = value

  property HFReference:
    def __get__(I3DL2Reverb self):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      return effect.flHFReference

    def __set__(I3DL2Reverb self, float value):
      cdef BASS_DX8_I3DL2REVERB *effect = <BASS_DX8_I3DL2REVERB*>(self._effect)
      self._validate_range(value, 20.0, 20000.0)
      effect.flHFReference = value
