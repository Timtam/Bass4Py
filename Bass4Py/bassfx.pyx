cimport bass
from basschannel cimport BASSCHANNEL
cpdef BASSFX_Create(DWORD channel,HFX fx,DWORD type):
 if type==bass.BASS_FX_DX8_CHORUS:
  return BASSFX_DX8CHORUS(channel,fx,type)
 elif type==bass.BASS_FX_DX8_COMPRESSOR:
  return BASSFX_DX8COMPRESSOR(channel,fx,type)
 elif type==bass.BASS_FX_DX8_DISTORTION:
  return BASSFX_DX8DISTORTION(channel,fx,type)
 elif type==bass.BASS_FX_DX8_ECHO:
  return BASSFX_DX8ECHO(channel,fx,type)
 elif type==bass.BASS_FX_DX8_FLANGER:
  return BASSFX_DX8FLANGER(channel,fx,type)
 elif type==bass.BASS_FX_DX8_GARGLE:
  return BASSFX_DX8GARGLE(channel,fx,type)
 elif type==bass.BASS_FX_DX8_I3DL2REVERB:
  return BASSFX_DX8I3DL2REVERB(channel,fx,type)
 elif type==bass.BASS_FX_DX8_PARAMEQ:
  return BASSFX_DX8PARAMEQ(channel,fx,type)
 elif type==bass.BASS_FX_DX8_REVERB:
  return BASSFX_DX8REVERB(channel,fx,type)
 return BASSFX(channel,fx,type)
cdef class BASSFX:
 def __cinit__(BASSFX self,DWORD channel,HFX fx,DWORD type):
  self.__channel=channel
  self.__fx=fx
  self.__type=type
 cpdef Remove(BASSFX self):
  cdef bint res
  res=bass.BASS_ChannelRemoveFX(self.__channel,self.__fx)
  bass.__Evaluate()
  return res
 cpdef Reset(BASSFX self):
  cdef bint res=bass.BASS_FXReset(self.__fx)
  bass.__Evaluate()
  return res
 property Channel:
  def __get__(BASSFX self):
   return BASSCHANNEL(self.__channel)
cdef class BASSFX_DX8CHORUS(BASSFX):
 property WetDryMix:
  def __get__(BASSFX_DX8CHORUS self):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fWetDryMix
  def __set__(BASSFX_DX8CHORUS self,float value):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fWetDryMix=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Depth:
  def __get__(BASSFX_DX8CHORUS self):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fDepth
  def __set__(BASSFX_DX8CHORUS self,float value):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fDepth=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Feedback:
  def __get__(BASSFX_DX8CHORUS self):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fFeedback
  def __set__(BASSFX_DX8CHORUS self,float value):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fFeedback=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Frequency:
  def __get__(BASSFX_DX8CHORUS self):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fFrequency
  def __set__(BASSFX_DX8CHORUS self,float value):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fFrequency=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Waveform:
  def __get__(BASSFX_DX8CHORUS self):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.lWaveform
  def __set__(BASSFX_DX8CHORUS self,DWORD value):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.lWaveform=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Delay:
  def __get__(BASSFX_DX8CHORUS self):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fDelay
  def __set__(BASSFX_DX8CHORUS self,float value):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fDelay=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Phase:
  def __get__(BASSFX_DX8CHORUS self):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.lPhase
  def __set__(BASSFX_DX8CHORUS self,DWORD value):
   cdef BASS_DX8_CHORUS effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.lPhase=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
cdef class BASSFX_DX8COMPRESSOR(BASSFX):
 property Gain:
  def __get__(BASSFX_DX8COMPRESSOR self):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fGain
  def __set__(BASSFX_DX8COMPRESSOR self,float value):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fGain=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Attack:
  def __get__(BASSFX_DX8COMPRESSOR self):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fAttack
  def __set__(BASSFX_DX8COMPRESSOR self,float value):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fAttack=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Release:
  def __get__(BASSFX_DX8COMPRESSOR self):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fRelease
  def __set__(BASSFX_DX8COMPRESSOR self,float value):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fRelease=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Threshold:
  def __get__(BASSFX_DX8COMPRESSOR self):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fThreshold
  def __set__(BASSFX_DX8COMPRESSOR self,float value):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fThreshold=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Ratio:
  def __get__(BASSFX_DX8COMPRESSOR self):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fRatio
  def __set__(BASSFX_DX8COMPRESSOR self,float value):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fRatio=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Predelay:
  def __get__(BASSFX_DX8COMPRESSOR self):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fPredelay
  def __set__(BASSFX_DX8COMPRESSOR self,float value):
   cdef BASS_DX8_COMPRESSOR effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fPredelay=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
