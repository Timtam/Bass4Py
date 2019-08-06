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

cdef class BASSDEVICE:
  cdef DWORD __device
  cdef BASS_INFO __getinfo(BASSDEVICE self)
  cdef BASS_DEVICEINFO __getdeviceinfo(BASSDEVICE self)
  cpdef CreateMusicFromBytes(BASSDEVICE self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?, bint device_frequency = ?)
  cpdef CreateMusicFromFile(BASSDEVICE self, object file, DWORD flags = ?, QWORD offset = ?, bint device_frequency = ?)
  cpdef CreateSampleFromBytes(BASSDEVICE self, const unsigned char[:] data, DWORD max = ?, DWORD flags = ?, DWORD length = ?)
  cpdef CreateSampleFromFile(BASSDEVICE self, object filename, DWORD max = ?, DWORD flags = ?, QWORD offset = ?)
  cpdef CreateSampleFromParameters(BASSDEVICE self, DWORD length, DWORD freq, DWORD chans, DWORD max = ?, DWORD flags = ?)
  cpdef CreateStream(BASSDEVICE self)
  cpdef CreateStreamFromBytes(BASSDEVICE self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?)
  cpdef CreateStreamFromFile(BASSDEVICE self, object filename, DWORD flags = ?, QWORD offset = ?)
  cpdef CreateStreamFromFileObj(BASSDEVICE self, object obj, DWORD system = ?, DWORD flags = ?)
  cpdef CreateStreamFromParameters(BASSDEVICE self, DWORD freq, DWORD chans, DWORD flags = ?, object callback = ?)
  cpdef CreateStreamFromURL(BASSDEVICE self, object url, DWORD flags = ?, QWORD offset = ?, object callback = ?)
  cpdef Free(BASSDEVICE self)
  cpdef Init(BASSDEVICE self, DWORD freq, DWORD flags, int win)
  cpdef Pause(BASSDEVICE self)
  cpdef Set(BASSDEVICE self)
  cpdef Start(BASSDEVICE self)
  cpdef Stop(BASSDEVICE self)

  IF UNAME_SYSNAME=="Windows":
    cpdef EAXPreset(BASSDEVICE self, int preset)
