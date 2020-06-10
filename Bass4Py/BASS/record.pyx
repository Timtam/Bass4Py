from . cimport bass
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

  cdef void _sethandle(Record self, HRECORD record):
    cdef DWORD dev

    ChannelBase._sethandle(self, record)

    dev = bass.BASS_ChannelGetDevice(self._channel)
    
    bass.__Evaluate()
    
    if dev == bass._BASS_NODEVICE:
      self._device = None
    else:
      self._device = InputDevice(dev)

  @staticmethod
  def FromDevice(device, freq = 0, chans = 0, flags = 0, callback = None, period = 100):
    cdef DWORD cfreq = <DWORD?>freq
    cdef DWORD cchans = <DWORD?>chans
    cdef DWORD cflags = <DWORD?>flags
    cdef DWORD cperiod = <DWORD?>period
    cdef InputDevice cdevice = <InputDevice?>device
    cdef bass.RECORDPROC *proc
    cdef HRECORD rec
    cdef Record orec
    
    if not callback:
      proc = NULL
    elif not callable(callback):
      raise BassRecordError("callback needs to be callable")
    else:
    
      IF UNAME_SYSNAME == "Windows":
        proc = <bass.RECORDPROC*>CRECORDPROC_STD
      ELSE:
        proc = <bass.RECORDPROC*>CRECORDPROC

    cdevice.Set()
    
    cflags = bass.MAKELONG(cflags, cperiod)
    
    orec = Record(0)

    with nogil:
      rec = bass.BASS_RecordStart(cfreq, cchans, cflags, proc, <void*>orec)

    bass.__Evaluate()
    
    orec._sethandle(rec)

    if callback:
      orec._func = callback

    return orec
  
  cpdef Start(Record self):
    cdef bint res
    with nogil:
      res = bass.BASS_ChannelPlay(self._channel, True)
    bass.__Evaluate()
    return res

  property Device:
    def __get__(Record self):
      return self._device

    def __set__(Record self, InputDevice dev):
      if dev is None:
        bass.BASS_ChannelSetDevice(self._channel, bass._BASS_NODEVICE)
      else:
        bass.BASS_ChannelSetDevice(self._channel, (<InputDevice?>dev)._device)

      bass.__Evaluate()

      if not dev:
        self._device = None
      else:
        self._device = (<InputDevice>dev)
