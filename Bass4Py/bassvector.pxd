from bass cimport BASS_3DVECTOR
cdef BASSVECTOR BASSVECTOR_Create(BASS_3DVECTOR *vector)
cdef class BASSVECTOR:
 cdef public float X
 cdef public float Y
 cdef public float Z
 cdef void Resolve(BASSVECTOR self,BASS_3DVECTOR *vector)