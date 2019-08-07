from libc.string cimport memmove
from . cimport bass
from .channel cimport CHANNEL
from .attribute cimport ATTRIBUTE
from .device cimport DEVICE
from ..exceptions import BassStreamError
from filelike import is_filelike
import os

include "../transform.pxi"

cdef void CDOWNLOADPROC(const void *buffer, DWORD length, void *user) with gil:
  cdef STREAM strm = <STREAM?>user
  cdef bytes data = (<char *>buffer)[:length]
  strm.__downloadproc(strm, data)

cdef void __stdcall CDOWNLOADPROC_STD(const void *buffer, DWORD length, void *user) with gil:
  CDOWNLOADPROC(buffer, length, user)

cdef DWORD CSTREAMPROC(DWORD handle, void *buffer, DWORD length, void *user) with gil:
  cdef DWORD blen
  cdef STREAM strm = <STREAM?>user
  cdef bytes pbuf = strm.__streamproc(strm, length)

  blen = len(pbuf)
  if blen > length:
    pbuf = pbuf[:length]
    blen=length

  memmove(buffer, <char *>pbuf, blen)
  return blen

cdef DWORD __stdcall CSTREAMPROC_STD(DWORD handle, void *buffer, DWORD length, void *user) with gil:
  cdef DWORD res = CSTREAMPROC(handle, buffer, length, user)
  return res

cdef void CFILECLOSEPROC(void *user) with gil:
  cdef STREAM strm = <STREAM?>user
  strm.__file.close()

cdef void __stdcall CFILECLOSEPROC_STD(void *user) with gil:
  CFILECLOSEPROC(user)

cdef QWORD CFILELENPROC(void *user) with gil:
  cdef STREAM strm = <STREAM?>user
  cdef Py_ssize_t current_pos = strm.__file.tell()
  cdef Py_ssize_t blen
  strm.__file.seek(0, os.SEEK_END)
  blen = strm.__file.tell()
  strm.__file.seek(current_pos, os.SEEK_SET)
  return <QWORD>blen

cdef QWORD __stdcall CFILELENPROC_STD(void *user) with gil:
  return CFILELENPROC(user)

cdef DWORD CFILEREADPROC(void *buffer, DWORD length, void *user) with gil:
  cdef STREAM strm = <STREAM?>user
  cdef bytes data = strm.__file.read(length)
  cdef DWORD blen = len(data)

  if blen > length:
    data = data[:length]
    blen = length
    
  memmove(buffer, <char *>data, blen)
  return blen

cdef DWORD __stdcall CFILEREADPROC_STD(void *buffer, DWORD length, void *user) with gil:
  return CFILEREADPROC(buffer, length, user)

cdef bint CFILESEEKPROC(QWORD offset, void *user) with gil:
  cdef STREAM strm = <STREAM?>user
  strm.__file.seek(offset, os.SEEK_SET)
  return True

cdef bint __stdcall CFILESEEKPROC_STD(QWORD offset, void *user) with gil:
  return CFILESEEKPROC(offset, user)

