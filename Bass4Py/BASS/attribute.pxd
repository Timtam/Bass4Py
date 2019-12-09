from .bass cimport DWORD, HCHANNEL

cdef class Attribute:
  cdef HCHANNEL __channel
  cdef DWORD __attrib
  cdef bint __readonly
  cdef bint __not_available

  cpdef __getmusicvolchan(Attribute self)
  cpdef __getbuffer(Attribute self)
  cpdef __getramping(Attribute self)
  cpdef __getscaninfo(Attribute self)
  cpdef __setmusicvolchan(Attribute self, tuple value)
  cpdef __setbuffer(Attribute self, float value)
  cpdef __setramping(Attribute self, bint value)
  cpdef __setscaninfo(Attribute self, bytes info)
  cpdef __slidemusicvolchan(Attribute self, tuple value, DWORD time)
  cpdef __slidebuffer(Attribute self, float value, DWORD time)
  cpdef Get(Attribute self)
  cpdef Set(Attribute self, object value)
  cpdef Slide(Attribute self, object value, DWORD time)