from ...bindings.bass cimport (
  _BASS_SYNC_OGG_CHANGE,
  DWORD)

from ..channel cimport Channel
from ..stream cimport Stream
from ..sync cimport Sync
from ...exceptions import BassSyncError

cdef class OggChange(Sync):
  def __cinit__(OggChange self):

    self._type = _BASS_SYNC_OGG_CHANGE

  cpdef set(OggChange self, Channel chan):
    if not isinstance(chan, Stream):
      raise BassSyncError("this sync can only be set to a stream")
    
    super(OggChange, self).set(chan)
