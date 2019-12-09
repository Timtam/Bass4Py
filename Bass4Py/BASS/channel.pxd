from .bass cimport (
                    HCHANNEL,
                    BASS_CHANNELINFO,
                    DWORD,
                    QWORD,
                    WORD,
                    LOWORD,
                    HIWORD,
                    BASS_3DVECTOR
                   )

from .attribute cimport Attribute
from .channel_base cimport ChannelBase
from .dsp cimport DSP
from .fx cimport FX
from .output_device cimport OutputDevice
from .sync cimport Sync

cdef class Channel(ChannelBase):
  cdef OutputDevice __device

  # attributes
  cdef readonly Attribute Buffer
  cdef readonly Attribute CPU
  cdef readonly Attribute Ramping
  cdef readonly Attribute EAXMix

  cdef DWORD __getflags(Channel self)
  cpdef __setflags(Channel self, DWORD flag, bint switch)
  cpdef Link(Channel self, Channel obj)
  cpdef Play(Channel self, bint restart)
  cpdef ResetFX(Channel self)
  cpdef SetDSP(Channel self, DSP dsp)
  cpdef SetFX(Channel self, FX fx)
  cpdef SetSync(Channel self, Sync sync)
  cpdef Unlink(Channel self, Channel obj)
  cpdef SetPosition(Channel self, QWORD pos, DWORD mode=?)
