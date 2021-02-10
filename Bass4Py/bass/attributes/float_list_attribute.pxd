from ...bindings.bass cimport DWORD
from .attribute_base cimport AttributeBase

cdef class FloatListAttribute(AttributeBase):
  cpdef get(self)
  cpdef set(self, list value)
  cpdef slide(self, list value, DWORD time)
