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

from ..constants import MUSIC
from .channel cimport Channel
from .output_device cimport OutputDevice

# optional add-ons
try:
  from Bass4Py.tags import Tags
except ImportError:
  Tags = lambda obj: None

include "../transform.pxi"

cdef class Music(Channel):

  def __cinit__(Music self, HMUSIC handle):

    self._flags_enum = MUSIC
    self.tags = Tags(self)
  
  cdef void _init_attributes(Music self):
    Channel._init_attributes(self)

    self.active_channels = FloatAttribute(self._channel, _BASS_ATTRIB_MUSIC_ACTIVE, True)
    self.amplification = FloatAttribute(self._channel, _BASS_ATTRIB_MUSIC_AMPLIFY)
    self.bpm = FloatAttribute(self._channel, _BASS_ATTRIB_MUSIC_BPM)
    self.channel_volumes = FloatListAttribute(self._channel, _BASS_ATTRIB_MUSIC_VOL_CHAN)
    self.global_volume = FloatAttribute(self._channel, _BASS_ATTRIB_MUSIC_VOL_GLOBAL)
    self.instrument_volumes = FloatListAttribute(self._channel, _BASS_ATTRIB_MUSIC_VOL_INST)
    self.pan_separation = FloatAttribute(self._channel, _BASS_ATTRIB_MUSIC_PANSEP)
    self.position_scaler = FloatAttribute(self._channel, _BASS_ATTRIB_MUSIC_PSCALER)
    self.speed = FloatAttribute(self._channel, _BASS_ATTRIB_MUSIC_SPEED)

  cpdef free(Music self):
    cdef bint res
    super(Music, self).free()
    with nogil:
      res = BASS_MusicFree(self._channel)
    self._evaluate()
    return res
    
  cpdef update(Music self, DWORD length):
    cdef bint res
    with nogil:
      res = BASS_ChannelUpdate(self._channel, length)
    self._evaluate()
    return res
  
  @staticmethod
  def from_bytes(data, flags = 0, length = 0, device_frequency = True, device = None):
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
  def from_file(file, flags = 0, offset = 0, device_frequency = True, device = None):
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

  property interpolation_none:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_NONINTER == _BASS_MUSIC_NONINTER

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_NONINTER, switch)

  property interpolation_sinc:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_SINCINTER == _BASS_MUSIC_SINCINTER

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_SINCINTER, switch)

  property ramp_normal:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_RAMP == _BASS_MUSIC_RAMP

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_RAMP, switch)

  property ramp_sensitive:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_RAMPS == _BASS_MUSIC_RAMPS

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_RAMPS, switch)

  property surround:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_SURROUND == _BASS_MUSIC_SURROUND

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_SURROUND, switch)

  property surround2:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_SURROUND2 == _BASS_MUSIC_SURROUND2

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_SURROUND2, switch)

  property mod_ft2:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_FT2MOD == _BASS_MUSIC_FT2MOD

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_FT2MOD, switch)

  property mod_pt1:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_PT1MOD == _BASS_MUSIC_PT1MOD

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_PT1MOD, switch)

  property stop_when_seeking:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_POSRESET == _BASS_MUSIC_POSRESET

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_POSRESET, switch)

  property reset_when_seeking:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_POSRESETEX == _BASS_MUSIC_POSRESETEX

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_POSRESETEX, switch)

  property stop_backward:
    def __get__(Channel self):
      return self._get_flags()&_BASS_MUSIC_STOPBACK == _BASS_MUSIC_STOPBACK

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_MUSIC_STOPBACK, switch)
