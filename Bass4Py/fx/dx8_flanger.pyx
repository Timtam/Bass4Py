from ..bass cimport (
                     BASS_DX8_FLANGER,
                     _BASS_DX8_PHASE_NEG_180,
                     _BASS_DX8_PHASE_ZERO,
                     _BASS_DX8_PHASE_180,
                     _BASS_FX_DX8_FLANGER,
                     DWORD
                    )
from ..bassfx cimport BASSFX
from cpython.mem cimport PyMem_Malloc, PyMem_Free

cdef class BASSFX_DX8FLANGER(BASSFX):

  def __cinit__(BASSFX_DX8FLANGER self):
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

  def __dealloc__(BASSFX_DX8FLANGER self):
    if self.__effect != NULL:
      PyMem_Free(self.__effect)
      self.__effect = NULL

  property WetDryMix:
    def __get__(BASSFX_DX8FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fWetDryMix

    def __set__(BASSFX_DX8FLANGER self, float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0.0, 100.0)
      effect.fWetDryMix = value

  property Depth:
    def __get__(BASSFX_DX8FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fDepth

    def __set__(BASSFX_DX8FLANGER self,float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0.0, 100.0)
      effect.fDepth = value

  property Feedback:
    def __get__(BASSFX_DX8FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fFeedback

    def __set__(BASSFX_DX8FLANGER self, float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, -99.0, 99.0)
      effect.fFeedback = value

  property Frequency:
    def __get__(BASSFX_DX8FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fFrequency

    def __set__(BASSFX_DX8FLANGER self,float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0.0, 10.0)
      effect.fFrequency = value

  property Waveform:
    def __get__(BASSFX_DX8FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.lWaveform

    def __set__(BASSFX_DX8FLANGER self, DWORD value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0, 1)
      effect.lWaveform = value

  property Delay:
    def __get__(BASSFX_DX8FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.fDelay

    def __set__(BASSFX_DX8FLANGER self, float value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, 0.0, 4.0)
      effect.fDelay = value

  property Phase:
    def __get__(BASSFX_DX8FLANGER self):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      return effect.lPhase

    def __set__(BASSFX_DX8FLANGER self, DWORD value):
      cdef BASS_DX8_FLANGER *effect = <BASS_DX8_FLANGER*>(self.__effect)
      self.__validate_range(value, _BASS_DX8_PHASE_NEG_180, _BASS_DX8_PHASE_180)
      effect.lPhase = value
