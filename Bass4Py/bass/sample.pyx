from ..evaluable cimport Evaluable
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

cdef class Sample(Evaluable):
  def __cinit__(Sample self, HSAMPLE sample):
    cdef DWORD dev

    self._sample = sample

    dev = BASS_ChannelGetDevice(self._sample)
    
    self._evaluate()
    
    if dev == _BASS_NODEVICE:
      self._device = None
    else:
      self._device = OutputDevice(dev)

  cdef BASS_SAMPLE _get_info(Sample self):
    cdef BASS_SAMPLE info
    cdef bint res = BASS_SampleGetInfo(self._sample, &info)
    return info

  cpdef free(Sample self):
    cdef bint res
    with nogil:
      res = BASS_SampleFree(self._sample)
    self._evaluate()
    return res

  cpdef get_channel(Sample self, bint only_new):
    cdef HCHANNEL res = BASS_SampleGetChannel(self._sample, only_new)
    self._evaluate()
    return Channel(res)

  cpdef stop(Sample self):
    cdef bint res
    with nogil:
      res = BASS_SampleStop(self._sample)
    self._evaluate()
    return res

  @staticmethod
  def from_parameters(length, freq, chans, max = 65535, flags = 0, device = None):
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
  def from_bytes(data, max = 65535, flags = 0, length = 0, device = None):
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
  def from_file(file, max = 65535, flags = 0, offset = 0, device = None):
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

  cpdef bytes_to_seconds(Sample self, QWORD bytes):
    cdef double secs
    secs = BASS_ChannelBytes2Seconds(self._sample, bytes)
    self._evaluate()
    return secs
  
  cpdef seconds_to_bytes(Sample self, double secs):
    cdef QWORD bytes
    bytes = BASS_ChannelSeconds2Bytes(self._sample, secs)
    self._evaluate()
    return bytes

  cpdef get_length(Sample self, DWORD mode = _BASS_POS_BYTE):
    cdef QWORD res = BASS_ChannelGetLength(self._sample, mode)
    self._evaluate()
    return res

  property channel_count:
    def __get__(Sample self):
      cdef DWORD res = BASS_SampleGetChannels(self._sample, NULL)
      self._evaluate()
      return res

  property frequency:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.freq

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.freq=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property volume:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.volume

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._get_info()
      info.volume=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property pan:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.pan

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._get_info()
      info.pan=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property flags:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return Sample(info.flags)

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.flags=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property length:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.length

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.length=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property max:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.max

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.max=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property resolution:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.origres

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.origres=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property init_channel_count:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.chans

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.chans=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property minimum_gap:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.mingap

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.mingap=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property mode_3d:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.mode3d

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.mode3d=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property minimum_distance:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.mindist

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._get_info()
      info.mindist=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property maximum_distance:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.maxdist

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._get_info()
      info.maxdist=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property inner_angle:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.iangle

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.iangle=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property outer_angle:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.oangle

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.oangle=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property outer_volume:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.outvol

    def __set__(Sample self, float value):
      cdef BASS_SAMPLE info = self._get_info()
      info.outvol=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property vam:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.vam

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.vam=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property priority:
    def __get__(Sample self):
      cdef BASS_SAMPLE info = self._get_info()
      self._evaluate()
      return info.priority

    def __set__(Sample self, DWORD value):
      cdef BASS_SAMPLE info = self._get_info()
      info.priority=value
      BASS_SampleSetInfo(self._sample, &info)
      self._evaluate()

  property channels:
    def __get__(Sample self):
      cdef int chans,i
      cdef HCHANNEL *channels
      cdef DWORD res
      cdef object ret=[]

      chans = self.init_channel_count
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

  property data:
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

  property device:
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
