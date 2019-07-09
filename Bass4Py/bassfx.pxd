from .bass cimport (
                    DWORD,
                    HCHANNEL,
                    HFX
                   )
from .basschannel cimport BASSCHANNEL

ctypedef fused FUSED_CHANNEL:
  HCHANNEL
  BASSCHANNEL

ctypedef fused PARAMETER_TYPE:
  bint
  float
  DWORD
  int
  
cdef class BASSFX:
  cdef DWORD __channel
  cdef HFX __fx
  cdef DWORD __type
  cdef int __priority
  cdef void *__effect

  cpdef Remove(BASSFX self)
  cpdef Reset(BASSFX self)
  cpdef Set(BASSFX self, FUSED_CHANNEL chan, bint update = *)
  cpdef Update(BASSFX self)
  cpdef __validate_range(BASSFX self, PARAMETER_TYPE value, PARAMETER_TYPE lbound, PARAMETER_TYPE ubound)
