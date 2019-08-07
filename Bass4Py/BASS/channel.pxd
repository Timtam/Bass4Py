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
from .dsp cimport DSP
from .fx cimport FX
from .sync cimport SYNC

cdef class CHANNEL:
  cdef HCHANNEL __channel

  # attributes
  cdef readonly ATTRIBUTE Buffer
  cdef readonly ATTRIBUTE CPU
  cdef readonly ATTRIBUTE Frequency
  cdef readonly ATTRIBUTE Pan
  cdef readonly ATTRIBUTE Ramping
  cdef readonly ATTRIBUTE SRC
  cdef readonly ATTRIBUTE Volume

  IF UNAME_SYSNAME == "Windows":
    cdef readonly ATTRIBUTE EAXMix

  cdef BASS_CHANNELINFO __getinfo(CHANNEL self)
  cdef DWORD __getflags(CHANNEL self)
  cdef void __initattributes(CHANNEL self)
  cpdef __setflags(CHANNEL self, DWORD flag, bint switch)
  cpdef GetLevels(CHANNEL self, float length, DWORD flags)
  cpdef Link(CHANNEL self, CHANNEL obj)
  cpdef Lock(CHANNEL self)
  cpdef Pause(CHANNEL self)
  cpdef Play(CHANNEL self, bint restart)
  cpdef ResetFX(CHANNEL self)
  cpdef SetDSP(CHANNEL self, DSP dsp)
  cpdef SetFX(CHANNEL self, FX fx)
  cpdef SetSync(CHANNEL self, SYNC sync)
  cpdef Stop(CHANNEL self)
  cpdef Unlink(CHANNEL self, CHANNEL obj)
  cpdef Unlock(CHANNEL self)
  cpdef GetPosition(CHANNEL self, DWORD mode=?)
  cpdef SetPosition(CHANNEL self, QWORD pos, DWORD mode=?)
  cpdef Bytes2Seconds(CHANNEL self, QWORD bytes)
  cpdef Seconds2Bytes(CHANNEL self, double secs)
  cpdef GetData(CHANNEL self, DWORD length)
  cpdef GetLength(CHANNEL self, DWORD mode = ?)