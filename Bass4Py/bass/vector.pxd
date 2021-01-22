from ..bindings.bass cimport (
  BASS_3DVECTOR)

cdef Vector CreateVector(BASS_3DVECTOR *vector)

cdef class Vector:
  cdef public float x
  cdef public float y
  cdef public float z
  cdef void Resolve(Vector self, BASS_3DVECTOR *vector)