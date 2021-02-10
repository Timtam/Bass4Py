from ...bindings.bass cimport (
  BASS_ChannelGetAttributeEx,
  BASS_ChannelSetAttributeEx)

from ...exceptions import BassAPIError, BassAttributeError, BassInvalidTypeError, BassPlatformError

from cpython.mem cimport PyMem_Malloc, PyMem_Free

cdef class BytesAttribute(_AttributeBase):
  cpdef get(self):
    cdef bytes res
    cdef DWORD size
    cdef void *info

    size = BASS_ChannelGetAttributeEx(self._channel, self._attribute, NULL, 0)
    self._evaluate()

    info = PyMem_Malloc(size)

    if info == NULL:
      raise MemoryError()

    BASS_ChannelGetAttributeEx(self._channel, self._attribute, info, size)

    try:
      self._evaluate()
    except Exception, e:
      PyMem_Free(info)
      raise e
    
    res = (<char*>info)[:size]
    PyMem_Free(info)
    return res

  cpdef set(self, bytes value):
    cdef DWORD size = len(value)
    cdef DWORD res = BASS_ChannelSetAttributeEx(self._channel, self._attribute, <void*>value, size)
    self._evaluate()
    return res
