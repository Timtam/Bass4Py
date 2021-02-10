from ...bindings.bass cimport DWORD
from ._attribute_base cimport _AttributeBase

cdef class BoolAttribute(_AttributeBase):
  cpdef get(self)
  cpdef set(self, bint value)
  cpdef slide(self, bint value, DWORD time)
