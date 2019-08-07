from .bass cimport (
                    DWORD,
                    HCHANNEL,
                    HSYNC,
                    QWORD,
                    SYNCPROC
                   )

from .basschannel cimport BASSCHANNEL

cdef void CSYNCPROC(HSYNC handle, DWORD channel, DWORD data, void *user) with gil
cdef void __stdcall CSYNCPROC_STD(HSYNC handle, DWORD channel, DWORD data, void *user) with gil

cdef class BASSSYNC:
  cdef readonly BASSCHANNEL Channel
  cdef HSYNC __sync
  cdef bint __mixtime
  cdef DWORD __type
  cdef QWORD __param
  cdef bint __onetime
  cdef bint __forcemixtime
  cdef bint __forceparam
  cdef object __func
  cdef object __user
  cpdef Remove(BASSSYNC self)
  cpdef Set(BASSSYNC self, BASSCHANNEL chan)
  cpdef _call_callback(BASSSYNC self, DWORD data)
