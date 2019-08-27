from . cimport bass
from ..constants import INPUT_TYPE

cdef class INPUT:
  def __cinit__(INPUT self, INPUT_DEVICE device, int input):
    self.__device = device
    self.__input = input

  property Name:
    def __get__(INPUT self):
      cdef char * name
      self.__device.Set()
      name = bass.BASS_RecordGetInputName(self.__input)
      bass.__Evaluate()
      return name.decode('utf-8')

  property Volume:
    def __get__(INPUT self):
      cdef float vol
      self.__device.Set()
      bass.BASS_RecordGetInput(self.__input, &vol)
      bass.__Evaluate()
      return vol
    
    def __set__(INPUT self, float vol):
      cdef DWORD flags
      self.__device.Set()
      flags = bass.BASS_RecordGetInput(self.__input, NULL)
      bass.__Evaluate()
      with nogil:
        bass.BASS_RecordSetInput(self.__input, flags, vol)
      bass.__Evaluate()

  property Enabled:
    def __get__(INPUT self):
      cdef DWORD flags
      self.__device.Set()
      flags = bass.BASS_RecordGetInput(self.__input, NULL)
      bass.__Evaluate()
      return not <bint>(flags&bass._BASS_INPUT_OFF)
    
    def __set__(INPUT self, bint enable):
      cdef DWORD flags
      
      if enable:
        flags = bass._BASS_INPUT_ON
      else:
        flags = bass._BASS_INPUT_OFF
      
      self.__device.Set()
      with nogil:
        bass.BASS_RecordSetInput(self.__input, flags, -1)
      bass.__Evaluate()

  property Type:
    def __get__(INPUT self):
      cdef DWORD flags
      self.__device.Set()
      flags = bass.BASS_RecordGetInput(self.__input, NULL)
      bass.__Evaluate()
      return INPUT_TYPE(flags&bass._BASS_INPUT_TYPE_MASK)
