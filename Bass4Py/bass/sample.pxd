from .._evaluable cimport _Evaluable
from ..bindings.bass cimport (
  BASS_SAMPLE,
  DWORD,
  HCHANNEL,
  HSAMPLE,
  QWORD)

from .output_device cimport OutputDevice

cdef class Sample(_Evaluable):
  cdef HSAMPLE _sample
  cdef OutputDevice _device

  cdef BASS_SAMPLE _getinfo(Sample self)
  cpdef Free(Sample self)
  cpdef GetChannel(Sample self, bint onlynew)
  cpdef GetLength(Sample self, DWORD mode = ?)
  cpdef Stop(Sample self)
  cpdef Bytes2Seconds(Sample self, QWORD bytes)
  cpdef Seconds2Bytes(Sample self, double secs)
