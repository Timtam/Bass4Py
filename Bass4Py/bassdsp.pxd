from .bass cimport (
                    HDSP,
                    DWORD
                   )

from .basschannel cimport BASSCHANNEL

cdef void CDSPPROC(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil
cdef void __stdcall CDSPPROC_STD(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil

cdef class BASSDSP:
  cdef HDSP __dsp
  cdef int __priority
  cdef object __func
  cdef readonly BASSCHANNEL Channel
  cpdef Remove(BASSDSP self)
  cpdef Set(BASSDSP self, BASSCHANNEL chan)
