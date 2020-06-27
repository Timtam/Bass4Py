from ..bindings.bass cimport (
  DWORD,
  HRECORD,
  QWORD)

from .channel_base cimport ChannelBase
from .input_device cimport InputDevice

cdef class Record(ChannelBase):
  cdef object _func
  cdef InputDevice _device

  cpdef Start(Record self)
