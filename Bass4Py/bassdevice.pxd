from .bass cimport (
                    DWORD,
                    QWORD,
                    HWND,
                    BASS_DEVICEINFO,
                    BASS_INFO,
                    BASS_FILEPROCS,
                    FILECLOSEPROC,
                    FILEREADPROC,
                    FILELENPROC,
                    FILESEEKPROC,
                    HSAMPLE,
                    HSTREAM,
                    HMUSIC,
                    BASS_3DVECTOR
                   )

cdef class BASSDEVICE:
  cdef DWORD __device
  cdef BASS_INFO __getinfo(BASSDEVICE self)
  cdef BASS_DEVICEINFO __getdeviceinfo(BASSDEVICE self)
  cpdef CreateStream(BASSDEVICE self)
  cpdef CreateStreamFromBytes(BASSDEVICE self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?)
  cpdef CreateStreamFromFile(BASSDEVICE self, object filename, DWORD flags = ?, QWORD offset = ?)
  cpdef CreateStreamFromParameters(BASSDEVICE self, DWORD freq, DWORD chans, DWORD flags = ?, object callback = ?)
  cpdef CreateStreamFromURL(BASSDEVICE self, object url, DWORD flags = ?, QWORD offset = ?, object callback = ?)
  cpdef Free(BASSDEVICE self)
  cpdef Init(BASSDEVICE self, DWORD freq, DWORD flags, int win)
  cpdef Pause(BASSDEVICE self)
  cpdef Set(BASSDEVICE self)
  cpdef Start(BASSDEVICE self)
  cpdef Stop(BASSDEVICE self)
  cpdef StreamCreateFileUser(BASSDEVICE self, DWORD system, DWORD flags, object close, object length, object read, object seek, object user=*)
  cpdef SampleLoad(BASSDEVICE self, bint mem, char *file, QWORD offset=?, DWORD length=?, DWORD max=?, DWORD flags=?)
  cpdef SampleCreate(BASSDEVICE self, DWORD length, DWORD freq, DWORD chans, DWORD max, DWORD flags)
  cpdef MusicLoad(BASSDEVICE self, bint mem, char *file, QWORD offset, DWORD length, DWORD flags, DWORD freq)

  IF UNAME_SYSNAME=="Windows":
    cpdef EAXPreset(BASSDEVICE self, int preset)
