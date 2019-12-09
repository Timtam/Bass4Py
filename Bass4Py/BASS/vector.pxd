from .bass cimport BASS_3DVECTOR

cdef Vector CreateVector(BASS_3DVECTOR *vector)

cdef class Vector:
  cdef public float X
  cdef public float Y
  cdef public float Z
  cdef void Resolve(Vector self, BASS_3DVECTOR *vector)