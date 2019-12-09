from .bass cimport (
                    DWORD
                   )
from .input_device cimport InputDevice

cdef class Input:
  cdef InputDevice __device
  cdef int __input
