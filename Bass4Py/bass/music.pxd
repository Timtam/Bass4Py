from ..bindings.bass cimport (
  DWORD,
  HCHANNEL,
  HMUSIC,
  QWORD)

from .channel cimport Channel
from .attributes.float_attribute cimport FloatAttribute
from .attributes.float_list_attribute cimport FloatListAttribute

cdef class Music(Channel):

  # attributes
  cdef readonly FloatAttribute active_channels
  cdef readonly FloatAttribute amplification
  cdef readonly FloatAttribute bpm
  cdef readonly FloatListAttribute channel_volumes
  cdef readonly FloatAttribute global_volume
  cdef readonly FloatListAttribute instrument_volumes
  cdef readonly FloatAttribute pan_separation
  cdef readonly FloatAttribute position_scaler
  cdef readonly FloatAttribute speed

  cdef readonly object tags

  cpdef free(Music self)
  cpdef update(Music self, DWORD length)
