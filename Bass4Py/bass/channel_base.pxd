from ..bindings.bass cimport (
  BASS_CHANNELINFO,
  DWORD,
  HCHANNEL,
  QWORD)

from .attributes.float_attribute cimport FloatAttribute
from .._evaluable cimport _Evaluable
from ..exceptions import BassError

cdef class ChannelBase(_Evaluable):
  cdef HCHANNEL _channel
  cdef object _flags_enum

  # attributes
  cdef readonly FloatAttribute frequency
  cdef readonly FloatAttribute pan
  cdef readonly FloatAttribute src
  cdef readonly FloatAttribute volume
  cdef readonly FloatAttribute granularity

  cdef BASS_CHANNELINFO _get_info(ChannelBase self)
  cdef void _init_attributes(ChannelBase self)
  cdef void _set_handle(ChannelBase self, HCHANNEL handle)
  cpdef get_levels(ChannelBase self, float length, DWORD flags)
  cpdef lock(ChannelBase self)
  cpdef pause(ChannelBase self)
  cpdef stop(ChannelBase self)
  cpdef unlock(ChannelBase self)
  cpdef get_position(ChannelBase self, DWORD mode=?)
  cpdef bytes_to_seconds(ChannelBase self, QWORD bytes)
  cpdef seconds_to_bytes(ChannelBase self, double secs)
  cpdef get_data(ChannelBase self, DWORD length)
  cpdef get_length(ChannelBase self, DWORD mode = ?)
