from ..bass cimport (
                     BASS_DX8_FLANGER,
                     _BASS_DX8_PHASE_NEG_180,
                     _BASS_DX8_PHASE_ZERO,
                     _BASS_DX8_PHASE_180,
                     _BASS_FX_DX8_FLANGER,
                     DWORD
                    )
from ..fx cimport FX
from cpython.mem cimport PyMem_Malloc

cdef class FX_DX8_FLANGER(FX):

  def __cinit__(FX_DX8_FLANGER self):
    cdef BASS_DX8_FLANGER *effect

    self.__type = _BASS_FX_DX8_FLANGER

    effect = <BASS_DX8_FLANGER*>PyMem_Malloc(sizeof(BASS_DX8_FLANGER))
    
    if effect == NULL:
      raise MemoryError()
      
    self.__effect = effect

    effect.fWetDryMix = 50.0
    effect.fDepth = 100.0
    effect.fFeedback = -50.0
    effect.fFrequency = 0.25
    effect.lWaveform = 1
    effect.fDelay = 2.0
    effect.lPhase = _BASS_DX8_PHASE_ZERO

  property WetDryMix:
    def __get__(FX_DX8_FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fWetDryMix

    def __set__(FX_DX8_FLANGER self, float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0.0, 100.0)
      effect.fWetDryMix = value

  property Depth:
    def __get__(FX_DX8_FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fDepth

    def __set__(FX_DX8_FLANGER self,float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0.0, 100.0)
      effect.fDepth = value

  property Feedback:
    def __get__(FX_DX8_FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fFeedback

    def __set__(FX_DX8_FLANGER self, float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, -99.0, 99.0)
      effect.fFeedback = value

  property Frequency:
    def __get__(FX_DX8_FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fFrequency

    def __set__(FX_DX8_FLANGER self,float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0.0, 10.0)
      effect.fFrequency = value

  property Waveform:
    def __get__(FX_DX8_FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.lWaveform

    def __set__(FX_DX8_FLANGER self, DWORD value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0, 1)
      effect.lWaveform = value

  property Delay:
    def __get__(FX_DX8_FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fDelay

    def __set__(FX_DX8_FLANGER self, float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0.0, 4.0)
      effect.fDelay = value

  property Phase:
    def __get__(FX_DX8_FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.lPhase

    def __set__(FX_DX8_FLANGER self, DWORD value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, _BASS_DX8_PHASE_NEG_180, _BASS_DX8_PHASE_180)
      effect.lPhase = value
