from ..bindings.bass cimport (
  BASS_RecordGetDeviceInfo, 
  BASS_DEVICEINFO,
  _BASS_DEVICE_DEFAULT)

from .input_device cimport InputDevice

cdef class InputDeviceEnumerator:

  def __cinit__(self):

    self._iterator_index = 0

  def __iter__(self):
    self._iterator_index = 0

    return self

  def __next__(self):

    cdef BASS_DEVICEINFO info
    cdef bint success

    success = BASS_RecordGetDeviceInfo(self._iterator_index, &info)

    if not success:
      raise StopIteration

    self._iterator_index += 1

    return InputDevice(self._iterator_index - 1)

  def next(self):
    return self.__next__()

  def __getitem__(self, key):
  
    cdef BASS_DEVICEINFO info
    cdef bint success

    if not isinstance(key, int):
      raise IndexError("index not an integer")
    
    if key < 0:
      return self.default
    
    success = BASS_RecordGetDeviceInfo(key, &info)

    if not success:
      raise IndexError("index out of range")

    return InputDevice(key)

  @property
  def default(self):
  
    cdef BASS_DEVICEINFO info
    cdef InputDevice device = None
    cdef int i = 0
    cdef bint success = True
    
    while success:

      success = BASS_RecordGetDeviceInfo(i, &info)

      if not success:
        break

      if info.flags & _BASS_DEVICE_DEFAULT:
        device = InputDevice(i)
      
      i += 1
      
    if not device:
      raise AttributeError("no default input device available")
      
    return device
