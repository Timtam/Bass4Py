from .bass cimport HPLUGIN, BASS_PLUGININFO

cdef class PLUGIN:
  cdef HPLUGIN __plugin
  cdef const BASS_PLUGININFO* __getinfo(PLUGIN self)
  cpdef Free(PLUGIN self)