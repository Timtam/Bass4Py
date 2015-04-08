from bass cimport HSAMPLE
cdef class BASSSAMPLE:
 cdef readonly HSAMPLE __sample
 cpdef __Evaluate(BASSSAMPLE self)