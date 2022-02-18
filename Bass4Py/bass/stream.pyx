from libc.string cimport memmove

from ..bindings.bass cimport (
  _BASS_ATTRIB_BITRATE,
  _BASS_ATTRIB_NET_RESUME,
  _BASS_ATTRIB_SCANINFO,
  _BASS_STREAM_AUTOFREE,
  _BASS_STREAM_RESTRATE,
  _STREAMFILE_BUFFER,
  _STREAMPROC_DEVICE,
  _STREAMPROC_DEVICE_3D,
  _STREAMPROC_PUSH,
  BASS_ChannelUpdate,
  BASS_FILEPROCS,
  BASS_StreamCreate,
  BASS_StreamCreateFile,
  BASS_StreamCreateFileUser,
  BASS_StreamCreateURL,
  BASS_StreamFree,
  BASS_StreamGetFilePosition,
  BASS_StreamPutData,
  BASS_StreamPutFileData,
  DOWNLOADPROC,
  FILECLOSEPROC,
  FILELENPROC,
  FILEREADPROC,
  FILESEEKPROC,
  STREAMPROC,
  )

from .channel cimport Channel
from .output_device cimport OutputDevice
from ..exceptions import BassStreamError
import os
import traceback
import warnings

from ..constants import STREAM
# optional add-ons
try:
  from Bass4Py.tags import Tags
except ImportError:
  Tags = lambda obj: None

include "../transform.pxi"

cdef void CDOWNLOADPROC(const void *buffer, DWORD length, void *user) with gil:
  cdef Stream strm = <Stream?>user
  cdef bytes data = (<char *>buffer)[:length]
  strm._downloadproc(strm, data)

cdef void __stdcall CDOWNLOADPROC_STD(const void *buffer, DWORD length, void *user) with gil:
  CDOWNLOADPROC(buffer, length, user)

cdef DWORD CSTREAMPROC(DWORD handle, void *buffer, DWORD length, void *user) with gil:
  cdef DWORD blen
  cdef Stream strm = <Stream?>user
  cdef bytes pbuf = strm._streamproc(strm, length)

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
  cdef Stream strm = <Stream?>user
  try:
    strm._file.close()
  except Exception:
    warnings.warn(traceback.format_exc(), RuntimeWarning)

cdef void __stdcall CFILECLOSEPROC_STD(void *user) with gil:
  CFILECLOSEPROC(user)

cdef QWORD CFILELENPROC(void *user) with gil:
  cdef Stream strm = <Stream?>user
  cdef Py_ssize_t current_pos
  cdef Py_ssize_t blen

  try:
    current_pos = strm._file.tell()
    strm._file.seek(0, os.SEEK_END)
    blen = strm._file.tell()
    strm._file.seek(current_pos, os.SEEK_SET)
    return <QWORD>blen
  except Exception:
    warnings.warn(traceback.format_exc(), RuntimeWarning)

cdef QWORD __stdcall CFILELENPROC_STD(void *user) with gil:
  return CFILELENPROC(user)

cdef DWORD CFILEREADPROC(void *buffer, DWORD length, void *user) with gil:
  cdef Stream strm = <Stream?>user
  cdef bytes data
  cdef DWORD blen

  try:
    data = strm._file.read(length)
    blen = len(data)

    if blen > length:
      data = data[:length]
      blen = length
    
    memmove(buffer, <char *>data, blen)
    return blen
  except Exception:
    warnings.warn(traceback.format_exc(), RuntimeWarning)
    return -1

cdef DWORD __stdcall CFILEREADPROC_STD(void *buffer, DWORD length, void *user) with gil:
  return CFILEREADPROC(buffer, length, user)

cdef bint CFILESEEKPROC(QWORD offset, void *user) with gil:
  cdef Stream strm = <Stream?>user
  try:
    strm._file.seek(offset, os.SEEK_SET)
    return True
  except Exception:
    warnings.warn(traceback.format_exc(), RuntimeWarning)
    return False

cdef bint __stdcall CFILESEEKPROC_STD(QWORD offset, void *user) with gil:
  return CFILESEEKPROC(offset, user)