cdef class BASSFX_DX8DISTORTION(BASSFX):
 property Gain:
  def __get__(BASSFX_DX8DISTORTION self):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fGain
  def __set__(BASSFX_DX8DISTORTION self,float value):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fGain=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Edge:
  def __get__(BASSFX_DX8DISTORTION self):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fEdge
  def __set__(BASSFX_DX8DISTORTION self,float value):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fEdge=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property PostEQCenterFrequency:
  def __get__(BASSFX_DX8DISTORTION self):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fPostEQCenterFrequency
  def __set__(BASSFX_DX8DISTORTION self,float value):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fPostEQCenterFrequency=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property PostEQBandwidth:
  def __get__(BASSFX_DX8DISTORTION self):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fPostEQBandwidth
  def __set__(BASSFX_DX8DISTORTION self,float value):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fPostEQBandwidth=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property PreLowcutCutoff:
  def __get__(BASSFX_DX8DISTORTION self):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fPreLowcutCutoff
  def __set__(BASSFX_DX8DISTORTION self,float value):
   cdef BASS_DX8_DISTORTION effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fPreLowcutCutoff=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
cdef class BASSFX_DX8ECHO(BASSFX):
 property WetDryMix:
  def __get__(BASSFX_DX8ECHO self):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fWetDryMix
  def __set__(BASSFX_DX8ECHO self,float value):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fWetDryMix=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Feedback:
  def __get__(BASSFX_DX8ECHO self):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fFeedback
  def __set__(BASSFX_DX8ECHO self,float value):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fFeedback=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property LeftDelay:
  def __get__(BASSFX_DX8ECHO self):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fLeftDelay
  def __set__(BASSFX_DX8ECHO self,float value):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fLeftDelay=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property RightDelay:
  def __get__(BASSFX_DX8ECHO self):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fRightDelay
  def __set__(BASSFX_DX8ECHO self,float value):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fRightDelay=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property PanDelay:
  def __get__(BASSFX_DX8ECHO self):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.lPanDelay
  def __set__(BASSFX_DX8ECHO self,bint value):
   cdef BASS_DX8_ECHO effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.lPanDelay=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
cdef class BASSFX_DX8FLANGER(BASSFX):
 property WetDryMix:
  def __get__(BASSFX_DX8FLANGER self):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fWetDryMix
  def __set__(BASSFX_DX8FLANGER self,float value):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fWetDryMix=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Depth:
  def __get__(BASSFX_DX8FLANGER self):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fDepth
  def __set__(BASSFX_DX8FLANGER self,float value):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fDepth=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Feedback:
  def __get__(BASSFX_DX8FLANGER self):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fFeedback
  def __set__(BASSFX_DX8FLANGER self,float value):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fFeedback=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Frequency:
  def __get__(BASSFX_DX8FLANGER self):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fFrequency
  def __set__(BASSFX_DX8FLANGER self,float value):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fFrequency=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Waveform:
  def __get__(BASSFX_DX8FLANGER self):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.lWaveform
  def __set__(BASSFX_DX8FLANGER self,DWORD value):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.lWaveform=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Delay:
  def __get__(BASSFX_DX8FLANGER self):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fDelay
  def __set__(BASSFX_DX8FLANGER self,float value):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fDelay=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Phase:
  def __get__(BASSFX_DX8FLANGER self):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.lPhase
  def __set__(BASSFX_DX8FLANGER self,DWORD value):
   cdef BASS_DX8_FLANGER effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.lPhase=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
cdef class BASSFX_DX8GARGLE(BASSFX):
 property RateHz:
  def __get__(BASSFX_DX8GARGLE self):
   cdef BASS_DX8_GARGLE effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.dwRateHz
  def __set__(BASSFX_DX8GARGLE self,DWORD value):
   cdef BASS_DX8_GARGLE effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.dwRateHz=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property WaveShape:
  def __get__(BASSFX_DX8GARGLE self):
   cdef BASS_DX8_GARGLE effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.dwWaveShape
  def __set__(BASSFX_DX8GARGLE self,DWORD value):
   cdef BASS_DX8_GARGLE effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.dwWaveShape=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
