from .bass cimport (
                    DWORD,
                    HRECORD,
                    QWORD
                   )
from .channel_base cimport CHANNEL_BASE
from .input_device cimport INPUT_DEVICE

cdef class RECORD(CHANNEL_BASE):
  cdef object __func
  cdef INPUT_DEVICE __device

  cpdef Start(RECORD self)
