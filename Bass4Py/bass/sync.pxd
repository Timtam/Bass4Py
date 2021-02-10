from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  DWORD,
  HCHANNEL,
  HSYNC,
  QWORD,
  SYNCPROC)

from .channel cimport Channel

cdef void CSYNCPROC(HSYNC handle, DWORD channel, DWORD data, void *user) with gil
cdef void __stdcall CSYNCPROC_STD(HSYNC handle, DWORD channel, DWORD data, void *user) with gil

cdef class Sync(Evaluable):
  cdef readonly Channel channel
  cdef HSYNC _sync
  cdef DWORD _type
  cdef QWORD _param
  cdef bint _one_time
  cdef bint _force_param
  cdef bint _force_mix_time
  cdef object _func
  cdef object _user
  cpdef remove(Sync self)
  cpdef set(Sync self, Channel chan)
  cpdef set_mix_time(Sync self, bint enable, bint threaded = ?)
  cpdef _call_callback(Sync self, DWORD data)
  cdef void _set_mix_time(Sync self, bint enable, bint threaded = ?)
