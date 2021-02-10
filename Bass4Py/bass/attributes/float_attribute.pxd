from ...bindings.bass cimport DWORD
from ._attribute_base cimport _AttributeBase

cdef class FloatAttribute(_AttributeBase):
  cpdef get(self)
  cpdef set(self, float value)
  cpdef slide(self, float value, DWORD time)
