from ..bindings.bass cimport DWORD

cdef class InputDeviceEnumerator:

  cdef DWORD _iterator_index  
