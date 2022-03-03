from ..bindings.bass cimport (
  BASS_CHANNELINFO,
  DWORD,
  HCHANNEL,
  QWORD,
  WORD)

from .attributes.float_attribute cimport FloatAttribute
from ..evaluable cimport Evaluable

cdef class ChannelBase(Evaluable):
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
  cpdef get_position(ChannelBase self, DWORD mode=?, bint decode=?)
  cpdef bytes_to_seconds(ChannelBase self, QWORD bytes)
  cpdef seconds_to_bytes(ChannelBase self, double secs)
  cpdef get_data(ChannelBase self, DWORD length, DWORD format =?)
  cpdef get_length(ChannelBase self, DWORD mode = ?)
  cpdef free(self)
