from ..bindings.bass cimport DWORD

from .._evaluable cimport _Evaluable
from .input_device_enumerator cimport InputDeviceEnumerator
from .output_device_enumerator cimport OutputDeviceEnumerator
from .version cimport Version

cdef class BASS(_Evaluable):

  cdef readonly Version api_version
  """
  the version Bass4Py was created for. If :attr:`~Bass4Py.bass.BASS.version` 
  doesn't match this version, errors might occur due to API incompatibilities.
  """

  cdef readonly InputDeviceEnumerator input_devices
  """
  A :class:`~Bass4Py.bass.InputDeviceEnumerator` instance, allowing you to 
  access all the different input devices available on your system. You can 
  access its :attr:`~Bass4Py.bass.InputDeviceEnumerator.default` attribute to 
  quickly get access to the current default device on your system, or use the 
  index operator to get a specific device:
  
  .. code-block:: python
  
     from Bass4Py.bass import BASS
     
     bass = BASS()
     device = bass.input_devices[0]
     
  This attribute will work as an iterator too, so that you can loop over all the available devices on your system.
  
  .. code-block:: python
  
     from Bass4Py.bass import BASS
     
     bass = BASS()
     
     for device in bass.input_devices:
         print(device.name)
     
  Creating a list of all the devices works just the same, you can use the :obj:`list` for that purpose.
  """

  cdef readonly OutputDeviceEnumerator output_devices
  """
  A :class:`~Bass4Py.bass.OutputDeviceEnumerator` instance, allowing you to 
  access all the different output devices available on your system. You can 
  access its :attr:`~Bass4Py.bass.OutputDeviceEnumerator.default` attribute to 
  quickly get access to the current default device on your system, or use the 
  index operator to get a specific device:
  
  .. code-block:: python
  
     from Bass4Py.bass import BASS
     
     bass = BASS()
     device = bass.output_devices[0]
     
  This attribute will work as an iterator too, so that you can loop over all the available devices on your system.
  
  .. code-block:: python
  
     from Bass4Py.bass import BASS
     
     bass = BASS()
     
     for device in bass.output_devices:
         print(device.name)
     
  Creating a list of all the devices works just the same, you can use the :obj:`list` for that purpose.
  """

  cdef readonly Version version
  """
  version of the BASS library loaded (bass.dll/libbass.so)
  """

  cpdef load_plugin(BASS self, object filename)
  cpdef update(BASS self, DWORD length)
