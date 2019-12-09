from ..bass cimport (
                     BASS_FX_VOLUME_PARAM,
                     _BASS_FX_VOLUME,
                     DWORD
                    )
from ..fx cimport FX
from ...exceptions import BassOutOfRangeError
from cpython.mem cimport PyMem_Malloc

cdef class Volume(FX):

  def __cinit__(Volume self):
    cdef BASS_FX_VOLUME_PARAM *effect

    self.__type = _BASS_FX_VOLUME

    effect = <BASS_FX_VOLUME_PARAM*>PyMem_Malloc(sizeof(BASS_FX_VOLUME_PARAM))
    
    if effect == NULL:
      raise MemoryError()
      
    self.__effect = effect

    effect.fTarget = 1.0
    effect.fCurrent = 1.0
    effect.fTime = 0.0
    effect.lCurve = 0

  property Target:
    def __get__(Volume self):
      cdef BASS_FX_VOLUME_PARAM *effect = <BASS_FX_VOLUME_PARAM*>(self.__effect)
      return effect.fTarget

    def __set__(Volume self, float value):
      cdef BASS_FX_VOLUME_PARAM *effect = <BASS_FX_VOLUME_PARAM*>(self.__effect)

      if value < 0.0:
        raise BassOutOfRangeError("FX parameter value {0} may not be less than 0".format(value))

      effect.fTarget = value

  property Current:
    def __get__(Volume self):
      cdef BASS_FX_VOLUME_PARAM *effect = <BASS_FX_VOLUME_PARAM*>(self.__effect)
      return effect.fCurrent

    def __set__(Volume self, float value):
      cdef BASS_FX_VOLUME_PARAM *effect = <BASS_FX_VOLUME_PARAM*>(self.__effect)

      if value < -1.0:
        raise BassOutOfRangeError("FX parameter value {0} may not be less than -1".format(value))

      effect.fCurrent = value

  property Time:
    def __get__(Volume self):
      cdef BASS_FX_VOLUME_PARAM *effect = <BASS_FX_VOLUME_PARAM*>(self.__effect)
      return effect.fTime

    def __set__(Volume self, float value):
      cdef BASS_FX_VOLUME_PARAM *effect = <BASS_FX_VOLUME_PARAM*>(self.__effect)

      if value < 0.0:
        raise BassOutOfRangeError("FX parameter value {0} may not be less than 0".format(value))

      effect.fTime = value

  property Curve:
    def __get__(Volume self):
      cdef BASS_FX_VOLUME_PARAM *effect = <BASS_FX_VOLUME_PARAM*>(self.__effect)
      return effect.lCurve

    def __set__(Volume self, DWORD value):
      cdef BASS_FX_VOLUME_PARAM *effect = <BASS_FX_VOLUME_PARAM*>(self.__effect)

      self._validate_range(value, 0.0, 1.0)

      effect.lCurve = value
