from . cimport bass
from .bass cimport DWORD, HCHANNEL

cdef class BASSCHANNELATTRIBUTE:
  cdef HCHANNEL __channel
  cdef DWORD __attrib
  cdef bint __readonly

  cpdef __getmusicvolchan(BASSCHANNELATTRIBUTE self)
  cpdef __getbuffer(BASSCHANNELATTRIBUTE self)
  cpdef __getramping(BASSCHANNELATTRIBUTE self)
  cpdef __getscaninfo(BASSCHANNELATTRIBUTE self)
  cpdef __setmusicvolchan(BASSCHANNELATTRIBUTE self, list value)
  cpdef __setbuffer(BASSCHANNELATTRIBUTE self, float value)
  cpdef __setramping(BASSCHANNELATTRIBUTE self, bint value)
  cpdef __setscaninfo(BASSCHANNELATTRIBUTE self, bytes info)
  cpdef __slidemusicvolchan(BASSCHANNELATTRIBUTE self, list value, DWORD time)
  cpdef __slidebuffer(BASSCHANNELATTRIBUTE self, float value, DWORD time)
  cpdef Get(BASSCHANNELATTRIBUTE self)
  cpdef Set(BASSCHANNELATTRIBUTE self, object value)
  cpdef Slide(BASSCHANNELATTRIBUTE self, object value, DWORD time)