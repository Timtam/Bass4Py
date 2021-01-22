from ..bindings.bass cimport DWORD, HCHANNEL
from .._evaluable cimport _Evaluable

cdef class Attribute(_Evaluable):
  cdef HCHANNEL _channel
  cdef DWORD _attrib
  cdef bint _readonly
  cdef bint _not_available

  cpdef _get_music_channel_volumes(Attribute self)
  cpdef _get_buffer(Attribute self)
  cpdef _get_ramping(Attribute self)
  cpdef _get_scan_info(Attribute self)
  cpdef _set_music_channel_volumes(Attribute self, tuple value)
  cpdef _set_buffer(Attribute self, float value)
  cpdef _set_ramping(Attribute self, bint value)
  cpdef _set_scan_info(Attribute self, bytes info)
  cpdef _slide_music_channel_volumes(Attribute self, tuple value, DWORD time)
  cpdef _slide_buffer(Attribute self, float value, DWORD time)
  cpdef get(Attribute self)
  cpdef set(Attribute self, object value)
  cpdef slide(Attribute self, object value, DWORD time)
