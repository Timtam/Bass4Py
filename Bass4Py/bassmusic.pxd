from bass cimport (
                   HCHANNEL,
                   QWORD
                  )

from basschannel cimport BASSCHANNEL
from basschannelattribute cimport BASSCHANNELATTRIBUTE

cdef class BASSMUSIC(BASSCHANNEL):

  # attributes
  cdef readonly BASSCHANNELATTRIBUTE Active
  cdef readonly BASSCHANNELATTRIBUTE Amplification
  cdef readonly BASSCHANNELATTRIBUTE BPM
  cdef readonly BASSCHANNELATTRIBUTE ChannelVolumes
  cdef readonly BASSCHANNELATTRIBUTE GlobalVolume
  cdef readonly BASSCHANNELATTRIBUTE InstrumentVolumes
  cdef readonly BASSCHANNELATTRIBUTE PanSeparation
  cdef readonly BASSCHANNELATTRIBUTE PositionScaler
  cdef readonly BASSCHANNELATTRIBUTE Speed

  cpdef Free(BASSMUSIC self)