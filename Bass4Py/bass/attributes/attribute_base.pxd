from ...bindings.bass cimport DWORD, HCHANNEL
from ...evaluable cimport Evaluable

cdef class AttributeBase(Evaluable):
  cdef HCHANNEL _channel
  cdef DWORD _attribute
  cdef bint _readonly
  cdef bint _not_available
