from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  _BASS_DEVICE_DEFAULT,
  _BASS_DEVICE_DEFAULTCOM,
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

cdef class InputDevice(Evaluable):
  def __cinit__(InputDevice self, int device):
    self._device=device
    self.inputs = ()

  cdef BASS_DEVICEINFO _get_device_info(InputDevice self):
    cdef BASS_DEVICEINFO info
    BASS_RecordGetDeviceInfo(self._device, &info)
    return info

  cdef BASS_RECORDINFO _get_info(InputDevice self):
    cdef BASS_RECORDINFO info
    cdef bint res = BASS_RecordGetInfo(&info)
    return info

  cpdef set(InputDevice self):
    cdef bint res 
    with nogil:
      res = BASS_RecordSetDevice(self._device)
    self._evaluate()
    return res

  cpdef free(InputDevice self):
    cdef bint res
    self.Set()
    with nogil:
      res = BASS_RecordFree()
    self._evaluate()
    self.Inputs = ()
    return res

  cpdef init(InputDevice self):
    cdef BASS_RECORDINFO info
    cdef list inputs = []
    cdef bint res
    cdef int i

    res = BASS_RecordInit(self._device)
    self._evaluate()

    info = self._get_info()
    self._evaluate()
    
    IF UNAME_SYSNAME != "Darwin":
      inputs.append(Input(self, -1))
    
    for i in range(info.inputs):
      inputs.append(Input(self, i))
    
    self.inputs = tuple(inputs)

    return res

  cpdef record(InputDevice self, DWORD freq = 0, DWORD chans = 0, DWORD flags = 0, object callback = None, DWORD period = 100):
    return Record.from_device(self, freq, chans, flags, callback, period)

  property name:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return info.name.decode('utf-8')

  property driver:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      if info.driver == NULL:
        return u''
      return info.driver.decode('utf-8')

  property enabled:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return <bint>(info.flags&_BASS_DEVICE_ENABLED)

  property default:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return <bint>(info.flags&_BASS_DEVICE_DEFAULT)

  property default_communication:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return <bint>(info.flags&_BASS_DEVICE_DEFAULTCOM)

  property initialized:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return <bint>(info.flags&_BASS_DEVICE_INIT)

  property loopback:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return <bint>(info.flags&_BASS_DEVICE_LOOPBACK)

  property type:
    def __get__(InputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()

      from ..constants import DEVICE_TYPE

      return DEVICE_TYPE(info.flags&_BASS_DEVICE_TYPE_MASK)

  property flags:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.set()
        info = self._get_info()
        self._evaluate()
        return info.flags

  property formats:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.formats & 0xffffff

  property channels:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.formats >> 24

  property single_input:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return <bint>info.singlein

  property frequency:
    def __get__(InputDevice self):
      cdef BASS_RECORDINFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.freq
