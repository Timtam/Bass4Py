from ..bindings.bass cimport (
  DWORD)

from .input_device cimport InputDevice

cdef class Input:
  cdef InputDevice _device
  cdef int _input
