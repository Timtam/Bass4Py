from .bass cimport (
                    DWORD,
                    HFX
                   )
from .channel cimport CHANNEL

ctypedef fused PARAMETER_TYPE:
  bint
  float
  DWORD
  int
  
cdef class FX:
  cdef readonly CHANNEL Channel
  cdef HFX __fx
  cdef DWORD __type
  cdef int __priority
  cdef void *__effect

  cpdef Remove(FX self)
  cpdef Reset(FX self)
  cpdef Set(FX self, CHANNEL chan, bint update = *)
  cpdef Update(FX self)
  cpdef __validate_range(FX self, PARAMETER_TYPE value, PARAMETER_TYPE lbound, PARAMETER_TYPE ubound)
