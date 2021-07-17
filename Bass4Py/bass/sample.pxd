from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  BASS_SAMPLE,
  DWORD,
  HCHANNEL,
  HSAMPLE,
  QWORD)

from .output_device cimport OutputDevice

cdef class Sample(Evaluable):
  cdef HSAMPLE _sample
  cdef OutputDevice _device

  cdef BASS_SAMPLE _get_info(Sample self)
  cpdef free(Sample self)
  cpdef get_channel(Sample self, bint new = ?, bint loop = ?, DWORD override = ?, DWORD speakers = ?)
  cpdef get_length(Sample self, DWORD mode = ?)
  cpdef get_stream(Sample self, bint new = ?, bint loop = ?, DWORD override = ?, bint autofree = ?, bint decode = ?, DWORD speakers = ?)
  cpdef stop(Sample self)
  cpdef bytes_to_seconds(Sample self, QWORD bytes)
  cpdef seconds_to_bytes(Sample self, double secs)