cdef class Stream(Channel):

  def __cinit__(Stream self, HSTREAM handle):

    self._flags_enum = STREAM
    self.tags = Tags(self)

  cdef void _init_attributes(Stream self):
    Channel._init_attributes(self)
    self.bitrate = FloatAttribute(self._channel, _BASS_ATTRIB_BITRATE, True)
    self.net_resume = FloatAttribute(self._channel, _BASS_ATTRIB_NET_RESUME)
    self.scan_info = BytesAttribute(self._channel, _BASS_ATTRIB_SCANINFO)
  
  cpdef free(Stream self):
    cdef bint res
    super(Stream, self).free()
    with nogil:
      res = BASS_StreamFree(self._channel)
    self._evaluate()
    return res

  cpdef QWORD get_file_position(Stream self, DWORD mode):
    cdef QWORD res = BASS_StreamGetFilePosition(self._channel, mode)
    self._evaluate()
    return res

  cpdef DWORD put_data(Stream self, const unsigned char[:] buffer, DWORD length):
    cdef DWORD res
    with nogil:
      res = BASS_StreamPutData(self._channel, &(buffer[0]), length)
    self._evaluate()
    return res

  cpdef DWORD put_file_data(Stream self, const unsigned char[:] buffer, DWORD length):
    cdef DWORD res
    with nogil:
      res = BASS_StreamPutFileData(self._channel, &(buffer[0]), length)
    self._evaluate()
    return res

  cpdef update(Stream self, DWORD length):
    cdef bint res
    with nogil:
      res = BASS_ChannelUpdate(self._channel, length)
    self._evaluate()
    return res

  @staticmethod
  def from_file(file, flags = 0, offset = 0, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD coffset = <QWORD?>offset
    cdef OutputDevice cdevice
    cdef const unsigned char[:] filename
    cdef HSTREAM strm
    
    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    filename = to_readonly_bytes(file)
    strm = BASS_StreamCreateFile(False, &(filename[0]), coffset, 0, cflags)
    Stream._evaluate()
    
    return Stream(strm)

  @staticmethod
  def from_bytes(data, flags = 0, length = 0, device = None):
    cdef OutputDevice cdevice
    cdef const unsigned char[:] cdata = data
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD clength = <QWORD?>length
    cdef HSTREAM strm
    
    if clength == 0 or clength > cdata.shape[0]:
      clength = cdata.shape[0]

    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    strm = BASS_StreamCreateFile(True, &(cdata[0]), 0, clength, cflags)
    Stream._evaluate()
    return Stream(strm)

  @staticmethod
  def from_url(url, flags = 0, offset = 0, callback = None, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef DWORD coffset = <DWORD?>offset
    cdef OutputDevice cdevice
    cdef const unsigned char[:] curl
    cdef HSTREAM strm
    cdef DOWNLOADPROC *cproc
    cdef Stream ostrm

    if callback != None:
      if not callable(callback):
        raise BassStreamError("callback needs to be callable")

      IF UNAME_SYSNAME == "Windows":
        cproc = <DOWNLOADPROC*>CDOWNLOADPROC_STD
      ELSE:
        cproc = <DOWNLOADPROC*>CDOWNLOADPROC

    else:
      cproc = NULL
    
    curl = to_readonly_bytes(url)

    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    ostrm = Stream(0)

    if callback != None:
      ostrm._downloadproc = callback

    with nogil:
      strm = BASS_StreamCreateURL((<char *>(&curl[0])), coffset, cflags, cproc, <void*>ostrm)
    Stream._evaluate()
    
    ostrm._set_handle(strm)

    return ostrm

  @staticmethod
  def from_parameters(freq, chans, flags = 0, callback = None, device = None):
    cdef HSTREAM strm
    cdef DWORD cfreq = <DWORD?>freq
    cdef DWORD cchans = <DWORD?> chans
    cdef DWORD cflags = <DWORD?>flags
    cdef STREAMPROC *cproc
    cdef OutputDevice cdevice
    cdef Stream ostrm
    
    if callback != None:
      if not callable(callback):
        raise BassStreamError("callback needs to be callable")

      IF UNAME_SYSNAME == "Windows":
        cproc = <STREAMPROC*>CSTREAMPROC_STD
      ELSE:
        cproc = <STREAMPROC*>CSTREAMPROC

    else:
      cproc = <STREAMPROC*>_STREAMPROC_PUSH
    
    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    ostrm = Stream(0)
    
    if callback != None:
      ostrm._streamproc = callback
    
    with nogil:
      strm = BASS_StreamCreate(cfreq, cchans, cflags, cproc, <void*>ostrm)
    Stream._evaluate()
    
    ostrm._set_handle(strm)
    
    return ostrm

  @staticmethod
  def from_device(device):
    cdef HSTREAM strm
    cdef OutputDevice cdevice = <OutputDevice?>device
    
    cdevice.set()
    
    strm = BASS_StreamCreate(0, 0, 0, <STREAMPROC*>_STREAMPROC_DEVICE, NULL)
    Stream._evaluate()
    
    return Stream(strm)

  @staticmethod
  def from_device_3d(device):
    cdef HSTREAM strm
    cdef OutputDevice cdevice = <OutputDevice?>device
    
    cdevice.set()
    
    strm = BASS_StreamCreate(0, 0, 0, <STREAMPROC*>_STREAMPROC_DEVICE_3D, NULL)
    Stream._evaluate()
    
    return Stream(strm)

  @staticmethod
  def from_file_obj(obj, system = _STREAMFILE_BUFFER, flags = 0, device = None):
    cdef HSTREAM strm
    cdef DWORD cflags = <DWORD?>flags
    cdef DWORD csystem = <DWORD?>system
    cdef OutputDevice cdevice
    cdef Stream ostrm
    cdef BASS_FILEPROCS procs

    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    IF UNAME_SYSNAME == "Windows":
      procs.close = <FILECLOSEPROC*>CFILECLOSEPROC_STD
      procs.read = <FILEREADPROC*>CFILEREADPROC_STD
      procs.length = <FILELENPROC*>CFILELENPROC_STD
      procs.seek = <FILESEEKPROC*>CFILESEEKPROC_STD
    ELSE:
      procs.close = <FILECLOSEPROC*>CFILECLOSEPROC
      procs.read = <FILEREADPROC*>CFILEREADPROC
      procs.length = <FILELENPROC*>CFILELENPROC
      procs.seek = <FILESEEKPROC*>CFILESEEKPROC

    ostrm = Stream(0)
    ostrm._file = obj

    with nogil:
      strm = BASS_StreamCreateFileUser(csystem, cflags, &procs, (<void*>ostrm))
    Stream._evaluate()
    
    ostrm._set_handle(strm)
    
    return ostrm

  property auto_free:
    def __get__(Channel self):
      return self._get_flags()&_BASS_STREAM_AUTOFREE == _BASS_STREAM_AUTOFREE

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_STREAM_AUTOFREE, switch)

  property restrict_download:
    def __get__(Channel self):
      return self._get_flags()&_BASS_STREAM_RESTRATE == _BASS_STREAM_RESTRATE

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_STREAM_RESTRATE, switch)
