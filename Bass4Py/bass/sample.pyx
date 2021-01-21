from .._evaluable cimport _Evaluable
from ..bindings.bass cimport (
  _BASS_NODEVICE,
  _BASS_POS_BYTE,
  BASS_ChannelBytes2Seconds,
  BASS_ChannelGetDevice,
  BASS_ChannelGetLength,
  BASS_ChannelSeconds2Bytes,
  BASS_ChannelSetDevice,
  BASS_SampleCreate,
  BASS_SampleFree,
  BASS_SampleGetChannel,
  BASS_SampleGetChannels,
  BASS_SampleGetData,
  BASS_SampleGetInfo,
  BASS_SampleLoad,
  BASS_SampleSetData,
  BASS_SampleSetInfo,
  BASS_SampleStop)

from .channel cimport Channel
from ..exceptions import BassSampleError
from cpython.mem cimport PyMem_Malloc, PyMem_Free

include "../transform.pxi"

cdef class Sample(_Evaluable):
  def __cinit__(Sample self, HSAMPLE sample):
    cdef DWORD dev

    self._sample = sample

    dev = BASS_ChannelGetDevice(self._sample)
    
    self._evaluate()
    
    if dev == _BASS_NODEVICE:
      self._device = None
    else:
      self._device = OutputDevice(dev)

  cdef BASS_SAMPLE _getinfo(Sample self):
    cdef BASS_SAMPLE info
    cdef bint res = BASS_SampleGetInfo(self._sample, &info)
    return info

  cpdef Free(Sample self):
    cdef bint res
    with nogil:
      res = BASS_SampleFree(self._sample)
    self._evaluate()
    return res

  cpdef GetChannel(Sample self, bint onlynew):
    cdef HCHANNEL res = BASS_SampleGetChannel(self._sample, onlynew)
    self._evaluate()
    return Channel(res)

  cpdef Stop(Sample self):
    cdef bint res
    with nogil:
      res = BASS_SampleStop(self._sample)
    self._evaluate()
    return res

  @staticmethod
  def FromParameters(length, freq, chans, max = 65535, flags = 0, device = None):
    cdef HSAMPLE samp
    cdef DWORD clength = <DWORD?>length
    cdef DWORD cfreq = <DWORD?>freq
    cdef DWORD cchans = <DWORD?>chans
    cdef DWORD cmax = <DWORD?>max
    cdef DWORD cflags = <DWORD?>flags
    cdef OutputDevice cdevice
    
    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    with nogil:
      samp = BASS_SampleCreate(clength, cfreq, cchans, cmax, cflags)
    Sample._evaluate()
    
    return Sample(samp)

  @staticmethod
  def FromBytes(data, max = 65535, flags = 0, length = 0, device = None):
    cdef OutputDevice cdevice
    cdef const unsigned char[:] cdata = data
    cdef DWORD cflags = <DWORD?>flags
    cdef DWORD clength = <QWORD?>length
    cdef HSAMPLE samp
    cdef DWORD cmax = <DWORD?>max
    
    if clength == 0 or clength > cdata.shape[0]:
      clength = cdata.shape[0]

    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    with nogil:
      samp = BASS_SampleLoad(True, &(cdata[0]), 0, clength, cmax, cflags)
    Sample._evaluate()
    return Sample(samp)

  @staticmethod
  def FromFile(file, max = 65535, flags = 0, offset = 0, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD coffset = <QWORD?>offset
    cdef OutputDevice cdevice
    cdef const unsigned char[:] filename
    cdef HSAMPLE samp
    cdef DWORD cmax = <DWORD?>max
    
    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    filename = to_readonly_bytes(file)
    with nogil:
      samp = BASS_SampleLoad(False, &(filename[0]), coffset, 0, cmax, cflags)
    Sample._evaluate()
    
    return Sample(samp)

  cpdef Bytes2Seconds(Sample self, QWORD bytes):
    cdef double secs
    secs = BASS_ChannelBytes2Seconds(self._sample, bytes)
    self._evaluate()
    return secs
  
  cpdef Seconds2Bytes(Sample self, double secs):
    cdef QWORD bytes
    bytes = BASS_ChannelSeconds2Bytes(self._sample, secs)
    self._evaluate()
    return bytes

  cpdef GetLength(Sample self, DWORD mode = _BASS_POS_BYTE):
    cdef QWORD res = BASS_ChannelGetLength(self._sample, mode)
    self._evaluate()
    return res

  property ChannelCount:
    def __get__(Sample self):
      cdef DWORD res = BASS_SampleGetChannels(self._sample, NULL)
      self._evaluate()
      return res

  property Frequency:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.freq

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.freq=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property Volume:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.volume

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.volume=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property Pan:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.pan

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.pan=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property Flags:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return Sample(info.flags)

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.flags=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property Length:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.length

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.length=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property Max:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.max

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.max=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property Resolution:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.origres

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.origres=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property InitChannelCount:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.chans

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.chans=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property MinimumGap:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.mingap

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.mingap=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property Mode3D:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.mode3d

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.mode3d=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property MinimumDistance:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.mindist

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.mindist=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property MaximumDistance:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.maxdist

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.maxdist=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property InnerAngle:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.iangle

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.iangle=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property OuterAngle:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.oangle

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.oangle=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property OuterVolume:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.outvol

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.outvol=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property VAM:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.vam

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.vam=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property Priority:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._getinfo()
      self._evaluate()
      return info.priority

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._getinfo()
      info.priority=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property Channels:
    def __get__(Sample self):
      cdef int chans,i
      cdef HCHANNEL *channels
      cdef DWORD res
      cdef object ret=[]

      chans = self.InitChannelCount
      channels = <HCHANNEL*>PyMem_Malloc(chans*sizeof(HCHANNEL))

      if channels == NULL:
        return []

      res = BASS_SampleGetChannels(self._sample, channels)

      if res == -1:
        PyMem_Free(<void*>channels)
        self._evaluate()

      for i in range(chans):
        ret.append(Channel(channels[i]))

      PyMem_Free(<void*>channels)
      return ret

  property Data:
    def __get__(Sample self):
      cdef int len
      cdef bint res
      cdef bytes ret
      cdef void *buffer
      cdef char *cbuffer

      len=self.Length
      buffer=PyMem_Malloc(len)

      if buffer == NULL:
        return b''

      res = BASS_SampleGetData(self._sample, buffer)

      if not res:
        PyMem_Free(buffer)
        self._evaluate()

      cbuffer = <char*>buffer
      ret = cbuffer[:len-1]
      PyMem_Free(buffer)
      return ret

    def __set__(Sample self, const unsigned char[:] data):
      cdef bint res

      if self.Length != data.shape[0]:
        raise BassSampleError("this sample requires data chunks of " + self.Length + " bytes")

      with nogil:
        res = BASS_SampleSetData(self._sample, &(data[0]))
      self._evaluate()

  property Device:
    def __get__(Sample self):
      return self._device

    def __set__(Sample self, OutputDevice dev):
      if dev is None:
        BASS_ChannelSetDevice(self._sample, _BASS_NODEVICE)
      else:
        BASS_ChannelSetDevice(self._sample, (<OutputDevice?>dev)._device)

      self._evaluate()

      if not dev:
        self._device = None
      else:
        self._device = (<OutputDevice>dev)
