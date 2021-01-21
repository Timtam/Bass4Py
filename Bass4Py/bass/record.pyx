from ..bindings.bass cimport (
  _BASS_NODEVICE,
  BASS_ChannelGetDevice,
  BASS_ChannelPlay,
  BASS_ChannelSetDevice,
  BASS_RecordStart,
  MAKELONG,
  RECORDPROC,
  )

from ..exceptions import BassRecordError

cdef bint CRECORDPROC(HRECORD handle, const void *buffer, DWORD length, void *user) with gil:
  cdef Record rec = <Record>user
  cdef bytes data = (<char*>buffer)[:length]
  cdef bint res = <bint>(rec._func(rec, data))
  return res

cdef bint __stdcall CRECORDPROC_STD(HRECORD handle, const void *buffer, DWORD length, void *user) with gil:
  return CRECORDPROC(handle, buffer, length, user)

cdef class Record(ChannelBase):

  def __cinit__(Record self, HRECORD handle):

    from ..constants import STREAM

    self._flags_enum = STREAM

  cdef void _set_handle(Record self, HRECORD record):
    cdef DWORD dev

    ChannelBase._set_handle(self, record)

    dev = BASS_ChannelGetDevice(self._channel)
    
    self._evaluate()
    
    if dev == _BASS_NODEVICE:
      self._device = None
    else:
      self._device = InputDevice(dev)

  @staticmethod
  def from_device(device, freq = 0, chans = 0, flags = 0, callback = None, period = 100):
    cdef DWORD cfreq = <DWORD?>freq
    cdef DWORD cchans = <DWORD?>chans
    cdef DWORD cflags = <DWORD?>flags
    cdef DWORD cperiod = <DWORD?>period
    cdef InputDevice cdevice = <InputDevice?>device
    cdef RECORDPROC *proc
    cdef HRECORD rec
    cdef Record orec
    
    if not callback:
      proc = NULL
    elif not callable(callback):
      raise BassRecordError("callback needs to be callable")
    else:
    
      IF UNAME_SYSNAME == "Windows":
        proc = <RECORDPROC*>CRECORDPROC_STD
      ELSE:
        proc = <RECORDPROC*>CRECORDPROC

    cdevice.Set()
    
    cflags = MAKELONG(cflags, cperiod)
    
    orec = Record(0)

    with nogil:
      rec = BASS_RecordStart(cfreq, cchans, cflags, proc, <void*>orec)

    Record._evaluate()
    
    orec._set_handle(rec)

    if callback:
      orec._func = callback

    return orec
  
  cpdef start(Record self):
    cdef bint res
    with nogil:
      res = BASS_ChannelPlay(self._channel, True)
    self._evaluate()
    return res

  property device:
    def __get__(Record self):
      return self._device

    def __set__(Record self, InputDevice dev):
      if dev is None:
        BASS_ChannelSetDevice(self._channel, _BASS_NODEVICE)
      else:
        BASS_ChannelSetDevice(self._channel, (<InputDevice?>dev)._device)

      self._evaluate()

      if not dev:
        self._device = None
      else:
        self._device = (<InputDevice>dev)
