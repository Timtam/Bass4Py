cimport bass
from basschannel cimport BASSCHANNEL
from basschannelattribute cimport BASSCHANNELATTRIBUTE

cdef class BASSMUSIC(BASSCHANNEL):
  cpdef Free(BASSMUSIC self):
    cdef bint res = bass.BASS_MusicFree(self.__channel)
    bass.__Evaluate()
    return res
    
  property Active:
    def __get__(BASSCHANNEL self):
      return BASSCHANNELATTRIBUTE(self.__channel, bass.BASS_ATTRIB_MUSIC_ACTIVE)

  property Amplify:
    def __get__(BASSCHANNEL self):
      return BASSCHANNELATTRIBUTE(self.__channel, bass.BASS_ATTRIB_MUSIC_AMPLIFY)

  property BPM:
    def __get__(BASSCHANNEL self):
      return BASSCHANNELATTRIBUTE(self.__channel, bass.BASS_ATTRIB_MUSIC_BPM)

  property PanSeparation:
    def __get__(BASSCHANNEL self):
      return BASSCHANNELATTRIBUTE(self.__channel, bass.BASS_ATTRIB_MUSIC_PANSEP)

  property Scaler:
    def __get__(BASSCHANNEL self):
      return BASSCHANNELATTRIBUTE(self.__channel, bass.BASS_ATTRIB_MUSIC_PSCALER)

  property Speed:
    def __get__(BASSCHANNEL self):
      return BASSCHANNELATTRIBUTE(self.__channel, bass.BASS_ATTRIB_MUSIC_SPEED)

  property ChannelVolumes:
    def __get__(BASSCHANNEL self):
      return BASSCHANNELATTRIBUTE(self.__channel, bass.BASS_ATTRIB_MUSIC_VOL_CHAN)

  property GlobalVolume:
    def __get__(BASSCHANNEL self):
      return BASSCHANNELATTRIBUTE(self.__channel, bass.BASS_ATTRIB_MUSIC_VOL_GLOBAL)

  property InstrumentVolumes:
    def __get__(BASSCHANNEL self):
      return BASSCHANNELATTRIBUTE(self.__channel, bass.BASS_ATTRIB_MUSIC_VOL_INST)

  property InterpolationNone:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_NONINTER == bass.BASS_MUSIC_NONINTER

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_NONINTER, switch)

  property InterpolationSinc:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_SINCINTER == bass.BASS_MUSIC_SINCINTER

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_SINCINTER, switch)

  property RampNormal:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_RAMP == bass.BASS_MUSIC_RAMP

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_RAMP, switch)

  property RampSensitive:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_RAMPS == bass.BASS_MUSIC_RAMPS

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_RAMPS, switch)

  property Surround:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_SURROUND == bass.BASS_MUSIC_SURROUND

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_SURROUND, switch)

  property Surround2:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_SURROUND2 == bass.BASS_MUSIC_SURROUND2

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_SURROUND2, switch)

  property ModFT2:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_FT2MOD == bass.BASS_MUSIC_FT2MOD

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_FT2MOD, switch)

  property ModPT1:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_PT1MOD == bass.BASS_MUSIC_PT1MOD

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_PT1MOD, switch)

  property StopSeeking:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_POSRESET == bass.BASS_MUSIC_POSRESET

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_POSRESET, switch)

  property StopAllSeeking:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_POSRESETEX == bass.BASS_MUSIC_POSRESETEX

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_POSRESETEX, switch)

  property StopBackward:
    def __get__(BASSCHANNEL self):
      return self.__getflags()&bass.BASS_MUSIC_STOPBACK == bass.BASS_MUSIC_STOPBACK

    def __set__(BASSCHANNEL self, bint switch):
      self.__setflags(bass.BASS_MUSIC_STOPBACK, switch)
