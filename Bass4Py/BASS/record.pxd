from .bass cimport (
                    BASS_CHANNELINFO,
                    DWORD,
                    HRECORD,
                    QWORD
                   )
from .attribute cimport ATTRIBUTE

cdef class RECORD:
  cdef HRECORD __record
  cdef object __func

  # attributes
  cdef readonly ATTRIBUTE Frequency
  cdef readonly ATTRIBUTE Pan
  cdef readonly ATTRIBUTE SRC
  cdef readonly ATTRIBUTE Volume

  cdef void __initattributes(RECORD self)
  cdef BASS_CHANNELINFO __getinfo(RECORD self)
  cpdef Bytes2Seconds(RECORD self, QWORD bytes)
  cpdef GetData(RECORD self, DWORD length)
  cpdef Seconds2Bytes(RECORD self, double secs)
  cpdef Pause(RECORD self)
  cpdef Start(RECORD self)
  cpdef Stop(RECORD self)