from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  DWORD,
  HFX)

from .channel cimport Channel

ctypedef fused PARAMETER_TYPE:
  bint
  float
  DWORD
  int
  
cdef class FX(Evaluable):
  cdef readonly Channel channel
  cdef HFX _fx
  cdef DWORD _type
  cdef int _priority


  cdef void* _get_effect(self) nogil except NULL

  cpdef remove(FX self)
  cpdef reset(FX self)
  cpdef set(FX self, Channel chan)
  cpdef update(FX self)
  cpdef _validate_range(FX self, PARAMETER_TYPE value, PARAMETER_TYPE lbound, PARAMETER_TYPE ubound)
  cdef void _set_fx(FX self, Channel channel)
