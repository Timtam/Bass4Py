from .bass cimport (
                    DWORD,
                    HFX
                   )
from .channel cimport Channel

ctypedef fused PARAMETER_TYPE:
  bint
  float
  DWORD
  int
  
cdef class FX:
  cdef readonly Channel Channel
  cdef HFX __fx
  cdef DWORD __type
  cdef int __priority
  cdef void *__effect

  cpdef Remove(FX self)
  cpdef Reset(FX self)
  cpdef Set(FX self, Channel chan, bint update = *)
  cpdef Update(FX self)
  cpdef __validate_range(FX self, PARAMETER_TYPE value, PARAMETER_TYPE lbound, PARAMETER_TYPE ubound)
