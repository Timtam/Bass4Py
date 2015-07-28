from bass cimport HSAMPLE,BASS_SAMPLE,HCHANNEL,DWORD
cdef class BASSSAMPLE:
 cdef readonly HSAMPLE __sample
 cdef BASS_SAMPLE __getinfo(BASSSAMPLE self)
 cpdef Free(BASSSAMPLE self)
 cpdef GetChannel(BASSSAMPLE self,bint onlynew)
 cpdef Stop(BASSSAMPLE self)