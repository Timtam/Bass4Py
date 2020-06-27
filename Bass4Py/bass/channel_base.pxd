from ..bindings.bass cimport (
  BASS_CHANNELINFO,
  DWORD,
  HCHANNEL,
  QWORD)

from .attribute cimport Attribute
from ..exceptions import BassError

cdef class ChannelBase:
  cdef HCHANNEL _channel
  cdef object _flags_enum

  # attributes
  cdef readonly Attribute Frequency
  cdef readonly Attribute Pan
  cdef readonly Attribute SRC
  cdef readonly Attribute Volume
  cdef readonly Attribute Granularity

  cdef BASS_CHANNELINFO _getinfo(ChannelBase self)
  cdef void _initattributes(ChannelBase self)
  cdef void _sethandle(ChannelBase self, HCHANNEL handle)
  cpdef GetLevels(ChannelBase self, float length, DWORD flags)
  cpdef Lock(ChannelBase self)
  cpdef Pause(ChannelBase self)
  cpdef Stop(ChannelBase self)
  cpdef Unlock(ChannelBase self)
  cpdef GetPosition(ChannelBase self, DWORD mode=?)
  cpdef Bytes2Seconds(ChannelBase self, QWORD bytes)
  cpdef Seconds2Bytes(ChannelBase self, double secs)
  cpdef GetData(ChannelBase self, DWORD length)
  cpdef GetLength(ChannelBase self, DWORD mode = ?)
