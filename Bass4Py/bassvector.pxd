from bass cimport BASS_3DVECTOR
cdef inline BASSVECTOR BASSVECTOR_Create(BASS_3DVECTOR *vector)
cdef class BASSVECTOR:
 cdef public float X
 cdef public float Y
 cdef public float Z
