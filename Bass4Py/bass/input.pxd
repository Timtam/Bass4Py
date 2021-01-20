from .._evaluable cimport _Evaluable
from ..bindings.bass cimport (
  DWORD)

from .input_device cimport InputDevice

cdef class Input(_Evaluable):
  cdef InputDevice _device
  cdef int _input