cdef class STREAM(CHANNEL):

  cdef void __initattributes(STREAM self):
    CHANNEL.__initattributes(self)
    self.Bitrate = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_BITRATE, True)
    self.NetResume = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_NET_RESUME)
    self.ScanInfo = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_SCANINFO)
  
  cpdef Free(STREAM self):
    cdef bint res = bass.BASS_StreamFree(self.__channel)
    bass.__Evaluate()
    return res

  cpdef QWORD GetFilePosition(STREAM self, DWORD mode):
    cdef QWORD res = bass.BASS_StreamGetFilePosition(self.__channel, mode)
    bass.__Evaluate()
    return res

  cpdef DWORD PutData(STREAM self, char *buffer, DWORD length):
    cdef DWORD res = bass.BASS_StreamPutData(self.__channel, <void*>buffer, length)
    bass.__Evaluate()
    return res

  cpdef DWORD PutFileData(STREAM self, char *buffer, DWORD length):
    cdef DWORD res = bass.BASS_StreamPutFileData(self.__channel, <void*>buffer, length)
    bass.__Evaluate()
    return res

  @staticmethod
  def FromFile(file, flags = 0, offset = 0, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD coffset = <QWORD?>offset
    cdef DEVICE cdevice
    cdef const unsigned char[:] filename
    cdef HSTREAM strm
    
    if device != None:
      cdevice = <DEVICE?>device
      cdevice.Set()

    filename = to_readonly_bytes(file)
    strm = bass.BASS_StreamCreateFile(False, &(filename[0]), coffset, 0, cflags)
    bass.__Evaluate()
    
    return STREAM(strm)

  @staticmethod
  def FromBytes(data, flags = 0, length = 0, device = None):
    cdef DEVICE cdevice
    cdef const unsigned char[:] cdata = data
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD clength = <QWORD?>length
    cdef HSTREAM strm
    
    if clength == 0 or clength > cdata.shape[0]:
      clength = cdata.shape[0]

    if device != None:
      cdevice = <DEVICE?>device
      cdevice.Set()

    strm = bass.BASS_StreamCreateFile(True, &(cdata[0]), 0, clength, cflags)
    bass.__Evaluate()
    return STREAM(strm)

  @staticmethod
  def FromURL(url, flags = 0, offset = 0, callback = None, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef DWORD coffset = <DWORD?>offset
    cdef DEVICE cdevice
    cdef const unsigned char[:] curl
    cdef HSTREAM strm
    cdef bass.DOWNLOADPROC *cproc
    cdef STREAM ostrm

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
      cdevice = <DEVICE?>device
      cdevice.Set()

    ostrm = STREAM(0)

    if callback != None:
      ostrm.__downloadproc = callback

    strm = bass.BASS_StreamCreateURL((<char *>&(curl[0])), coffset, flags, cproc, <void*>ostrm)
    bass.__Evaluate()
    
    ostrm.__channel = strm
    ostrm.__initattributes()

    return ostrm

  @staticmethod
  def FromParameters(freq, chans, flags = 0, callback = None, device = None):
    cdef HSTREAM strm
    cdef DWORD cfreq = <DWORD?>freq
    cdef DWORD cchans = <DWORD?> chans
    cdef DWORD cflags = <DWORD?>flags
    cdef bass.STREAMPROC *cproc
    cdef DEVICE cdevice
    cdef STREAM ostrm
    
    if callback != None:
      if not callable(callback):
        raise BassStreamError("callback needs to be callable")

      IF UNAME_SYSNAME == "Windows":
        cproc = <bass.STREAMPROC*>CSTREAMPROC_STD
      ELSE:
        cproc = <bass.STREAMPROC*>CSTREAMPROC

    else:
      cproc = <bass.STREAMPROC*>bass._STREAMPROC_PUSH
    
    if device != None:
      cdevice = <DEVICE?>device
      cdevice.Set()

    ostrm = STREAM(0)
    
    if callback != None:
      ostrm.__streamproc = callback
    
    strm = bass.BASS_StreamCreate(cfreq, cchans, cflags, cproc, <void*>ostrm)
    bass.__Evaluate()
    
    ostrm.__channel = strm
    ostrm.__initattributes()
    
    return ostrm

  @staticmethod
  def FromDevice(device):
    cdef HSTREAM strm
    cdef DEVICE cdevice = <DEVICE?>device
    
    cdevice.Set()
    
    strm = bass.BASS_StreamCreate(0, 0, 0, <bass.STREAMPROC*>bass._STREAMPROC_DEVICE, NULL)
    bass.__Evaluate()
    
    return STREAM(strm)

  @staticmethod
  def FromFileObj(obj, system = bass._STREAMFILE_BUFFER, flags = 0, device = None):
    cdef HSTREAM strm
    cdef DWORD cflags = <DWORD?>flags
    cdef DWORD csystem = <DWORD?>system
    cdef DEVICE cdevice
    cdef STREAM ostrm
    cdef bass.BASS_FILEPROCS procs

    if not is_filelike(obj):
      raise BassStreamError("the object provided doesn't expose a file-like interface")
      
    if device != None:
      cdevice = <DEVICE?>device
      cdevice.Set()

    IF UNAME_SYSNAME == "Windows":
      procs.close = <bass.FILECLOSEPROC*>CFILECLOSEPROC_STD
      procs.read = <bass.FILEREADPROC*>CFILEREADPROC_STD
      procs.length = <bass.FILELENPROC*>CFILELENPROC_STD
      procs.seek = <bass.FILESEEKPROC*>CFILESEEKPROC_STD
    ELSE:
      procs.close = <bass.FILECLOSEPROC*>CFILECLOSEPROC
      procs.read = <bass.FILEREADPROC*>CFILEREADPROC
      procs.length = <bass.FILELENPROC*>CFILELENPROC
      procs.seek = <bass.FILESEEKPROC*>CFILESEEKPROC

    ostrm = STREAM(0)
    ostrm.__file = obj

    with nogil:
      strm = bass.BASS_StreamCreateFileUser(csystem, cflags, &procs, (<void*>ostrm))
    bass.__Evaluate()
    
    ostrm.__channel = strm
    ostrm.__initattributes()
    
    return ostrm

  property AutoFree:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_STREAM_AUTOFREE == bass._BASS_STREAM_AUTOFREE

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_STREAM_AUTOFREE, switch)

  property RestrictDownload:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_STREAM_RESTRATE == bass._BASS_STREAM_RESTRATE

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_STREAM_RESTRATE, switch)
