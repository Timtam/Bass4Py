from .bass cimport (
                    BASS_SAMPLE,
                    DWORD,
                    HCHANNEL,
                    HSAMPLE,
                    QWORD
                   )
from .output_device cimport OutputDevice

cdef class Sample:
  cdef HSAMPLE __sample
  cdef OutputDevice __device

  cdef BASS_SAMPLE __getinfo(Sample self)
  cpdef Free(Sample self)
  cpdef GetChannel(Sample self, bint onlynew)
  cpdef GetLength(Sample self, DWORD mode = ?)
  cpdef Stop(Sample self)
  cpdef Bytes2Seconds(Sample self, QWORD bytes)
  cpdef Seconds2Bytes(Sample self, double secs)
