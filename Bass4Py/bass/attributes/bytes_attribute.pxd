from ...bindings.bass cimport DWORD
from ._attribute_base cimport _AttributeBase

cdef class BytesAttribute(_AttributeBase):
  cpdef get(self)
  cpdef set(self, bytes value)
