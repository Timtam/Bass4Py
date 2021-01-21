from ...bindings.bass cimport (
  _BASS_SYNC_DEV_FAIL,
  DWORD)

from ..sync cimport Sync

cdef class DeviceFail(Sync):
  def __cinit__(DeviceFail self):

    self._type = _BASS_SYNC_DEV_FAIL
    self._set_mix_time(True)
