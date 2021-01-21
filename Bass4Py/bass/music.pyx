from ..bindings.bass cimport (
  _BASS_ATTRIB_MUSIC_ACTIVE,
  _BASS_ATTRIB_MUSIC_AMPLIFY,
  _BASS_ATTRIB_MUSIC_BPM,
  _BASS_ATTRIB_MUSIC_VOL_CHAN,
  _BASS_ATTRIB_MUSIC_VOL_GLOBAL,
  _BASS_ATTRIB_MUSIC_VOL_INST,
  _BASS_ATTRIB_MUSIC_PANSEP,
  _BASS_ATTRIB_MUSIC_PSCALER,
  _BASS_ATTRIB_MUSIC_SPEED,
  _BASS_MUSIC_FT2MOD,
  _BASS_MUSIC_NONINTER,
  _BASS_MUSIC_POSRESET,
  _BASS_MUSIC_POSRESETEX,
  _BASS_MUSIC_PT1MOD,
  _BASS_MUSIC_RAMP,
  _BASS_MUSIC_RAMPS,
  _BASS_MUSIC_SINCINTER,
  _BASS_MUSIC_STOPBACK,
  _BASS_MUSIC_SURROUND,
  _BASS_MUSIC_SURROUND2,
  BASS_ChannelUpdate,
  BASS_MusicFree,
  BASS_MusicLoad,
  )

from .channel cimport Channel
from .attribute cimport Attribute
from .output_device cimport OutputDevice

# optional add-ons
try:
  from Bass4Py.tags.tags import Tags
except ImportError:
  Tags = lambda obj: None

include "../transform.pxi"

cdef class Music(Channel):

  def __cinit__(Music self, HMUSIC handle):

    from ..constants import MUSIC

    self._flags_enum = MUSIC

  def __init__(self, *args, **kwargs):
  
    self.Tags = Tags(self)

  cdef void _initattributes(Music self):
    Channel._initattributes(self)

    self.Active = Attribute(self._channel, _BASS_ATTRIB_MUSIC_ACTIVE, True)
    self.Amplification = Attribute(self._channel, _BASS_ATTRIB_MUSIC_AMPLIFY)
    self.BPM = Attribute(self._channel, _BASS_ATTRIB_MUSIC_BPM)
    self.ChannelVolumes = Attribute(self._channel, _BASS_ATTRIB_MUSIC_VOL_CHAN)
    self.GlobalVolume = Attribute(self._channel, _BASS_ATTRIB_MUSIC_VOL_GLOBAL)
    self.InstrumentVolumes = Attribute(self._channel, _BASS_ATTRIB_MUSIC_VOL_INST)
    self.PanSeparation = Attribute(self._channel, _BASS_ATTRIB_MUSIC_PANSEP)
    self.PositionScaler = Attribute(self._channel, _BASS_ATTRIB_MUSIC_PSCALER)
    self.Speed = Attribute(self._channel, _BASS_ATTRIB_MUSIC_SPEED)

  cpdef Free(Music self):
    cdef bint res
    with nogil:
      res = BASS_MusicFree(self._channel)
    self._evaluate()
    return res
    
  cpdef Update(Music self, DWORD length):
    cdef bint res
    with nogil:
      res = BASS_ChannelUpdate(self._channel, length)
    self._evaluate()
    return res
  
  @staticmethod
  def FromBytes(data, flags = 0, length = 0, device_frequency = True, device = None):
    cdef OutputDevice cdevice
    cdef const unsigned char[:] cdata = data
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD clength = <QWORD?>length
    cdef HMUSIC msc
    cdef DWORD cfreq = 0
    
    if clength == 0 or clength > cdata.shape[0]:
      clength = cdata.shape[0]

    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    if device_frequency:
      cfreq = 1

    with nogil:
      msc = BASS_MusicLoad(True, &(cdata[0]), 0, clength, cflags, cfreq)
    Music._evaluate()
    return Music(msc)

  @staticmethod
  def FromFile(file, flags = 0, offset = 0, device_frequency = True, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD coffset = <QWORD?>offset
    cdef OutputDevice cdevice
    cdef const unsigned char[:] filename
    cdef HMUSIC msc
    cdef DWORD cfreq = 0
    
    if device != None:
      cdevice = <OutputDevice?>device
      cdevice.set()

    if device_frequency:
      cfreq = 1

    filename = to_readonly_bytes(file)
    with nogil:
      msc = BASS_MusicLoad(False, &(filename[0]), coffset, 0, cflags, cfreq)
    Music._evaluate()
    
    return Music(msc)

  property InterpolationNone:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_NONINTER == _BASS_MUSIC_NONINTER

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_NONINTER, switch)

  property InterpolationSinc:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_SINCINTER == _BASS_MUSIC_SINCINTER

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_SINCINTER, switch)

  property RampNormal:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_RAMP == _BASS_MUSIC_RAMP

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_RAMP, switch)

  property RampSensitive:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_RAMPS == _BASS_MUSIC_RAMPS

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_RAMPS, switch)

  property Surround:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_SURROUND == _BASS_MUSIC_SURROUND

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_SURROUND, switch)

  property Surround2:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_SURROUND2 == _BASS_MUSIC_SURROUND2

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_SURROUND2, switch)

  property ModFT2:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_FT2MOD == _BASS_MUSIC_FT2MOD

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_FT2MOD, switch)

  property ModPT1:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_PT1MOD == _BASS_MUSIC_PT1MOD

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_PT1MOD, switch)

  property StopSeeking:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_POSRESET == _BASS_MUSIC_POSRESET

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_POSRESET, switch)

  property StopAllSeeking:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_POSRESETEX == _BASS_MUSIC_POSRESETEX

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_POSRESETEX, switch)

  property StopBackward:
    def __get__(Channel self):
      return self._getflags()&_BASS_MUSIC_STOPBACK == _BASS_MUSIC_STOPBACK

    def __set__(Channel self, bint switch):
      self._setflags(_BASS_MUSIC_STOPBACK, switch)
