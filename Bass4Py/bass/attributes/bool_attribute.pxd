from ...bindings.bass cimport DWORD
from .attribute_base cimport AttributeBase

cdef class BoolAttribute(AttributeBase):
  cpdef get(self)
  cpdef set(self, bint value)
  cpdef slide(self, bint value, DWORD time)
