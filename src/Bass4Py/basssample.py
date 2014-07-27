from ctypes import *
from .exceptions import *
try:
 from ctypes.wintypes import *
except:
 BOOL=c_long
 DWORD=c_ulong
class bass_sample(Structure):
 _fields_=[("freq",DWORD),("volume",c_float),("pan",c_float),("flags",DWORD),("length",DWORD),("max",DWORD),("origres",DWORD),("chans",DWORD),("mingap",DWORD),("mode3d",DWORD),("mindist",c_float),("maxdist",c_float),("iangle",DWORD),("oangle",DWORD),("outvol",c_float),("vam",DWORD),("priority",DWORD)]
class BASSSAMPLE(object):
 def __init__(self, **kwargs):
  self.__bass=kwargs['bass']
  self._stream=kwargs['stream']
  self.__bass_samplefree=self.__bass._bass.BASS_SampleFree
  self.__bass_samplefree.restype=BOOL
  self.__bass_samplefree.argtypes=[DWORD]
  self.__bass_samplegetchannel=self.__bass._bass.BASS_SampleGetChannel
  self.__bass_samplegetchannel.restype=DWORD
  self.__bass_samplegetchannel.argtypes=[DWORD,BOOL]
  self.__bass_samplegetinfo=self.__bass._bass.BASS_SampleGetInfo
  self.__bass_samplegetinfo.restype=BOOL
  self.__bass_samplegetinfo.argtypes=[DWORD,POINTER(bass_sample)]
  self.__bass_samplegetchannels=self.__bass._bass.BASS_SampleGetChannels
  self.__bass_samplegetchannels.restype=DWORD
  self.__bass_samplegetchannels.argtypes=[DWORD,POINTER(DWORD)]
 def __repr__(self):
  return '<BASSSAMPLE object at %d>'%(self._stream)
 def Free(self):
  ret_=self.__bass_samplefree(self._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return bool(ret_)
 def GetChannel(self,onlynew=False):
  ret_=self.__bass_samplegetchannel(self._stream,onlynew)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return self.__bass.ReceiveChannel(ret_)
 def __GetInfo(self):
  bret_=bass_sample()
  ret_=self.__bass_samplegetinfo(self._stream,bret_)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return {"freq":bret_.freq,"volume":bret_.volume,"pan":bret_.pan,"flags":bret_.flags,"length":bret_.length,"max":bret_.max,"origres":bret_.origres,"chans":bret_.chans,"mingap":bret_.mingap,"mode3d":bret_.mode3d,"mindist":bret_.mindist,"maxdist":bret_.maxdist,"iangle":bret_.iangle,"oangle":bret_.oangle,"outvol":bret_.outvol,"vam":bret_.vam,"priority":bret_.priority}
 @property
 def Frequency(self):
  return int(self.__GetInfo()['freq'])
 @property
 def Volume(self):
  return float(self.__GetInfo()['volume'])
 @property
 def Pan(self):
  return float(self.__GetInfo()['pan'])
 @property
 def Flags(self):
  return int(self.__GetInfo()['flags'])
 @property
 def Length(self):
  return int(self.__GetInfo()['length'])
 @property
 def MaxPlaybacks(self):
  return int(self.__GetInfo()['max'])
 @property
 def Resolution(self):
  return int(self.__GetInfo()['origres'])
 @property
 def ChannelCount(self):
  return int(self.__GetInfo()['chans'])
 @property
 def MinGap(self):
  return iGetnt(self.__Info()['mingap'])
 @property
 def Mode3D(self):
  return int(self.__GetInfo()['mode3d'])
 @property
 def MinDistance(self):
  return float(self.__GetInfo()['mindist'])
 @property
 def MaxDistance(self):
  return float(self.__GetInfo()['maxdist'])
 @property
 def IAngle(self):
  return int(self.__GetInfo()['iangle'])
 @property
 def OAngle(self):
  return int(self.__GetInfo()['oangle'])
 @property
 def OutVolume(self):
  return float(self.__GetInfo()['outvol'])
 @property
 def VAM(self):
  return int(self.__GetInfo()['vam'])
 @property
 def Priority(self):
  return int(self.__GetInfo()['priority'])
 @property
 def ActiveChannelCount(self):
  self.__bass_samplegetchannels.argtypes[1]=POINTER(DWORD)
  count=DWORD(0)
  ret_=self.__bass_samplegetchannels(self._stream,count)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return ret_
 @property
 def Channels(self):
  channels=DWORD*self.ChannelCount
  self.__bass_samplegetchannels.argtypes[1]=POINTER(channels)
  channels=channels()
  ret_=self.__bass_samplegetchannels(self._stream,channels)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  lchannels=[]
  for channel in channels:
   if channel: lchannels.append(self.__bass.ReceiveChannel(channel))
   else: lchannels.append(0)
  return lchannels