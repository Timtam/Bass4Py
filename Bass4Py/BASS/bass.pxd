from ..bindings.bass cimport DWORD

from .version cimport Version

cpdef __Evaluate()
cdef class BASS:

  cdef readonly Version Version
  cdef readonly Version APIVersion

  cpdef GetInputDevice(BASS self, int device = ?)
  cpdef GetOutputDevice(BASS self, int device=?)
  cpdef LoadPlugin(BASS self, object filename)
  cpdef Update(BASS self, DWORD length)
