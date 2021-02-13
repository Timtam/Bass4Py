from ..bindings.bass cimport (
  BASS_GetDeviceInfo, 
  BASS_DEVICEINFO,
  _BASS_DEVICE_DEFAULT)

from .output_device cimport OutputDevice

cdef class OutputDeviceEnumerator:
  """
  Gain access to all output devices on your system.
  
  This class behaves like a sequence and allows you to access all 
  :class:`Bass4Py.bass.OutputDevice` classes on your system via index, starting 
  at 0, which usually returns a no sound device which should be available on 
  all systems. Starting with index 1, the returned devices represent all the 
  possible output devices your system currently knows. A negative index will 
  yield the default output device of your system, which can also be accessed 
  via the :attr:`~Bass4Py.bass.OutputDeviceEnumerator.default` attribute. 
  
  You can also access all output devices at once in a regular sequence. To 
  achieve this, this class behaves like an iterable also, allowing you to loop 
  over it within a for loop or generate a list or tuple from this object. You 
  should not be required to instantiate this class yourself, but you can do so 
  anyway if you need to. An instance of this class is all-time available from 
  the :attr:`Bass4Py.bass.BASS.output_devices` attribute.
  """

  def __cinit__(self):

    self._iterator_index = 0

  def __iter__(self):
    self._iterator_index = 0

    return self

  def __next__(self):

    cdef BASS_DEVICEINFO info
    cdef bint success

    success = BASS_GetDeviceInfo(self._iterator_index, &info)

    if not success:
      raise StopIteration

    self._iterator_index += 1

    return OutputDevice(self._iterator_index - 1)

  def next(self):
    return self.__next__()

  def __getitem__(self, key):
  
    cdef BASS_DEVICEINFO info
    cdef bint success

    if not isinstance(key, int):
      raise IndexError("index not an integer")
    
    if key < 0:
      return self.default
    
    success = BASS_GetDeviceInfo(key, &info)

    if not success:
      raise IndexError("index out of range")

    return OutputDevice(key)

  @property
  def default(self):
    """
    :class:`Bass4Py.bass.OutputDevice`

    Returns the default output device of this system or the no sound device if 
    none exists.
    """
  
    cdef BASS_DEVICEINFO info
    cdef OutputDevice device = None
    cdef int i = 0
    cdef bint success = True
    
    while success:

      success = BASS_GetDeviceInfo(i, &info)

      if not success:
        break

      if info.flags & _BASS_DEVICE_DEFAULT:
        device = OutputDevice(i)
      
      i += 1
      
    if not device:
      device = OutputDevice(0)
      
    return device
