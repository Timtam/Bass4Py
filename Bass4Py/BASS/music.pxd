from .bass cimport (
                    DWORD,
                    HCHANNEL,
                    HMUSIC,
                    QWORD
                   )

from .channel cimport Channel
from .attribute cimport Attribute

cdef class Music(Channel):

  # attributes
  cdef readonly Attribute Active
  cdef readonly Attribute Amplification
  cdef readonly Attribute BPM
  cdef readonly Attribute ChannelVolumes
  cdef readonly Attribute GlobalVolume
  cdef readonly Attribute InstrumentVolumes
  cdef readonly Attribute PanSeparation
  cdef readonly Attribute PositionScaler
  cdef readonly Attribute Speed

  cpdef Free(Music self)