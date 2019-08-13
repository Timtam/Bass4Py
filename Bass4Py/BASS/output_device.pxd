from .bass cimport (
                    DWORD,
                    QWORD,
                    HWND,
                    BASS_DEVICEINFO,
                    BASS_INFO,
                    HSAMPLE,
                    HSTREAM,
                    HMUSIC,
                    BASS_3DVECTOR
                   )

cdef class OUTPUT_DEVICE:
  cdef DWORD __device
  cdef BASS_INFO __getinfo(OUTPUT_DEVICE self)
  cdef BASS_DEVICEINFO __getdeviceinfo(OUTPUT_DEVICE self)
  cpdef CreateMusicFromBytes(OUTPUT_DEVICE self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?, bint device_frequency = ?)
  cpdef CreateMusicFromFile(OUTPUT_DEVICE self, object file, DWORD flags = ?, QWORD offset = ?, bint device_frequency = ?)
  cpdef CreateSampleFromBytes(OUTPUT_DEVICE self, const unsigned char[:] data, DWORD max = ?, DWORD flags = ?, DWORD length = ?)
  cpdef CreateSampleFromFile(OUTPUT_DEVICE self, object filename, DWORD max = ?, DWORD flags = ?, QWORD offset = ?)
  cpdef CreateSampleFromParameters(OUTPUT_DEVICE self, DWORD length, DWORD freq, DWORD chans, DWORD max = ?, DWORD flags = ?)
  cpdef CreateStream(OUTPUT_DEVICE self)
  cpdef CreateStream3D(OUTPUT_DEVICE self)
  cpdef CreateStreamFromBytes(OUTPUT_DEVICE self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?)
  cpdef CreateStreamFromFile(OUTPUT_DEVICE self, object filename, DWORD flags = ?, QWORD offset = ?)
  cpdef CreateStreamFromFileObj(OUTPUT_DEVICE self, object obj, DWORD system = ?, DWORD flags = ?)
  cpdef CreateStreamFromParameters(OUTPUT_DEVICE self, DWORD freq, DWORD chans, DWORD flags = ?, object callback = ?)
  cpdef CreateStreamFromURL(OUTPUT_DEVICE self, object url, DWORD flags = ?, QWORD offset = ?, object callback = ?)
  cpdef Free(OUTPUT_DEVICE self)
  cpdef Init(OUTPUT_DEVICE self, DWORD freq, DWORD flags, int win)
  cpdef Pause(OUTPUT_DEVICE self)
  cpdef Set(OUTPUT_DEVICE self)
  cpdef Start(OUTPUT_DEVICE self)
  cpdef Stop(OUTPUT_DEVICE self)

  IF UNAME_SYSNAME=="Windows":
    cpdef EAXPreset(OUTPUT_DEVICE self, int preset)
