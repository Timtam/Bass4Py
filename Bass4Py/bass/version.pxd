from ..bindings.bass cimport DWORD

cdef class Version(str):
  cdef DWORD _version