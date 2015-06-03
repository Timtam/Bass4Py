from bass cimport HSAMPLE,BASS_SAMPLE
cdef class BASSSAMPLE:
 cdef readonly HSAMPLE __sample
 cdef BASS_SAMPLE __getinfo(BASSSAMPLE self)
 cpdef __Evaluate(BASSSAMPLE self)
 cpdef Free(BASSSAMPLE self)
 cpdef GetChannel(BASSSAMPLE self,bint onlynew)
 cpdef Stop(BASSSAMPLE self)