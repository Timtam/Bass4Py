from ....bindings.bass cimport (
  BASS_CHANNELINFO,
  BASS_DX8_PARAMEQ,
  _BASS_FX_DX8_PARAMEQ,
  BASS_FXGetParameters,
  BASS_FXSetParameters,
  DWORD)

from ...channel cimport Channel
from ...fx cimport FX

from cpython.mem cimport PyMem_Malloc

cdef class Parameq(FX):

  def __cinit__(Parameq self):
    cdef BASS_DX8_PARAMEQ *effect

    self._type = _BASS_FX_DX8_PARAMEQ

    effect = <BASS_DX8_PARAMEQ*>PyMem_Malloc(sizeof(BASS_DX8_PARAMEQ))
    
    if effect == NULL:
      raise MemoryError()
      
    self._effect = effect

    effect.fCenter = 0.0
    effect.fBandwidth = 12.0
    effect.fGain = 0.0

  cpdef set(Parameq self, Channel chan):
    cdef BASS_DX8_PARAMEQ *effect = <BASS_DX8_PARAMEQ*>(self._effect)
    cdef BASS_DX8_PARAMEQ temp

    self._set_fx(chan)

    if effect.fCenter == 0:
      BASS_FXGetParameters(self._fx, <void*>(&temp))
      effect.fCenter = temp.fCenter

    try:
      self.update()
    except Exception:
      self.remove()
      raise

  property center:
    def __get__(Parameq self):
      cdef BASS_DX8_PARAMEQ *effect = <BASS_DX8_PARAMEQ*>(self._effect)
      return effect.fCenter

    def __set__(Parameq self, float value):
      cdef BASS_DX8_PARAMEQ *effect = <BASS_DX8_PARAMEQ*>(self._effect)
      cdef BASS_CHANNELINFO info

      if self.channel == None:

        IF UNAME_SYSNAME == "Windows":
          self._validate_range(value, 80.0, 16000.0)
        ELSE:
          self._validate_range(value, 1.0, 20000.0)

      else:

        info = self.channel._get_info()

        IF UNAME_SYSNAME == "Windows":
          self._validate_range(value, 80.0, <float>(<int>(info.freq/3 - 1)))
        ELSE:
          self._validate_range(value, 1.0, <float>(info.freq/2 - 1))

      effect.fCenter = value

  property bandwidth:
    def __get__(Parameq self):
      cdef BASS_DX8_PARAMEQ *effect = <BASS_DX8_PARAMEQ*>(self._effect)
      return effect.fBandwidth

    def __set__(Parameq self, float value):
      cdef BASS_DX8_PARAMEQ *effect = <BASS_DX8_PARAMEQ*>(self._effect)
      self._validate_range(value, 1.0, 36.0)
      effect.fBandwidth = value

  property gain:
    def __get__(Parameq self):
      cdef BASS_DX8_PARAMEQ *effect = <BASS_DX8_PARAMEQ*>(self._effect)
      return effect.fGain

    def __set__(Parameq self, float value):
      cdef BASS_DX8_PARAMEQ *effect = <BASS_DX8_PARAMEQ*>(self._effect)
      self._validate_range(value, -15.0, 15.0)
      effect.fGain = value
