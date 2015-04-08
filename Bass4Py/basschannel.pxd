from bass cimport HCHANNEL, BASS_CHANNELINFO
cdef class BASSCHANNEL:
 cdef readonly HCHANNEL __channel
 cdef BASS_CHANNELINFO __getinfo(BASSCHANNEL self)
 cpdef __Evaluate(BASSCHANNEL self)
 cpdef Pause(BASSCHANNEL self)
 cpdef Play(BASSCHANNEL self,bint restart)
 cpdef Stop(BASSCHANNEL self)