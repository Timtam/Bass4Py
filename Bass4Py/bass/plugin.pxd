from ..evaluable cimport Evaluable
from ..bindings.bass cimport HPLUGIN, BASS_PLUGININFO

cdef class Plugin(Evaluable):
  cdef HPLUGIN _plugin
  cdef const BASS_PLUGININFO* _get_info(Plugin self)
  cpdef free(Plugin self)