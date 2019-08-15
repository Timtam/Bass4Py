from .bass cimport (
                    DWORD,
                    BASS_DEVICEINFO,
                    BASS_RECORDINFO
                   )

cdef class INPUT_DEVICE:
  cdef DWORD __device
  cdef BASS_DEVICEINFO __getdeviceinfo(INPUT_DEVICE self)
  cdef BASS_RECORDINFO __getinfo(INPUT_DEVICE self)
  cpdef Set(INPUT_DEVICE self)
