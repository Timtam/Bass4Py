from . cimport bass
from .channel_base cimport CHANNEL_BASE
from .input_device cimport INPUT_DEVICE
from ..exceptions import BassError, BassRecordError

cdef bint CRECORDPROC(HRECORD handle, const void *buffer, DWORD length, void *user) with gil:
  cdef RECORD rec = <RECORD>user
  cdef bytes data = (<char*>buffer)[:length]
  cdef bint res = <bint>(rec.__func(rec, data))
  return res

cdef bint __stdcall CRECORDPROC_STD(HRECORD handle, const void *buffer, DWORD length, void *user) with gil:
  return CRECORDPROC(handle, buffer, length, user)

cdef class RECORD(CHANNEL_BASE):
  cdef void __sethandle(RECORD self, HRECORD record):
    cdef DWORD dev

    CHANNEL_BASE.__sethandle(self, record)

    dev = bass.BASS_ChannelGetDevice(self.__channel)
    
    bass.__Evaluate()
    
    if dev == bass._BASS_NODEVICE:
      self.__device = None
    else:
      self.__device = INPUT_DEVICE(dev)

  @staticmethod
  def FromDevice(device, freq = 0, chans = 0, flags = 0, callback = None, period = 100):
    cdef DWORD cfreq = <DWORD?>freq
    cdef DWORD cchans = <DWORD?>chans
    cdef DWORD cflags = <DWORD?>flags
    cdef DWORD cperiod = <DWORD?>period
    cdef INPUT_DEVICE cdevice = <INPUT_DEVICE?>device
    cdef bass.RECORDPROC *proc
    cdef HRECORD rec
    cdef RECORD orec
    
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
    
    orec = RECORD(0)

    rec = bass.BASS_RecordStart(cfreq, cchans, cflags, proc, <void*>orec)

    bass.__Evaluate()
    
    orec.__sethandle(rec)

    if callback:
      orec.__func = callback

    return orec
  
  cpdef Start(RECORD self):
    cdef bint res
    res = bass.BASS_ChannelPlay(self.__channel, True)
    bass.__Evaluate()
    return res

  property Device:
    def __get__(RECORD self):
      return self.__device

    def __set__(RECORD self, INPUT_DEVICE dev):
      if dev is None:
        bass.BASS_ChannelSetDevice(self.__record, bass._BASS_NODEVICE)
      else:
        bass.BASS_ChannelSetDevice(self.__record, (<INPUT_DEVICE?>dev).__device)

      bass.__Evaluate()

      if not dev:
        self.__device = None
      else:
        self.__device = (<INPUT_DEVICE>dev)
