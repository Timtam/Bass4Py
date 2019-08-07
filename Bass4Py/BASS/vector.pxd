from .bass cimport BASS_3DVECTOR

cdef VECTOR VECTOR_Create(BASS_3DVECTOR *vector)

cdef class VECTOR:
  cdef public float X
  cdef public float Y
  cdef public float Z
  cdef void Resolve(VECTOR self, BASS_3DVECTOR *vector)