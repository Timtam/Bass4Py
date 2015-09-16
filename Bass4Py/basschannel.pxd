from bass cimport HCHANNEL, BASS_CHANNELINFO, DWORD
cdef class BASSCHANNEL:
 cdef readonly HCHANNEL __channel
 cdef BASS_CHANNELINFO __getinfo(BASSCHANNEL self)
 cpdef __getattribute(BASSCHANNEL self,DWORD attrib)
 cpdef __setattribute(BASSCHANNEL self,DWORD attrib,float value)
 cdef DWORD __getflags(BASSCHANNEL self)
 cpdef __setflags(BASSCHANNEL self,DWORD flag,bint switch)
 cpdef Pause(BASSCHANNEL self)
 cpdef Play(BASSCHANNEL self,bint restart)
 cpdef Stop(BASSCHANNEL self)