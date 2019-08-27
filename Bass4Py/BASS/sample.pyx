from . cimport bass
from .channel cimport CHANNEL
from .output_device cimport OUTPUT_DEVICE
from ..exceptions import BassSampleError
from cpython.mem cimport PyMem_Malloc, PyMem_Free

include "../transform.pxi"

cdef class SAMPLE:
  def __cinit__(SAMPLE self, HSAMPLE sample):
    self.__sample = sample

  cdef BASS_SAMPLE __getinfo(SAMPLE self):
    cdef BASS_SAMPLE info
    cdef bint res = bass.BASS_SampleGetInfo(self.__sample, &info)
    return info

  cpdef Free(SAMPLE self):
    cdef bint res
    with nogil:
      res = bass.BASS_SampleFree(self.__sample)
    bass.__Evaluate()
    return res

  cpdef GetChannel(SAMPLE self, bint onlynew):
    cdef HCHANNEL res = bass.BASS_SampleGetChannel(self.__sample, onlynew)
    bass.__Evaluate()
    return CHANNEL(res)

  cpdef Stop(SAMPLE self):
    cdef bint res
    with nogil:
      res = bass.BASS_SampleStop(self.__sample)
    bass.__Evaluate()
    return res

  @staticmethod
  def FromParameters(length, freq, chans, max = 65535, flags = 0, device = None):
    cdef HSAMPLE samp
    cdef DWORD clength = <DWORD?>length
    cdef DWORD cfreq = <DWORD?>freq
    cdef DWORD cchans = <DWORD?>chans
    cdef DWORD cmax = <DWORD?>max
    cdef DWORD cflags = <DWORD?>flags
    cdef OUTPUT_DEVICE cdevice
    
    if device != None:
      cdevice = <OUTPUT_DEVICE?>device
      cdevice.Set()

    with nogil:
      samp = bass.BASS_SampleCreate(clength, cfreq, cchans, cmax, cflags)
    bass.__Evaluate()
    
    return SAMPLE(samp)

  @staticmethod
  def FromBytes(data, max = 65535, flags = 0, length = 0, device = None):
    cdef OUTPUT_DEVICE cdevice
    cdef const unsigned char[:] cdata = data
    cdef DWORD cflags = <DWORD?>flags
    cdef DWORD clength = <QWORD?>length
    cdef HSAMPLE samp
    cdef DWORD cmax = <DWORD?>max
    
    if clength == 0 or clength > cdata.shape[0]:
      clength = cdata.shape[0]

    if device != None:
      cdevice = <OUTPUT_DEVICE?>device
      cdevice.Set()

    with nogil:
      samp = bass.BASS_SampleLoad(True, &(cdata[0]), 0, clength, cmax, cflags)
    bass.__Evaluate()
    return SAMPLE(samp)

  @staticmethod
  def FromFile(file, max = 65535, flags = 0, offset = 0, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD coffset = <QWORD?>offset
    cdef OUTPUT_DEVICE cdevice
    cdef const unsigned char[:] filename
    cdef HSAMPLE samp
    cdef DWORD cmax = <DWORD?>max
    
    if device != None:
      cdevice = <OUTPUT_DEVICE?>device
      cdevice.Set()

    filename = to_readonly_bytes(file)
    with nogil:
      samp = bass.BASS_SampleLoad(False, &(filename[0]), coffset, 0, cmax, cflags)
    bass.__Evaluate()
    
    return SAMPLE(samp)

  property ChannelCount:
    def __get__(SAMPLE self):
      cdef DWORD res = bass.BASS_SampleGetChannels(self.__sample, NULL)
      bass.__Evaluate()
      return res

  property Frequency:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.freq

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.freq=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property Volume:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.volume

    def __set__(SAMPLE self, float value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.volume=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property Pan:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.pan

    def __set__(SAMPLE self, float value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.pan=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property Flags:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.flags

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.flags=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property Length:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.length

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.length=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property Max:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.max

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.max=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property Resolution:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.origres

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.origres=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property InitChannelCount:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.chans

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.chans=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property MinimumGap:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.mingap

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.mingap=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property Mode3D:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.mode3d

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.mode3d=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property MinimumDistance:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.mindist

    def __set__(SAMPLE self, float value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.mindist=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property MaximumDistance:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.maxdist

    def __set__(SAMPLE self, float value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.maxdist=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property InnerAngle:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.iangle

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.iangle=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property OuterAngle:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.oangle

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.oangle=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property OuterVolume:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.outvol

    def __set__(SAMPLE self, float value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.outvol=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property VAM:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.vam

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.vam=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property Priority:
    def __get__(SAMPLE self):
      cdef BASS_SAMPLE info = self.__getinfo()
      bass.__Evaluate()
      return info.priority

    def __set__(SAMPLE self, DWORD value):
      cdef BASS_SAMPLE info = self.__getinfo()
      info.priority=value
      bass.BASS_SampleSetInfo(self.__sample, &info)
      bass.__Evaluate()

  property Channels:
    def __get__(SAMPLE self):
      cdef int chans,i
      cdef HCHANNEL *channels
      cdef DWORD res
      cdef object ret=[]

      chans = self.InitChannelCount
      channels = <HCHANNEL*>PyMem_Malloc(chans*sizeof(HCHANNEL))

      if channels == NULL:
        return []

      res = bass.BASS_SampleGetChannels(self.__sample, channels)

      if res == -1:
        PyMem_Free(<void*>channels)
        bass.__Evaluate()

      for i in range(chans):
        ret.append(CHANNEL(channels[i]))

      PyMem_Free(<void*>channels)
      return ret

  property Data:
    def __get__(SAMPLE self):
      cdef int len
      cdef bint res
      cdef bytes ret
      cdef void *buffer
      cdef char *cbuffer

      len=self.Length
      buffer=PyMem_Malloc(len)

      if buffer == NULL:
        return b''

      res = bass.BASS_SampleGetData(self.__sample, buffer)

      if not res:
        PyMem_Free(buffer)
        bass.__Evaluate()

      cbuffer = <char*>buffer
      ret = cbuffer[:len-1]
      PyMem_Free(buffer)
      return ret

    def __set__(SAMPLE self, const unsigned char[:] data):
      cdef bint res

      if self.Length != data.shape[0]:
        raise BassSampleError("this sample requires data chunks of " + self.Length + " bytes")

      with nogil:
        res = bass.BASS_SampleSetData(self.__sample, &(data[0]))
      bass.__Evaluate()