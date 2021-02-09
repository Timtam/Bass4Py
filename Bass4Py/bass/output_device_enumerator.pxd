from ..bindings.bass cimport DWORD

cdef class OutputDeviceEnumerator:

  cdef DWORD _iterator_index  
