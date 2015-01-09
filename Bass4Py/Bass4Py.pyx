cimport bass
from bassversion import BASSVERSION

cdef class BASS:
 property Version:
  def __get__(self):
   return BASSVERSION(bass.BASS_GetVersion())