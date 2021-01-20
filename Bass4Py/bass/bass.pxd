from ..bindings.bass cimport DWORD

from .._evaluable cimport _Evaluable
from .version cimport Version

cdef class BASS(_Evaluable):

  cdef readonly Version api_version
  """
  the version Bass4Py was created for. If :attr:`~Bass4Py.bass.BASS.version` 
  doesn't match this version, errors might occur due to API incompatibilities.
  """

  cdef readonly Version version
  """
  version of the BASS library loaded (bass.dll/libbass.so)
  """

  cpdef get_input_device(BASS self, int device = ?)
  cpdef get_output_device(BASS self, int device=?)
  cpdef load_plugin(BASS self, object filename)
  cpdef update(BASS self, DWORD length)
