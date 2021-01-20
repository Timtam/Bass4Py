from ..bindings.bass cimport DWORD, HCHANNEL
from .._evaluable cimport _Evaluable

cdef class Attribute(_Evaluable):
  cdef HCHANNEL _channel
  cdef DWORD _attrib
  cdef bint _readonly
  cdef bint _not_available

  cpdef _getmusicvolchan(Attribute self)
  cpdef _getbuffer(Attribute self)
  cpdef _getramping(Attribute self)
  cpdef _getscaninfo(Attribute self)
  cpdef _setmusicvolchan(Attribute self, tuple value)
  cpdef _setbuffer(Attribute self, float value)
  cpdef _setramping(Attribute self, bint value)
  cpdef _setscaninfo(Attribute self, bytes info)
  cpdef _slidemusicvolchan(Attribute self, tuple value, DWORD time)
  cpdef _slidebuffer(Attribute self, float value, DWORD time)
  cpdef Get(Attribute self)
  cpdef Set(Attribute self, object value)
  cpdef Slide(Attribute self, object value, DWORD time)