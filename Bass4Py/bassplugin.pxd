from .bass cimport HPLUGIN, BASS_PLUGININFO
cdef class BASSPLUGIN:
 cdef HPLUGIN __plugin
 cdef const BASS_PLUGININFO* __getinfo(BASSPLUGIN self)
 cpdef Free(BASSPLUGIN self)