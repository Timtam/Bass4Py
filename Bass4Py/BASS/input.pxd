from .bass cimport (
                    DWORD
                   )
from .input_device cimport INPUT_DEVICE

cdef class INPUT:
  cdef INPUT_DEVICE __device
  cdef int __input
