from bass cimport HCHANNEL, BASS_CHANNELINFO, DWORD,QWORD,WORD,LOWORD,HIWORD,BASS_3DVECTOR,HSYNC,SYNCPROC
cdef class BASSCHANNEL:
 cdef readonly HCHANNEL __channel
 cdef BASS_CHANNELINFO __getinfo(BASSCHANNEL self)
 cdef DWORD __getflags(BASSCHANNEL self)
 cpdef __setflags(BASSCHANNEL self,DWORD flag,bint switch)
 cpdef GetLevels(BASSCHANNEL self,float length,DWORD flags)
 cpdef Lock(BASSCHANNEL self)
 cpdef Pause(BASSCHANNEL self)
 cpdef Play(BASSCHANNEL self,bint restart)
 cpdef SetSync(BASSCHANNEL self,DWORD type,QWORD param,object proc,object user=?)
 cpdef Stop(BASSCHANNEL self)
 cpdef Unlock(BASSCHANNEL self)