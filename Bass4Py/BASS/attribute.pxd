from . cimport bass
from .bass cimport DWORD, HCHANNEL

cdef class ATTRIBUTE:
  cdef HCHANNEL __channel
  cdef DWORD __attrib
  cdef bint __readonly

  cpdef __getmusicvolchan(ATTRIBUTE self)
  cpdef __getbuffer(ATTRIBUTE self)
  cpdef __getramping(ATTRIBUTE self)
  cpdef __getscaninfo(ATTRIBUTE self)
  cpdef __setmusicvolchan(ATTRIBUTE self, list value)
  cpdef __setbuffer(ATTRIBUTE self, float value)
  cpdef __setramping(ATTRIBUTE self, bint value)
  cpdef __setscaninfo(ATTRIBUTE self, bytes info)
  cpdef __slidemusicvolchan(ATTRIBUTE self, list value, DWORD time)
  cpdef __slidebuffer(ATTRIBUTE self, float value, DWORD time)
  cpdef Get(ATTRIBUTE self)
  cpdef Set(ATTRIBUTE self, object value)
  cpdef Slide(ATTRIBUTE self, object value, DWORD time)