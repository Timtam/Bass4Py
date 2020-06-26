from ..bindings.bass cimport HPLUGIN, BASS_PLUGININFO

cdef class Plugin:
  cdef HPLUGIN _plugin
  cdef const BASS_PLUGININFO* _getinfo(Plugin self)
  cpdef Free(Plugin self)