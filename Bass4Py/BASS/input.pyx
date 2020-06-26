from .bass cimport __Evaluate
from ..bindings.bass cimport (
  _BASS_INPUT_OFF,
  _BASS_INPUT_ON,
  _BASS_INPUT_TYPE_MASK,
  BASS_RecordGetInput,
  BASS_RecordGetInputName,
  BASS_RecordSetInput,
  )

cdef class Input:
  def __cinit__(Input self, InputDevice device, int input):
    self._device = device
    self._input = input

  property Name:
    def __get__(Input self):
      cdef char * name
      self._device.Set()
      name = BASS_RecordGetInputName(self._input)
      __Evaluate()
      return name.decode('utf-8')

  property Volume:
    def __get__(Input self):
      cdef float vol
      self._device.Set()
      BASS_RecordGetInput(self._input, &vol)
      __Evaluate()
      return vol
    
    def __set__(Input self, float vol):
      cdef DWORD flags
      self._device.Set()
      flags = BASS_RecordGetInput(self._input, NULL)
      __Evaluate()
      with nogil:
        BASS_RecordSetInput(self._input, flags, vol)
      __Evaluate()

  property Enabled:
    def __get__(Input self):
      cdef DWORD flags
      self._device.Set()
      flags = BASS_RecordGetInput(self._input, NULL)
      __Evaluate()
      return not <bint>(flags&_BASS_INPUT_OFF)
    
    def __set__(Input self, bint enable):
      cdef DWORD flags
      
      if enable:
        flags = _BASS_INPUT_ON
      else:
        flags = _BASS_INPUT_OFF
      
      self._device.Set()
      with nogil:
        BASS_RecordSetInput(self._input, flags, -1)
      __Evaluate()

  property Type:
    def __get__(Input self):
      cdef DWORD flags
      self._device.Set()
      flags = BASS_RecordGetInput(self._input, NULL)
      __Evaluate()

      from ..constants import INPUT_TYPE

      return INPUT_TYPE(flags&_BASS_INPUT_TYPE_MASK)
