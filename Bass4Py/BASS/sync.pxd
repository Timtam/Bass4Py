from .bass cimport (
                    DWORD,
                    HCHANNEL,
                    HSYNC,
                    QWORD,
                    SYNCPROC
                   )

from .channel cimport Channel

cdef void CSYNCPROC(HSYNC handle, DWORD channel, DWORD data, void *user) with gil
cdef void __stdcall CSYNCPROC_STD(HSYNC handle, DWORD channel, DWORD data, void *user) with gil

cdef class Sync:
  cdef readonly Channel Channel
  cdef HSYNC __sync
  cdef DWORD __type
  cdef QWORD __param
  cdef bint __onetime
  cdef bint __forceparam
  cdef bint __forcemixtime
  cdef object __func
  cdef object __user
  cpdef Remove(Sync self)
  cpdef Set(Sync self, Channel chan)
  cpdef SetMixtime(Sync self, bint enable, bint threaded = ?)
  cpdef _call_callback(Sync self, DWORD data)
  cdef void _set_mixtime(Sync self, bint enable, bint threaded = ?)
