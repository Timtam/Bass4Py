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

cdef class DEVICE:
  cdef DWORD __device
  cdef BASS_INFO __getinfo(DEVICE self)
  cdef BASS_DEVICEINFO __getdeviceinfo(DEVICE self)
  cpdef CreateMusicFromBytes(DEVICE self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?, bint device_frequency = ?)
  cpdef CreateMusicFromFile(DEVICE self, object file, DWORD flags = ?, QWORD offset = ?, bint device_frequency = ?)
  cpdef CreateSampleFromBytes(DEVICE self, const unsigned char[:] data, DWORD max = ?, DWORD flags = ?, DWORD length = ?)
  cpdef CreateSampleFromFile(DEVICE self, object filename, DWORD max = ?, DWORD flags = ?, QWORD offset = ?)
  cpdef CreateSampleFromParameters(DEVICE self, DWORD length, DWORD freq, DWORD chans, DWORD max = ?, DWORD flags = ?)
  cpdef CreateStream(DEVICE self)
  cpdef CreateStreamFromBytes(DEVICE self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?)
  cpdef CreateStreamFromFile(DEVICE self, object filename, DWORD flags = ?, QWORD offset = ?)
  cpdef CreateStreamFromFileObj(DEVICE self, object obj, DWORD system = ?, DWORD flags = ?)
  cpdef CreateStreamFromParameters(DEVICE self, DWORD freq, DWORD chans, DWORD flags = ?, object callback = ?)
  cpdef CreateStreamFromURL(DEVICE self, object url, DWORD flags = ?, QWORD offset = ?, object callback = ?)
  cpdef Free(DEVICE self)
  cpdef Init(DEVICE self, DWORD freq, DWORD flags, int win)
  cpdef Pause(DEVICE self)
  cpdef Set(DEVICE self)
  cpdef Start(DEVICE self)
  cpdef Stop(DEVICE self)

  IF UNAME_SYSNAME=="Windows":
    cpdef EAXPreset(DEVICE self, int preset)
