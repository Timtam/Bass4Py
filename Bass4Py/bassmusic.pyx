from . cimport bass
from .basschannel cimport BASSCHANNEL
from .basschannelattribute cimport BASSCHANNELATTRIBUTE

cdef class BASSMUSIC(BASSCHANNEL):

  cdef void __initattributes(BASSMUSIC self):
    BASSCHANNEL.__initattributes(self)

    self.Active = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_ACTIVE, True)
    self.Amplification = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_AMPLIFY)
    self.BPM = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_BPM)
    self.ChannelVolumes = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_VOL_CHAN)
    self.GlobalVolume = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_VOL_GLOBAL)
    self.InstrumentVolumes = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_VOL_INST)
    self.PanSeparation = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_PANSEP)
    self.PositionScaler = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_PSCALER)
    self.Speed = BASSCHANNELATTRIBUTE(self.__channel, bass._BASS_ATTRIB_MUSIC_SPEED)

  cpdef Free(BASSMUSIC self):
    cdef bint res = bass.BASS_MusicFree(self.__channel)
    bass.__Evaluate()
    return res
    
  property InterpolationNone:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_NONINTER == bass._BASS_MUSIC_NONINTER

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_NONINTER, switch)

  property InterpolationSinc:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_SINCINTER == bass._BASS_MUSIC_SINCINTER

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_SINCINTER, switch)

  property RampNormal:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_RAMP == bass._BASS_MUSIC_RAMP

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_RAMP, switch)

  property RampSensitive:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_RAMPS == bass._BASS_MUSIC_RAMPS

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_RAMPS, switch)

  property Surround:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_SURROUND == bass._BASS_MUSIC_SURROUND

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_SURROUND, switch)

  property Surround2:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_SURROUND2 == bass._BASS_MUSIC_SURROUND2

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_SURROUND2, switch)

  property ModFT2:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_FT2MOD == bass._BASS_MUSIC_FT2MOD

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_FT2MOD, switch)

  property ModPT1:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_PT1MOD == bass._BASS_MUSIC_PT1MOD

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_PT1MOD, switch)

  property StopSeeking:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_POSRESET == bass._BASS_MUSIC_POSRESET

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_POSRESET, switch)

  property StopAllSeeking:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_POSRESETEX == bass._BASS_MUSIC_POSRESETEX

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_POSRESETEX, switch)

  property StopBackward:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass._BASS_MUSIC_STOPBACK == bass._BASS_MUSIC_STOPBACK

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass._BASS_MUSIC_STOPBACK, switch)
