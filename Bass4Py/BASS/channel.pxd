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

from .attribute cimport ATTRIBUTE
from .channel_base cimport CHANNEL_BASE
from .dsp cimport DSP
from .fx cimport FX
from .output_device cimport OUTPUT_DEVICE
from .sync cimport SYNC

cdef class CHANNEL(CHANNEL_BASE):
  cdef OUTPUT_DEVICE __device

  # attributes
  cdef readonly ATTRIBUTE Buffer
  cdef readonly ATTRIBUTE CPU
  cdef readonly ATTRIBUTE Ramping

  IF UNAME_SYSNAME == "Windows":
    cdef readonly ATTRIBUTE EAXMix

  cdef DWORD __getflags(CHANNEL self)
  cpdef __setflags(CHANNEL self, DWORD flag, bint switch)
  cpdef Link(CHANNEL self, CHANNEL obj)
  cpdef Play(CHANNEL self, bint restart)
  cpdef ResetFX(CHANNEL self)
  cpdef SetDSP(CHANNEL self, DSP dsp)
  cpdef SetFX(CHANNEL self, FX fx)
  cpdef SetSync(CHANNEL self, SYNC sync)
  cpdef Unlink(CHANNEL self, CHANNEL obj)
  cpdef SetPosition(CHANNEL self, QWORD pos, DWORD mode=?)
