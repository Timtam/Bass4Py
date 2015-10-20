cimport bass
from bass cimport DWORD, HCHANNEL
cdef class BASSCHANNELATTRIBUTE:
 cdef readonly HCHANNEL __channel
 cdef readonly DWORD __attribute
 cpdef __getmusicvolchan(BASSCHANNELATTRIBUTE self)
 cpdef __getnobuffer(BASSCHANNELATTRIBUTE self)
 cpdef __setmusicvolchan(BASSCHANNELATTRIBUTE self,list value)
 cpdef __setnobuffer(BASSCHANNELATTRIBUTE self,bint value)
 cpdef __slidemusicvolchan(BASSCHANNELATTRIBUTE self,list value,DWORD time)
 cpdef Get(BASSCHANNELATTRIBUTE self)
 cpdef Set(BASSCHANNELATTRIBUTE self,object value)
 cpdef Slide(BASSCHANNELATTRIBUTE self,object value,DWORD time)