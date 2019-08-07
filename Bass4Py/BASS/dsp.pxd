from .bass cimport (
                    HDSP,
                    DWORD
                   )

from .channel cimport CHANNEL

cdef void CDSPPROC(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil
cdef void __stdcall CDSPPROC_STD(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil

cdef class DSP:
  cdef HDSP __dsp
  cdef int __priority
  cdef object __func
  cdef readonly CHANNEL Channel
  cpdef Remove(DSP self)
  cpdef Set(DSP self, CHANNEL chan)
