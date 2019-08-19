from .bass cimport (
                    DWORD,
                    BASS_DEVICEINFO,
                    BASS_RECORDINFO
                   )

cdef class INPUT_DEVICE:
  cdef DWORD __device
  cdef readonly tuple Inputs
  cdef BASS_DEVICEINFO __getdeviceinfo(INPUT_DEVICE self)
  cdef BASS_RECORDINFO __getinfo(INPUT_DEVICE self)
  cpdef Free(INPUT_DEVICE self)
  cpdef Init(INPUT_DEVICE self)
  cpdef Set(INPUT_DEVICE self)
