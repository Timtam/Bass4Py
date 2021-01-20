from .._evaluable cimport _Evaluable
from ..bindings.bass cimport (
  DWORD,
  BASS_DEVICEINFO,
  BASS_RECORDINFO)

cdef class InputDevice(_Evaluable):
  cdef DWORD _device
  cdef readonly tuple Inputs
  cdef BASS_DEVICEINFO _getdeviceinfo(InputDevice self)
  cdef BASS_RECORDINFO _getinfo(InputDevice self)
  cpdef Free(InputDevice self)
  cpdef Init(InputDevice self)
  cpdef Record(InputDevice self, DWORD freq = ?, DWORD chans = ?, DWORD flags = ?, object callback = ?, DWORD period = ?)
  cpdef Set(InputDevice self)
