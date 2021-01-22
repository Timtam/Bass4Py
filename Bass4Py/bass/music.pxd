from ..bindings.bass cimport (
  DWORD,
  HCHANNEL,
  HMUSIC,
  QWORD)

from .channel cimport Channel
from .attribute cimport Attribute

cdef class Music(Channel):

  # attributes
  cdef readonly Attribute active_channels
  cdef readonly Attribute amplification
  cdef readonly Attribute bpm
  cdef readonly Attribute channel_volumes
  cdef readonly Attribute global_volume
  cdef readonly Attribute instrument_volumes
  cdef readonly Attribute pan_separation
  cdef readonly Attribute position_scaler
  cdef readonly Attribute speed

  cdef readonly object tags

  cpdef free(Music self)
  cpdef update(Music self, DWORD length)
