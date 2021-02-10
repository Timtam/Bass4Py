from ...bindings.bass cimport DWORD
from ._attribute_base cimport _AttributeBase

cdef class FloatListAttribute(_AttributeBase):
  cpdef get(self)
  cpdef set(self, list value)
  cpdef slide(self, list value, DWORD time)
