from .._evaluable cimport _Evaluable
from ..bindings.bass cimport (
  DWORD,
  QWORD,
  HWND,
  BASS_DEVICEINFO,
  BASS_INFO,
  HSAMPLE,
  HSTREAM,
  HMUSIC,
  BASS_3DVECTOR)

cdef class OutputDevice(_Evaluable):
  cdef DWORD _device
  cdef BASS_INFO _getinfo(OutputDevice self)
  cdef BASS_DEVICEINFO _getdeviceinfo(OutputDevice self)
  cpdef CreateMusicFromBytes(OutputDevice self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?, bint device_frequency = ?)
  cpdef CreateMusicFromFile(OutputDevice self, object file, DWORD flags = ?, QWORD offset = ?, bint device_frequency = ?)
  cpdef CreateSampleFromBytes(OutputDevice self, const unsigned char[:] data, DWORD max = ?, DWORD flags = ?, DWORD length = ?)
  cpdef CreateSampleFromFile(OutputDevice self, object filename, DWORD max = ?, DWORD flags = ?, QWORD offset = ?)
  cpdef CreateSampleFromParameters(OutputDevice self, DWORD length, DWORD freq, DWORD chans, DWORD max = ?, DWORD flags = ?)
  cpdef CreateStream(OutputDevice self)
  cpdef CreateStream3D(OutputDevice self)
  cpdef CreateStreamFromBytes(OutputDevice self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?)
  cpdef CreateStreamFromFile(OutputDevice self, object filename, DWORD flags = ?, QWORD offset = ?)
  cpdef CreateStreamFromFileObj(OutputDevice self, object obj, DWORD system = ?, DWORD flags = ?)
  cpdef CreateStreamFromParameters(OutputDevice self, DWORD freq, DWORD chans, DWORD flags = ?, object callback = ?)
  cpdef CreateStreamFromURL(OutputDevice self, object url, DWORD flags = ?, QWORD offset = ?, object callback = ?)
  cpdef Free(OutputDevice self)
  cpdef Init(OutputDevice self, DWORD freq, DWORD flags, int win)
  cpdef Pause(OutputDevice self)
  cpdef Set(OutputDevice self)
  cpdef Start(OutputDevice self)
  cpdef Stop(OutputDevice self)
  cpdef EAXPreset(OutputDevice self, int preset)
