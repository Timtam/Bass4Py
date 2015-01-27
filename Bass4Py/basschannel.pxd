from bass cimport HCHANNEL
cdef class BASSCHANNEL:
 cdef readonly HCHANNEL __channel
 cpdef __Evaluate(BASSCHANNEL self)
 cpdef Play(BASSCHANNEL self,bint restart)