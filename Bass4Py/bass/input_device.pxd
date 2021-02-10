from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  DWORD,
  BASS_DEVICEINFO,
  BASS_RECORDINFO)

cdef class InputDevice(Evaluable):
  cdef DWORD _device
  cdef readonly tuple inputs
  cdef BASS_DEVICEINFO _get_device_info(InputDevice self)
  cdef BASS_RECORDINFO _get_info(InputDevice self)
  cpdef free(InputDevice self)
  cpdef init(InputDevice self)
  cpdef record(InputDevice self, DWORD freq = ?, DWORD chans = ?, DWORD flags = ?, object callback = ?, DWORD period = ?)
  cpdef set(InputDevice self)
