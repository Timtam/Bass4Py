from bass cimport DWORD, HWND, BASS_DEVICEINFO, BASS_INFO
cdef class BASSDEVICE:
 cdef readonly DWORD __device
 cpdef __Evaluate(BASSDEVICE self)
 cpdef __EvaluateSelected(BASSDEVICE self)
 cdef BASS_INFO __getinfo(BASSDEVICE self)
 cdef BASS_DEVICEINFO __getdeviceinfo(BASSDEVICE self)
 cpdef Free(BASSDEVICE self)
 cpdef Init(BASSDEVICE self,DWORD freq,DWORD flags,int win)
 cpdef Pause(BASSDEVICE self)
 cpdef Set(BASSDEVICE self)
 cpdef Start(BASSDEVICE self)
 cpdef Stop(BASSDEVICE self)
 cpdef Update(BASSDEVICE self,DWORD length)