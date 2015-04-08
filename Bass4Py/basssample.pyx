cimport bass
from bassexceptions import BassError
cdef class BASSSAMPLE:
 def __cinit__(BASSSAMPLE self,bass.HSAMPLE sample):
  self.__sample=sample
 cpdef __Evaluate(BASSSAMPLE self):
  cdef bass.DWORD error=bass.BASS_ErrorGetCode()
  if error!=bass.BASS_OK: raise BassError(error)