cimport bass
from bassversion import BassVersion

cdef class BASS:
 property Version:
  def __get__(self):
   return BassVersion()