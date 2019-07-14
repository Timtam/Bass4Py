from libc.string cimport memmove
from . cimport bass
from . import basscallbacks
from .basschannel cimport BASSCHANNEL
from .basschannelattribute cimport BASSCHANNELATTRIBUTE
from .bassdevice cimport BASSDEVICE
from .exceptions import BassStreamError

include "transform.pxi"

cdef void CDOWNLOADPROC(const void *buffer, DWORD length, void *user) with gil:
  cdef BASSSTREAM strm = <BASSSTREAM?>user
  cdef bytes data = (<char *>buffer)[:length]
  strm.__downloadproc(strm, data)

cdef void __stdcall CDOWNLOADPROC_STD(const void *buffer, DWORD length, void *user) with gil:
  CDOWNLOADPROC(buffer, length, user)

cdef DWORD CSTREAMPROC(DWORD handle, void *buffer, DWORD length, void *user) with gil:
  cdef DWORD blen
  cdef object cb, pythonf
  cdef char *cbuf
  cdef int i
  cdef bytes pythonbuf
  cdef BASSSTREAM stream = BASSSTREAM(handle)
  cb = basscallbacks.Callbacks.GetCallback(<int>user)
  pythonf = cb['function'][0]
  pythonbuf = pythonf(stream, length, cb['user'])
  blen = len(pythonbuf)
  if <DWORD>blen > length:
    pythonbuf = pythonbuf[:length]
    blen=<int>length
  cbuf = <char*>pythonbuf
  memmove(buffer, <const void*>cbuf, blen)
  return blen

cdef DWORD __stdcall CSTREAMPROC_STD(DWORD handle, void *buffer, DWORD length, void *user) with gil:
  cdef DWORD res = CSTREAMPROC(handle, buffer, length, user)
  return res

cdef void CFILECLOSEPROC(void *user) with gil:
  cdef object cb
  cdef object pythonf
  cb = basscallbacks.Callbacks.GetCallback(<int>user)
  pythonf = cb['function'][0]
  pythonf(cb['user'])

cdef void __stdcall CFILECLOSEPROC_STD(void *user) with gil:
  CFILECLOSEPROC(user)

cdef QWORD CFILELENPROC(void *user) with gil:
  cdef object cb, pythonf
  cdef QWORD res
  cb = basscallbacks.Callbacks.GetCallback(<int>user)
  pythonf = cb['function'][2]
  res = pythonf(cb['user'])
  return res

cdef QWORD __stdcall CFILELENPROC_STD(void *user) with gil:
  cdef QWORD res = CFILELENPROC(user)
  return res

cdef DWORD CFILEREADPROC(void *buffer, DWORD length, void *user) with gil:
  cdef object cb, pythonf
  cdef bytes str
  cdef char *cbuf
  cdef DWORD blen
  cb = basscallbacks.Callbacks.GetCallback(<int>user)
  pythonf = cb['function'][1]
  str = pythonf(length, cb['user'])
  blen = <DWORD>len(str)
  if blen > length:
    str = str[:length]
    blen = length
  cbuf = <char*>str
  memmove(buffer, <const void*>cbuf, blen)
  return blen

cdef DWORD __stdcall CFILEREADPROC_STD(void *buffer, DWORD length, void *user) with gil:
  cdef DWORD res = CFILEREADPROC(buffer, length, user)
  return res

cdef bint CFILESEEKPROC(QWORD offset, void *user) with gil:
  cdef object cb, pythonf
  cdef bint res
  cb = basscallbacks.Callbacks.GetCallback(<int>user)
  pythonf = cb['function'][3]
  res = pythonf(offset, cb['user'])
  return res

cdef bint __stdcall CFILESEEKPROC_STD(QWORD offset, void *user) with gil:
  cdef bint res = CFILESEEKPROC(offset, user)
  return res

cdef class BASSSTREAM(BASSCHANNEL):

  cdef void __initattributes(BASSSTREAM self):
    BASSCHANNEL.__initattributes(self)
    self.Bitrate = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_BITRATE, True)
    self.NetResume = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_NET_RESUME)
    self.ScanInfo = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_SCANINFO)
  
  cpdef Free(BASSSTREAM self):
    cdef bint res = bass.BASS_StreamFree(self.__channel)
    bass.__Evaluate()
    return res

  cpdef QWORD GetFilePosition(BASSSTREAM self, DWORD mode):
    cdef QWORD res = bass.BASS_StreamGetFilePosition(self.__channel, mode)
    bass.__Evaluate()
    return res

  cpdef DWORD PutData(BASSSTREAM self, char *buffer, DWORD length):
    cdef DWORD res = bass.BASS_StreamPutData(self.__channel, <void*>buffer, length)
    bass.__Evaluate()
    return res

  cpdef DWORD PutFileData(BASSSTREAM self, char *buffer, DWORD length):
    cdef DWORD res = bass.BASS_StreamPutFileData(self.__channel, <void*>buffer, length)
    bass.__Evaluate()
    return res

  @staticmethod
  def FromFile(file, flags = 0, offset = 0, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD coffset = <QWORD?>offset
    cdef BASSDEVICE cdevice
    cdef const unsigned char[:] filename
    cdef HSTREAM strm
    
    if device != None:
      cdevice = <BASSDEVICE?>device
      cdevice.Set()

    filename = to_readonly_bytes(file)
    strm = bass.BASS_StreamCreateFile(False, &(filename[0]), coffset, 0, flags)
    bass.__Evaluate()
    
    return BASSSTREAM(strm)

  @staticmethod
  def FromBytes(data, flags = 0, length = 0, device = None):
    cdef BASSDEVICE cdevice
    cdef const unsigned char[:] cdata = data
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD clength = <QWORD?>length
    cdef HSTREAM strm
    
    if clength == 0 or clength > cdata.shape[0]:
      clength = cdata.shape[0]

    if device != None:
      cdevice = <BASSDEVICE?>device
      cdevice.Set()

    strm = bass.BASS_StreamCreateFile(True, &(cdata[0]), 0, clength, cflags)
    bass.__Evaluate()
    return BASSSTREAM(strm)

  @staticmethod
  def FromURL(url, flags = 0, offset = 0, callback = None, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD coffset = <QWORD?>offset
    cdef BASSDEVICE cdevice
    cdef const unsigned char[:] curl
    cdef HSTREAM strm
    cdef bass.DOWNLOADPROC *cproc
    cdef BASSSTREAM ostrm

    if callback != None:
      if not callable(callback):
        raise BassStreamError("callback needs to be callable")

      IF UNAME_SYSNAME == "Windows":
        cproc = <bass.DOWNLOADPROC*>CDOWNLOADPROC_STD
      ELSE:
        cproc = <bass.DOWNLOADPROC*>CDOWNLOADPROC

    else:
      cproc = NULL
    
    curl = to_readonly_bytes(url)

    if device != None:
      cdevice = <BASSDEVICE?>device
      cdevice.Set()

    ostrm = BASSSTREAM(0)

    if callback != None:
      ostrm.__downloadproc = callback

    strm = bass.BASS_StreamCreateURL((<char *>&(curl[0])), coffset, flags, cproc, <void*>ostrm)
    bass.__Evaluate()
    
    ostrm.__channel = strm
    ostrm.__initattributes()

    return ostrm

  property AutoFree:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_STREAM_AUTOFREE == bass._BASS_STREAM_AUTOFREE

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_STREAM_AUTOFREE, switch)

  property RestrictDownload:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_STREAM_RESTRATE == bass._BASS_STREAM_RESTRATE

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_STREAM_RESTRATE, switch)
