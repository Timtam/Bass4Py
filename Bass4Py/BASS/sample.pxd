from .bass cimport (
                    BASS_SAMPLE,
                    DWORD,
                    HCHANNEL,
                    HSAMPLE,
                    QWORD
                   )

cdef class SAMPLE:
  cdef HSAMPLE __sample

  cdef BASS_SAMPLE __getinfo(SAMPLE self)
  cpdef Free(SAMPLE self)
  cpdef GetChannel(SAMPLE self, bint onlynew)
  cpdef Stop(SAMPLE self)