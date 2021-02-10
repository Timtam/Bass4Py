from ...bindings.bass cimport DWORD
from .attribute_base cimport AttributeBase

cdef class FloatAttribute(AttributeBase):
  cpdef get(self)
  cpdef set(self, float value)
  cpdef slide(self, float value, DWORD time)
