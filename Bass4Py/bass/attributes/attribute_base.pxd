from ...bindings.bass cimport DWORD, HCHANNEL
from ...evaluable cimport Evaluable

cdef class AttributeBase(Evaluable):
  cdef HCHANNEL _channel
  cdef DWORD _attribute
  cdef bint _readonly
  cdef bint _not_available

  @staticmethod
  cdef void _clean(HCHANNEL channel)

  @staticmethod
  cdef AttributeBase _get(HCHANNEL channel, DWORD attribute)
