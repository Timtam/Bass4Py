from .bass cimport (
                    DWORD,
                    HFX
                   )
from .basschannel cimport BASSCHANNEL

ctypedef fused PARAMETER_TYPE:
  bint
  float
  DWORD
  int
  
cdef class BASSFX:
  cdef readonly BASSCHANNEL Channel
  cdef HFX __fx
  cdef DWORD __type
  cdef int __priority
  cdef void *__effect

  cpdef Remove(BASSFX self)
  cpdef Reset(BASSFX self)
  cpdef Set(BASSFX self, BASSCHANNEL chan, bint update = *)
  cpdef Update(BASSFX self)
  cpdef __validate_range(BASSFX self, PARAMETER_TYPE value, PARAMETER_TYPE lbound, PARAMETER_TYPE ubound)
