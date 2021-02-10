from ...bindings.bass cimport DWORD, HCHANNEL
from ..._evaluable cimport _Evaluable

cdef class _AttributeBase(_Evaluable):
  cdef HCHANNEL _channel
  cdef DWORD _attribute
  cdef bint _readonly
  cdef bint _not_available
