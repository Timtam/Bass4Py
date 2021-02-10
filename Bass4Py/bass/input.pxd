from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  DWORD)

from .input_device cimport InputDevice

cdef class Input(Evaluable):
  cdef InputDevice _device
  cdef int _input
