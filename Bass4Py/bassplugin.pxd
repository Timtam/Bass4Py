from bass cimport DWORD, BASS_PLUGININFO
cdef class BASSPLUGIN:
 cdef readonly DWORD __plugin
 cdef BASS_PLUGININFO* __getinfo(BASSPLUGIN self)
 cpdef __Evaluate(BASSPLUGIN self)
 cpdef Free(BASSPLUGIN self)