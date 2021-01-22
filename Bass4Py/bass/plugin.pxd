from .._evaluable cimport _Evaluable
from ..bindings.bass cimport HPLUGIN, BASS_PLUGININFO

cdef class Plugin(_Evaluable):
  cdef HPLUGIN _plugin
  cdef const BASS_PLUGININFO* _get_info(Plugin self)
  cpdef free(Plugin self)