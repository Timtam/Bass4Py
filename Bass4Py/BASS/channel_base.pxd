from .bass cimport (
                    BASS_CHANNELINFO,
                    DWORD,
                    HCHANNEL,
                    QWORD
                   )
from .attribute cimport ATTRIBUTE
from ..exceptions import BassError

cdef class CHANNEL_BASE:
  cdef HCHANNEL __channel
  cdef object __flags_enum

  # attributes
  cdef readonly ATTRIBUTE Frequency
  cdef readonly ATTRIBUTE Pan
  cdef readonly ATTRIBUTE SRC
  cdef readonly ATTRIBUTE Volume

  cdef BASS_CHANNELINFO __getinfo(CHANNEL_BASE self)
  cdef void __initattributes(CHANNEL_BASE self)
  cdef void __sethandle(CHANNEL_BASE self, HCHANNEL handle)
  cpdef GetLevels(CHANNEL_BASE self, float length, DWORD flags)
  cpdef Lock(CHANNEL_BASE self)
  cpdef Pause(CHANNEL_BASE self)
  cpdef Stop(CHANNEL_BASE self)
  cpdef Unlock(CHANNEL_BASE self)
  cpdef GetPosition(CHANNEL_BASE self, DWORD mode=?)
  cpdef Bytes2Seconds(CHANNEL_BASE self, QWORD bytes)
  cpdef Seconds2Bytes(CHANNEL_BASE self, double secs)
  cpdef GetData(CHANNEL_BASE self, DWORD length)
  cpdef GetLength(CHANNEL_BASE self, DWORD mode = ?)
