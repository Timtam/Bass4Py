from ...bindings.bass cimport (
  _BASS_SYNC_DEV_FORMAT,
  DWORD)

from ..sync cimport Sync

cdef class DeviceFormat(Sync):
  def __cinit__(DeviceFormat self):

    self._type = _BASS_SYNC_DEV_FORMAT
    self._set_mix_time(True)
