from .._evaluable cimport _Evaluable
from ..bindings.bass cimport (
  _BASS_INPUT_OFF,
  _BASS_INPUT_ON,
  _BASS_INPUT_TYPE_MASK,
  BASS_RecordGetInput,
  BASS_RecordGetInputName,
  BASS_RecordSetInput,
  )

cdef class Input(_Evaluable):
  def __cinit__(Input self, InputDevice device, int input):
    self._device = device
    self._input = input

  property name:
    def __get__(Input self):
      cdef char * name
      self._device.set()
      name = BASS_RecordGetInputName(self._input)
      self._evaluate()
      return name.decode('utf-8')

  property volume:
    def __get__(Input self):
      cdef float vol
      self._device.set()
      BASS_RecordGetInput(self._input, &vol)
      self._evaluate()
      return vol
    
    def __set__(Input self, float vol):
      cdef DWORD flags
      self._device.set()
      flags = BASS_RecordGetInput(self._input, NULL)
      self._evaluate()
      with nogil:
        BASS_RecordSetInput(self._input, flags, vol)
      self._evaluate()

  property enabled:
    def __get__(Input self):
      cdef DWORD flags
      self._device.set()
      flags = BASS_RecordGetInput(self._input, NULL)
      self._evaluate()
      return not <bint>(flags&_BASS_INPUT_OFF)
    
    def __set__(Input self, bint enable):
      cdef DWORD flags
      
      if enable:
        flags = _BASS_INPUT_ON
      else:
        flags = _BASS_INPUT_OFF
      
      self._device.set()
      with nogil:
        BASS_RecordSetInput(self._input, flags, -1)
      self._evaluate()

  property type:
    def __get__(Input self):
      cdef DWORD flags
      self._device.set()
      flags = BASS_RecordGetInput(self._input, NULL)
      self._evaluate()

      from ..constants import INPUT_TYPE

      return INPUT_TYPE(flags&_BASS_INPUT_TYPE_MASK)
