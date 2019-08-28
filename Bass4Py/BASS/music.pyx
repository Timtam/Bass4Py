from . cimport bass
from .channel cimport CHANNEL
from .attribute cimport ATTRIBUTE
from .output_device cimport OUTPUT_DEVICE
from ..constants import MUSIC as C_MUSIC

include "../transform.pxi"

cdef class MUSIC(CHANNEL):

  def __cinit__(MUSIC self, HMUSIC handle):
    self.__flags_enum = C_MUSIC

  cdef void __initattributes(MUSIC self):
    CHANNEL.__initattributes(self)

    self.Active = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_ACTIVE, True)
    self.Amplification = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_AMPLIFY)
    self.BPM = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_BPM)
    self.ChannelVolumes = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_VOL_CHAN)
    self.GlobalVolume = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_VOL_GLOBAL)
    self.InstrumentVolumes = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_VOL_INST)
    self.PanSeparation = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_PANSEP)
    self.PositionScaler = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_PSCALER)
    self.Speed = ATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_SPEED)

  cpdef Free(MUSIC self):
    cdef bint res
    with nogil:
      res = bass.BASS_MusicFree(self.__channel)
    bass.__Evaluate()
    return res
    
  @staticmethod
  def FromBytes(data, flags = 0, length = 0, device_frequency = True, device = None):
    cdef OUTPUT_DEVICE cdevice
    cdef const unsigned char[:] cdata = data
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD clength = <QWORD?>length
    cdef HMUSIC msc
    cdef DWORD cfreq = 0
    
    if clength == 0 or clength > cdata.shape[0]:
      clength = cdata.shape[0]

    if device != None:
      cdevice = <OUTPUT_DEVICE?>device
      cdevice.Set()

    if device_frequency:
      cfreq = 1

    with nogil:
      msc = bass.BASS_MusicLoad(True, &(cdata[0]), 0, clength, cflags, cfreq)
    bass.__Evaluate()
    return MUSIC(msc)

  @staticmethod
  def FromFile(file, flags = 0, offset = 0, device_frequency = True, device = None):
    cdef DWORD cflags = <DWORD?>flags
    cdef QWORD coffset = <QWORD?>offset
    cdef OUTPUT_DEVICE cdevice
    cdef const unsigned char[:] filename
    cdef HMUSIC msc
    cdef DWORD cfreq = 0
    
    if device != None:
      cdevice = <OUTPUT_DEVICE?>device
      cdevice.Set()

    if device_frequency:
      cfreq = 1

    filename = to_readonly_bytes(file)
    with nogil:
      msc = bass.BASS_MusicLoad(False, &(filename[0]), coffset, 0, cflags, cfreq)
    bass.__Evaluate()
    
    return MUSIC(msc)

  property InterpolationNone:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_NONINTER == bass._BASS_MUSIC_NONINTER

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_NONINTER, switch)

  property InterpolationSinc:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_SINCINTER == bass._BASS_MUSIC_SINCINTER

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_SINCINTER, switch)

  property RampNormal:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_RAMP == bass._BASS_MUSIC_RAMP

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_RAMP, switch)

  property RampSensitive:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_RAMPS == bass._BASS_MUSIC_RAMPS

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_RAMPS, switch)

  property Surround:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_SURROUND == bass._BASS_MUSIC_SURROUND

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_SURROUND, switch)

  property Surround2:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_SURROUND2 == bass._BASS_MUSIC_SURROUND2

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_SURROUND2, switch)

  property ModFT2:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_FT2MOD == bass._BASS_MUSIC_FT2MOD

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_FT2MOD, switch)

  property ModPT1:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_PT1MOD == bass._BASS_MUSIC_PT1MOD

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_PT1MOD, switch)

  property StopSeeking:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_POSRESET == bass._BASS_MUSIC_POSRESET

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_POSRESET, switch)

  property StopAllSeeking:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_POSRESETEX == bass._BASS_MUSIC_POSRESETEX

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_POSRESETEX, switch)

  property StopBackward:
    def __get__(CHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_STOPBACK == bass._BASS_MUSIC_STOPBACK

    def __set__(CHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_STOPBACK, switch)
