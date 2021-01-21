from .._evaluable cimport _Evaluable
from ..bindings.bass cimport (
  HDSP,
  DWORD)

from .channel cimport Channel

cdef void CDSPPROC(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil
cdef void __stdcall CDSPPROC_STD(HDSP dsp, DWORD channel, void *buffer, DWORD length, void *user) with gil

cdef class DSP(_Evaluable):
  cdef HDSP _dsp
  cdef int _priority
  cdef object _func
  cdef readonly Channel channel
  cpdef remove(DSP self)
  cpdef set(DSP self, Channel chan)