cdef class BASSFX_DX8I3DL2REVERB(BASSFX):
 property Room:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.lRoom
  def __set__(BASSFX_DX8I3DL2REVERB self,int value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.lRoom=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property RoomHF:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.lRoomHF
  def __set__(BASSFX_DX8I3DL2REVERB self,int value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.lRoomHF=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property RoomRolloffFactor:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.flRoomRolloffFactor
  def __set__(BASSFX_DX8I3DL2REVERB self,float value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.flRoomRolloffFactor=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property DecayTime:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.flDecayTime
  def __set__(BASSFX_DX8I3DL2REVERB self,float value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.flDecayTime=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property DecayHFRatio:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.flDecayHFRatio
  def __set__(BASSFX_DX8I3DL2REVERB self,float value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.flDecayHFRatio=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Reflections:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.lReflections
  def __set__(BASSFX_DX8I3DL2REVERB self,int value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.lReflections=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property ReflectionsDelay:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.flReflectionsDelay
  def __set__(BASSFX_DX8I3DL2REVERB self,float value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.flReflectionsDelay=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Reverb:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.lReverb
  def __set__(BASSFX_DX8I3DL2REVERB self,int value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.lReverb=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property ReverbDelay:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.flReverbDelay
  def __set__(BASSFX_DX8I3DL2REVERB self,float value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.flReverbDelay=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Diffusion:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.flDiffusion
  def __set__(BASSFX_DX8I3DL2REVERB self,float value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.flDiffusion=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Density:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.flDensity
  def __set__(BASSFX_DX8I3DL2REVERB self,float value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.flDensity=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property HFReference:
  def __get__(BASSFX_DX8I3DL2REVERB self):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.flHFReference
  def __set__(BASSFX_DX8I3DL2REVERB self,float value):
   cdef BASS_DX8_I3DL2REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.flHFReference=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
cdef class BASSFX_DX8PARAMEQ(BASSFX):
 property Center:
  def __get__(BASSFX_DX8PARAMEQ self):
   cdef BASS_DX8_PARAMEQ effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fCenter
  def __set__(BASSFX_DX8PARAMEQ self,float value):
   cdef BASS_DX8_PARAMEQ effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fCenter=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Bandwidth:
  def __get__(BASSFX_DX8PARAMEQ self):
   cdef BASS_DX8_PARAMEQ effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fBandwidth
  def __set__(BASSFX_DX8PARAMEQ self,float value):
   cdef BASS_DX8_PARAMEQ effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fBandwidth=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property Gain:
  def __get__(BASSFX_DX8PARAMEQ self):
   cdef BASS_DX8_PARAMEQ effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fGain
  def __set__(BASSFX_DX8PARAMEQ self,float value):
   cdef BASS_DX8_PARAMEQ effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fGain=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
cdef class BASSFX_DX8REVERB(BASSFX):
 property InGain:
  def __get__(BASSFX_DX8REVERB self):
   cdef BASS_DX8_REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fInGain
  def __set__(BASSFX_DX8REVERB self,float value):
   cdef BASS_DX8_REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fInGain=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property ReverbMix:
  def __get__(BASSFX_DX8REVERB self):
   cdef BASS_DX8_REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fReverbMix
  def __set__(BASSFX_DX8REVERB self,float value):
   cdef BASS_DX8_REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fReverbMix=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property ReverbTime:
  def __get__(BASSFX_DX8REVERB self):
   cdef BASS_DX8_REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fReverbTime
  def __set__(BASSFX_DX8REVERB self,float value):
   cdef BASS_DX8_REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fReverbTime=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
 property HighFreqRTRatio:
  def __get__(BASSFX_DX8REVERB self):
   cdef BASS_DX8_REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
   return effect.fHighFreqRTRatio
  def __set__(BASSFX_DX8REVERB self,float value):
   cdef BASS_DX8_REVERB effect
   bass.BASS_FXGetParameters(self.__channel,<void*>&effect)
   effect.fHighFreqRTRatio=value
   bass.BASS_FXSetParameters(self.__channel,<void*>&effect)
   bass.__Evaluate()
