from ..evaluable cimport Evaluable
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

cdef class OutputDevice(Evaluable):
  cdef DWORD _device
  cdef BASS_INFO _get_info(OutputDevice self)
  cdef BASS_DEVICEINFO _get_device_info(OutputDevice self)
  cpdef create_music_from_bytes(OutputDevice self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?, bint device_frequency = ?)
  cpdef create_music_from_file(OutputDevice self, object file, DWORD flags = ?, QWORD offset = ?, bint device_frequency = ?)
  cpdef create_sample_from_bytes(OutputDevice self, const unsigned char[:] data, DWORD max = ?, DWORD flags = ?, DWORD length = ?)
  cpdef create_sample_from_file(OutputDevice self, object filename, DWORD max = ?, DWORD flags = ?, QWORD offset = ?)
  cpdef create_sample_from_parameters(OutputDevice self, DWORD length, DWORD freq, DWORD chans, DWORD max = ?, DWORD flags = ?)
  cpdef create_stream(OutputDevice self)
  cpdef create_stream_3d(OutputDevice self)
  cpdef create_stream_from_bytes(OutputDevice self, const unsigned char[:] data, DWORD flags = ?, QWORD length = ?)
  cpdef create_stream_from_file(OutputDevice self, object filename, DWORD flags = ?, QWORD offset = ?)
  cpdef create_stream_from_file_obj(OutputDevice self, object obj, DWORD system = ?, DWORD flags = ?)
  cpdef create_stream_from_parameters(OutputDevice self, DWORD freq, DWORD chans, DWORD flags = ?, object callback = ?)
  cpdef create_stream_from_url(OutputDevice self, object url, DWORD flags = ?, QWORD offset = ?, object callback = ?)
  cpdef free(OutputDevice self)
  cpdef init(OutputDevice self, DWORD freq, DWORD flags, int win)
  cpdef pause(OutputDevice self)
  cpdef set(OutputDevice self)
  cpdef start(OutputDevice self)
  cpdef stop(OutputDevice self)
  cpdef eax_preset(OutputDevice self, int preset)
