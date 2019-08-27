from . cimport bass
from .input cimport INPUT
from .record cimport RECORD
from ..constants import DEVICE_TYPE
from ..exceptions import BassAPIError, BassPlatformError

cdef class INPUT_DEVICE:
  def __cinit__(INPUT_DEVICE self, int device):
    self.__device=device
    self.Inputs = ()

  cdef BASS_DEVICEINFO __getdeviceinfo(INPUT_DEVICE self):
    cdef BASS_DEVICEINFO info
    bass.BASS_RecordGetDeviceInfo(self.__device, &info)
    return info

  cdef BASS_RECORDINFO __getinfo(INPUT_DEVICE self):
    cdef BASS_RECORDINFO info
    cdef bint res = bass.BASS_RecordGetInfo(&info)
    return info

  cpdef Set(INPUT_DEVICE self):
    cdef bint res 
    with nogil:
      res = bass.BASS_RecordSetDevice(self.__device)
    bass.__Evaluate()
    return res

  cpdef Free(INPUT_DEVICE self):
    cdef bint res
    self.Set()
    with nogil:
      res = bass.BASS_RecordFree()
    bass.__Evaluate()
    self.Inputs = ()
    return res

  cpdef Init(INPUT_DEVICE self):
    cdef BASS_RECORDINFO info
    cdef list inputs = []
    cdef bint res
    cdef int i

    res = bass.BASS_RecordInit(self.__device)
    bass.__Evaluate()

    info = self.__getinfo()
    bass.__Evaluate()
    
    IF UNAME_SYSNAME != "Darwin":
      inputs.append(INPUT(self, -1))
    
    for i in range(info.inputs):
      inputs.append(INPUT(self, i))
    
    self.Inputs = tuple(inputs)

    return res

  cpdef Record(INPUT_DEVICE self, DWORD freq = 0, DWORD chans = 0, DWORD flags = 0, object callback = None, DWORD period = 100):
    return RECORD.FromDevice(self, freq, chans, flags, callback, period)

  property Name:
    def __get__(INPUT_DEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      return info.name.decode('utf-8')

  property Driver:
    def __get__(INPUT_DEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      if info.driver == NULL:
        return u''
      return info.driver.decode('utf-8')

  property Enabled:
    def __get__(INPUT_DEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      return <bint>(info.flags&bass._BASS_DEVICE_ENABLED)

  property Default:
    def __get__(INPUT_DEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      return <bint>(info.flags&bass._BASS_DEVICE_DEFAULT)

  property Initialized:
    def __get__(INPUT_DEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      return <bint>(info.flags&bass._BASS_DEVICE_INIT)

  property Loopback:
    def __get__(INPUT_DEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      return <bint>(info.flags&bass._BASS_DEVICE_LOOPBACK)

  property Type:
    def __get__(INPUT_DEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      if info.flags&bass._BASS_DEVICE_TYPE_MASK:
        return DEVICE_TYPE(info.flags&bass._BASS_DEVICE_TYPE_MASK)
      return None

  property Flags:
    def __get__(INPUT_DEVICE self):
      cdef BASS_RECORDINFO info

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        info = self.__getinfo()
        bass.__Evaluate()
        return info.flags

  property Formats:
    def __get__(INPUT_DEVICE self):
      cdef BASS_RECORDINFO info
      self.Set()
      info = self.__getinfo()
      bass.__Evaluate()
      return info.formats & 0xffffff

  property Channels:
    def __get__(INPUT_DEVICE self):
      cdef BASS_RECORDINFO info
      self.Set()
      info = self.__getinfo()
      bass.__Evaluate()
      return info.formats >> 24

  property SingleInput:
    def __get__(INPUT_DEVICE self):
      cdef BASS_RECORDINFO info
      self.Set()
      info = self.__getinfo()
      bass.__Evaluate()
      return <bint>info.singlein

  property Frequency:
    def __get__(INPUT_DEVICE self):
      cdef BASS_RECORDINFO info
      self.Set()
      info = self.__getinfo()
      bass.__Evaluate()
      return info.freq
