from .bass cimport __Evaluate
from ..bindings.bass cimport (
  _BASS_DEVICE_DEFAULT,
  _BASS_DEVICE_ENABLED,
  _BASS_DEVICE_INIT,
  _BASS_DEVICE_LOOPBACK,
  _BASS_DEVICE_TYPE_MASK,
  BASS_RecordFree,
  BASS_RecordGetDeviceInfo,
  BASS_RecordGetInfo,
  BASS_RecordInit,
  BASS_RecordSetDevice,
  )

from .input cimport Input
from .record cimport Record
from ..exceptions import BassPlatformError

cdef class InputDevice:
  def __cinit__(InputDevice self, int device):
    self._device=device
    self.Inputs = ()

  cdef BASS_DEVICEINFO _getdeviceinfo(InputDevice self):
    cdef BASS_DEVICEINFO info
    BASS_RecordGetDeviceInfo(self._device, &info)
    return info

  cdef BASS_RECORDINFO _getinfo(InputDevice self):
    cdef BASS_RECORDINFO info
    cdef bint res = BASS_RecordGetInfo(&info)
    return info

  cpdef Set(InputDevice self):
    cdef bint res 
    with nogil:
      res = BASS_RecordSetDevice(self._device)
    __Evaluate()
    return res

  cpdef Free(InputDevice self):
    cdef bint res
    self.Set()
    with nogil:
      res = BASS_RecordFree()
    __Evaluate()
    self.Inputs = ()
    return res

  cpdef Init(InputDevice self):
    cdef BASS_RECORDINFO info
    cdef list inputs = []
    cdef bint res
    cdef int i

    res = BASS_RecordInit(self._device)
    __Evaluate()

    info = self._getinfo()
    __Evaluate()
    
    IF UNAME_SYSNAME != "Darwin":
      inputs.append(Input(self, -1))
    
    for i in range(info.inputs):
      inputs.append(Input(self, i))
    
    self.Inputs = tuple(inputs)

    return res

  cpdef Record(InputDevice self, DWORD freq = 0, DWORD chans = 0, DWORD flags = 0, object callback = None, DWORD period = 100):
    return Record.FromDevice(self, freq, chans, flags, callback, period)

  property Name:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      return info.name.decode('utf-8')

  property Driver:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      if info.driver == NULL:
        return u''
      return info.driver.decode('utf-8')

  property Enabled:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      return <bint>(info.flags&_BASS_DEVICE_ENABLED)

  property Default:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      return <bint>(info.flags&_BASS_DEVICE_DEFAULT)

  property Initialized:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      return <bint>(info.flags&_BASS_DEVICE_INIT)

  property Loopback:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      return <bint>(info.flags&_BASS_DEVICE_LOOPBACK)

  property Type:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()

      from ..constants import DEVICE_TYPE

      return DEVICE_TYPE(info.flags&_BASS_DEVICE_TYPE_MASK)

  property Flags:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        info = self._getinfo()
        __Evaluate()
        return info.flags

  property Formats:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.formats & 0xffffff

  property Channels:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.formats >> 24

  property SingleInput:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return <bint>info.singlein

  property Frequency:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.freq
