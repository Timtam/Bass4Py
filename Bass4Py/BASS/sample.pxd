from .bass cimport (
                    BASS_SAMPLE,
                    DWORD,
                    HCHANNEL,
                    HSAMPLE,
                    QWORD
                   )
from .output_device cimport OUTPUT_DEVICE

cdef class SAMPLE:
  cdef HSAMPLE __sample
  cdef OUTPUT_DEVICE __device

  cdef BASS_SAMPLE __getinfo(SAMPLE self)
  cpdef Free(SAMPLE self)
  cpdef GetChannel(SAMPLE self, bint onlynew)
  cpdef GetLength(SAMPLE self, DWORD mode = ?)
  cpdef Stop(SAMPLE self)
  cpdef Bytes2Seconds(SAMPLE self, QWORD bytes)
  cpdef Seconds2Bytes(SAMPLE self, double secs)
