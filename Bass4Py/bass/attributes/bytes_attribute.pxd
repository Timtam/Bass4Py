from ...bindings.bass cimport DWORD
from .attribute_base cimport AttributeBase

cdef class BytesAttribute(AttributeBase):
  cpdef get(self)
  cpdef set(self, bytes value)
