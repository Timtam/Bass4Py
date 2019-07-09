from .bass cimport (
                    HCHANNEL,
                    BASS_CHANNELINFO,
                    DWORD,
                    QWORD,
                    WORD,
                    LOWORD,
                    HIWORD,
                    BASS_3DVECTOR,
                    HDSP,
                    DSPPROC
                   )

from .basschannelattribute cimport BASSCHANNELATTRIBUTE
from .bassfx cimport BASSFX
from .basssync cimport BASSSYNC

cdef class BASSCHANNEL:
  cdef HCHANNEL __channel

  # attributes
  cdef readonly BASSCHANNELATTRIBUTE Buffer
  cdef readonly BASSCHANNELATTRIBUTE CPU
  cdef readonly BASSCHANNELATTRIBUTE Frequency
  cdef readonly BASSCHANNELATTRIBUTE Pan
  cdef readonly BASSCHANNELATTRIBUTE Ramping
  cdef readonly BASSCHANNELATTRIBUTE SRC
  cdef readonly BASSCHANNELATTRIBUTE Volume

  IF UNAME_SYSNAME == "Windows":
    cdef readonly BASSCHANNELATTRIBUTE EAXMix

  cdef BASS_CHANNELINFO __getinfo(BASSCHANNEL self)
  cdef DWORD __getflags(BASSCHANNEL self)
  cdef void __initattributes(BASSCHANNEL self)
  cpdef __setflags(BASSCHANNEL self, DWORD flag, bint switch)
  cpdef GetLevels(BASSCHANNEL self, float length, DWORD flags)
  cpdef Link(BASSCHANNEL self, BASSCHANNEL obj)
  cpdef Lock(BASSCHANNEL self)
  cpdef Pause(BASSCHANNEL self)
  cpdef Play(BASSCHANNEL self, bint restart)
  cpdef ResetFX(BASSCHANNEL self)
  cpdef SetDSP(BASSCHANNEL self, object proc, int priority, object user=?)
  cpdef SetFX(BASSCHANNEL self, BASSFX fx)
  cpdef SetSync(BASSCHANNEL self, BASSSYNC sync)
  cpdef Stop(BASSCHANNEL self)
  cpdef Unlink(BASSCHANNEL self, BASSCHANNEL obj)
  cpdef Unlock(BASSCHANNEL self)
  cpdef GetPosition(BASSCHANNEL self, DWORD mode=?)
  cpdef SetPosition(BASSCHANNEL self, QWORD pos, DWORD mode=?)
  cpdef Bytes2Seconds(BASSCHANNEL self, QWORD bytes)
  cpdef Seconds2Bytes(BASSCHANNEL self, double secs)
  cpdef GetData(BASSCHANNEL self, DWORD length)
  cpdef GetLength(BASSCHANNEL self, DWORD mode = ?)