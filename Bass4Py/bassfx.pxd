from bass cimport DWORD,HFX,BASS_DX8_CHORUS,BASS_DX8_COMPRESSOR,BASS_DX8_DISTORTION,BASS_DX8_ECHO,BASS_DX8_FLANGER,BASS_DX8_GARGLE,BASS_DX8_I3DL2REVERB,BASS_DX8_PARAMEQ,BASS_DX8_REVERB
cpdef BASSFX_Create(DWORD channel,HFX fx,DWORD type)
cdef class BASSFX:
 cdef readonly DWORD __channel
 cdef readonly HFX __fx
 cdef readonly DWORD __type
 cpdef Remove(BASSFX self)
 cpdef Reset(BASSFX self)
cdef class BASSFX_DX8CHORUS(BASSFX):
 pass
cdef class BASSFX_DX8COMPRESSOR(BASSFX):
 pass
cdef class BASSFX_DX8DISTORTION(BASSFX):
 pass
cdef class BASSFX_DX8ECHO(BASSFX):
 pass
cdef class BASSFX_DX8FLANGER(BASSFX):
 pass
cdef class BASSFX_DX8GARGLE(BASSFX):
 pass
cdef class BASSFX_DX8I3DL2REVERB(BASSFX):
 pass
cdef class BASSFX_DX8PARAMEQ(BASSFX):
 pass
cdef class BASSFX_DX8REVERB(BASSFX):
 pass