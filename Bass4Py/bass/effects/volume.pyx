from ...bindings.bass cimport (
  BASS_FX_VOLUME_PARAM,
  _BASS_FX_VOLUME,
  DWORD)

from ..fx cimport FX
from ...exceptions import BassOutOfRangeError
from cpython.mem cimport PyMem_Malloc

cdef class Volume(FX):
  cdef BASS_FX_VOLUME_PARAM effect
  cdef void* _get_effect(self) nogil except NULL: return <void*>&self.effect


  def __cinit__(Volume self):

    self._type = _BASS_FX_VOLUME



    self.effect.fTarget = 1.0
    self.effect.fCurrent = 1.0
    self.effect.fTime = 0.0
    self.effect.lCurve = 0

  property target:
    def __get__(Volume self):

      return self.effect.fTarget

    def __set__(Volume self, float value):


      if value < 0.0:
        raise BassOutOfRangeError("FX parameter value {0} may not be less than 0".format(value))

      self.effect.fTarget = value

  property current:
    def __get__(Volume self):

      return self.effect.fCurrent

    def __set__(Volume self, float value):


      if value < -1.0:
        raise BassOutOfRangeError("FX parameter value {0} may not be less than -1".format(value))

      self.effect.fCurrent = value

  property time:
    def __get__(Volume self):

      return self.effect.fTime

    def __set__(Volume self, float value):


      if value < 0.0:
        raise BassOutOfRangeError("FX parameter value {0} may not be less than 0".format(value))

      self.effect.fTime = value

  property curve:
    def __get__(Volume self):

      return self.effect.lCurve

    def __set__(Volume self, DWORD value):


      self._validate_range(value, 0.0, 1.0)

      self.effect.lCurve = value
