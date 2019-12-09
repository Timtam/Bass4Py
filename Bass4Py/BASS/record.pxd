from .bass cimport (
                    DWORD,
                    HRECORD,
                    QWORD
                   )
from .channel_base cimport ChannelBase
from .input_device cimport InputDevice

cdef class Record(ChannelBase):
  cdef object __func
  cdef InputDevice __device

  cpdef Start(Record self)
