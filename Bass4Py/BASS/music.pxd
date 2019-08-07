from .bass cimport (
                    DWORD,
                    HCHANNEL,
                    HMUSIC,
                    QWORD
                   )

from .channel cimport CHANNEL
from .attribute cimport ATTRIBUTE

cdef class MUSIC(CHANNEL):

  # attributes
  cdef readonly ATTRIBUTE Active
  cdef readonly ATTRIBUTE Amplification
  cdef readonly ATTRIBUTE BPM
  cdef readonly ATTRIBUTE ChannelVolumes
  cdef readonly ATTRIBUTE GlobalVolume
  cdef readonly ATTRIBUTE InstrumentVolumes
  cdef readonly ATTRIBUTE PanSeparation
  cdef readonly ATTRIBUTE PositionScaler
  cdef readonly ATTRIBUTE Speed

  cpdef Free(MUSIC self)