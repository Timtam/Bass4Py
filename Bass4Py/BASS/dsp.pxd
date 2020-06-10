from .bass cimport (
                    HDSP,
                    DWORD
                   )

from .channel cimport Channel

cdef void CDSPPROC(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil
cdef void __stdcall CDSPPROC_STD(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil

cdef class DSP:
  cdef HDSP _dsp
  cdef int _priority
  cdef object _func
  cdef readonly Channel Channel
  cpdef Remove(DSP self)
  cpdef Set(DSP self, Channel chan)
