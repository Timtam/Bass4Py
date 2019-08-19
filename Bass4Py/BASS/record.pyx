from cpython cimport PyMem_Free, PyMem_Malloc

from . cimport bass
from .input_device cimport INPUT_DEVICE
from .plugin cimport PLUGIN
from .sample cimport SAMPLE
from ..constants import CHANNEL_TYPE
from ..exceptions import BassError, BassRecordError

cdef bint CRECORDPROC(HRECORD handle, const void *buffer, DWORD length, void *user) with gil:
  cdef RECORD rec = <RECORD>user
  cdef bytes data = (<char*>buffer)[:length]
  cdef bint res = <bint>(rec.__func(rec, data))
  return res

cdef bint __stdcall CRECORDPROC_STD(HRECORD handle, const void *buffer, DWORD length, void *user) with gil:
  return CRECORDPROC(handle, buffer, length, user)

cdef class RECORD:
  def __cinit__(RECORD self, HRECORD record):
    self.__record = record

    if record != 0:
      self.__initattributes()
      
  cdef void __initattributes(RECORD self):
    
    self.Frequency = ATTRIBUTE(self.__record, bass._BASS_ATTRIB_FREQ)
    self.Pan = ATTRIBUTE(self.__record, bass._BASS_ATTRIB_PAN)
    self.SRC = ATTRIBUTE(self.__record, bass._BASS_ATTRIB_SRC)
    self.Volume = ATTRIBUTE(self.__record, bass._BASS_ATTRIB_VOL)

  cdef BASS_CHANNELINFO __getinfo(RECORD self):
    cdef BASS_CHANNELINFO info
    cdef bint res
    res=bass.BASS_ChannelGetInfo(self.__record, &info)
    return info

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
    
    orec.__record = rec

    if callback:
      orec.__func = callback

    orec.__initattributes()

    return orec
  
  cpdef Pause(RECORD self):
    cdef bint res

    res = bass.BASS_ChannelPause(self.__record)
    bass.__Evaluate()
    return res

  cpdef Stop(RECORD self):
    cdef bint res
    res = bass.BASS_ChannelStop(self.__record)
    bass.__Evaluate()
    return res

  cpdef Start(RECORD self):
    cdef bint res
    res = bass.BASS_ChannelPlay(self.__record, True)
    bass.__Evaluate()
    return res

  cpdef Bytes2Seconds(RECORD self, QWORD bytes):
    cdef double secs
    secs = bass.BASS_ChannelBytes2Seconds(self.__record, bytes)
    bass.__Evaluate()
    return secs
  
  cpdef Seconds2Bytes(RECORD self, double secs):
    cdef QWORD bytes
    bytes = bass.BASS_ChannelSeconds2Bytes(self.__record, secs)
    bass.__Evaluate()
    return bytes

  cpdef GetData(RECORD self, DWORD length):
    cdef DWORD l = length&0xfffffff
    cdef void *buffer = <void*>PyMem_Malloc(l)
    cdef bytes b

    if buffer == NULL:
      raise MemoryError()
    
    l = bass.BASS_ChannelGetData(self.__record, buffer, length)
    try:
      bass.__Evaluate()
    except BassError as e:
      PyMem_Free(buffer)
      raise e
    b = (<char*>buffer)[:l]
    PyMem_Free(buffer)
    return b

  property DefaultFrequency:
    def __get__(RECORD self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.freq

  property Channels:
    def __get__(RECORD self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.chans

  property Flags:
    def __get__(RECORD self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.flags

  property Type:
    def __get__(RECORD self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return CHANNEL_TYPE(info.ctype)

  property Resolution:
    def __get__(RECORD self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      return info.origres

  property Plugin:
    def __get__(RECORD self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      if info.plugin:
        return PLUGIN(info.plugin)
      else:
        return None

  property Name:
    def __get__(RECORD self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()

      if info.filename == NULL:
        return u''
      return info.filename.decode('utf-8')

  property Sample:
    def __get__(RECORD self):
      cdef BASS_CHANNELINFO info = self.__getinfo()
      bass.__Evaluate()
      if info.sample:
        return SAMPLE(info.sample)
      else:
        return None

  @property
  def DataAvailable(RECORD self):
    cdef DWORD res
    res = bass.BASS_ChannelGetData(self.__record, NULL, bass._BASS_DATA_AVAILABLE)
    bass.__Evaluate()
    return res
