from .bass cimport HPLUGIN, BASS_PLUGININFO

cdef class Plugin:
  cdef HPLUGIN __plugin
  cdef const BASS_PLUGININFO* __getinfo(Plugin self)
  cpdef Free(Plugin self)