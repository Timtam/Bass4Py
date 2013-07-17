from ctypes import *
from .exceptions import *
from .constants import *
from basssample import *
from bassplugin import *
from bassfx import *
try:
 from ctypes.wintypes import *
except:
 BOOL=c_long
 DWORD=c_ulong
 HWND=c_void_p
 WINFUNCTYPE=CFUNCTYPE
QWORD=c_longlong
class bass_vector(Structure):
 _fields_ =[("X", c_float), ("Y", c_float), ("Z", c_float)]
class bass_channelinfo(Structure):
    _fields_ = [
        ("freq", DWORD),
        ("chans", DWORD),
        ("flags", DWORD),
        ("ctype", DWORD),
        ("origres", DWORD),
        ("plugin", DWORD),
        ("sample", DWORD),
        ("filename", c_char_p),
    ]
class BASSCHANNEL(object):
 def __init__(self, **kwargs):
  self.__bass = kwargs['bass']
  self._stream = kwargs['stream']
  self.__bass_channelplay=self.__bass._bass.BASS_ChannelPlay
  self.__bass_channelplay.restype=BOOL
  self.__bass_channelplay.argtypes=[DWORD, BOOL]
  self.__bass_channelpause=self.__bass._bass.BASS_ChannelPause
  self.__bass_channelpause.restype=BOOL
  self.__bass_channelpause.argtype=[DWORD]
  self.__bass_channelstop=self.__bass._bass.BASS_ChannelStop
  self.__bass_channelstop.restype=BOOL
  self.__bass_channelstop.argtypes=[DWORD]
  self.__bass_channelgetposition=self.__bass._bass.BASS_ChannelGetPosition
  self.__bass_channelgetposition.restype=QWORD
  self.__bass_channelgetposition.argtypes=[DWORD,DWORD]
  self.__bass_channelsetposition=self.__bass._bass.BASS_ChannelSetPosition
  self.__bass_channelsetposition.restype=BOOL
  self.__bass_channelsetposition.argtypes=[DWORD,QWORD,DWORD]
  self.__bass_channelgetlength=self.__bass._bass.BASS_ChannelGetLength
  self.__bass_channelgetlength.restype=QWORD
  self.__bass_channelgetlength.argtypes=[DWORD,DWORD]
  self.__bass_channelseconds2bytes=self.__bass._bass.BASS_ChannelSeconds2Bytes
  self.__bass_channelseconds2bytes.restype=QWORD
  self.__bass_channelseconds2bytes.argtypes=[DWORD,c_double]
  self.__bass_channelbytes2seconds=self.__bass._bass.BASS_ChannelBytes2Seconds
  self.__bass_channelbytes2seconds.restype=DWORD
  self.__bass_channelbytes2seconds.argtypes=[DWORD,c_double,QWORD]
  self.__bass_channelflags=self.__bass._bass.BASS_ChannelFlags
  self.__bass_channelflags.restype=DWORD
  self.__bass_channelflags.argtypes=[DWORD,DWORD,DWORD]
  self.__bass_channelget3dattributes=self.__bass._bass.BASS_ChannelGet3DAttributes
  self.__bass_channelget3dattributes.restype=BOOL
  self.__bass_channelget3dattributes.argtypes=[DWORD,POINTER(DWORD),POINTER(c_float),POINTER(c_float),POINTER(DWORD),POINTER(DWORD),POINTER(c_float)]
  self.__bass_channelget3dposition=self.__bass._bass.BASS_ChannelGet3DPosition
  self.__bass_channelget3dposition.restype=BOOL
  self.__bass_channelget3dposition.argtypes=[DWORD,POINTER(bass_vector),POINTER(bass_vector),POINTER(bass_vector)]
  self.__bass_channelgetattribute=self.__bass._bass.BASS_ChannelGetAttribute
  self.__bass_channelgetattribute.restype=BOOL
  self.__bass_channelgetattribute.argtypes=[DWORD,DWORD,POINTER(c_float)]
  self.__bass_channelgetdevice=self.__bass._bass.BASS_ChannelGetDevice
  self.__bass_channelgetdevice.restype=DWORD
  self.__bass_channelgetdevice.argtypes=[DWORD]
  self.__bass_channelsetdevice=self.__bass._bass.BASS_ChannelSetDevice
  self.__bass_channelsetdevice.restype=BOOL
  self.__bass_channelsetdevice.argtypes=[DWORD,DWORD]
  self.__bass_channelgetinfo=self.__bass._bass.BASS_ChannelGetInfo
  self.__bass_channelgetinfo.restype=BOOL
  self.__bass_channelgetinfo.argtypes=[DWORD,POINTER(bass_channelinfo)]
  self.__bass_channelgetlevel=self.__bass._bass.BASS_ChannelGetLevel
  self.__bass_channelgetlevel.restype=DWORD
  self.__bass_channelgetlevel.argtypes=[DWORD]
  self.__bass_channelgettags=self.__bass._bass.BASS_ChannelGetTags
  self.__bass_channelgettags.restype=c_char_p
  self.__bass_channelgettags.argtypes=[DWORD,DWORD]
  self.__bass_channelisactive=self.__bass._bass.BASS_ChannelIsActive
  self.__bass_channelisactive.restype=DWORD
  self.__bass_channelisactive.argtypes=[DWORD]
  self.__bass_channelissliding=self.__bass._bass.BASS_ChannelIsSliding
  self.__bass_channelissliding.restype=BOOL
  self.__bass_channelissliding.argtypes=[DWORD,DWORD]
  self.__bass_channellock=self.__bass._bass.BASS_ChannelLock
  self.__bass_channellock.restype=BOOL
  self.__bass_channellock.argtypes=[DWORD,BOOL]
  self.__bass_channelremovelink=self.__bass._bass.BASS_ChannelRemoveLink
  self.__bass_channelremovelink.restype=BOOL
  self.__bass_channelremovelink.argtypes=[DWORD,DWORD]
 def Play(self, restart=False):
  result=self.__bass_channelplay(self._stream, restart)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def Pause(self):
  result=self.__bass_channelpause(self._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def Stop(self):
  result=self.__bass_channelstop(self._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def GetPosition(self,mode=BASS_POS_BYTE):
  result=self.__bass_channelgetposition(self._stream,mode)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def SetPosition(self, position,mode):
  result=self.__bass_channelsetposition(self._stream,position,mode)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def GetLength(self,mode):
  result=self.__bass_channelgetlength(self._stream,mode)
  if self.__bass._Error:raise BassExceptionError(self.__bass._Error)
  return result
 def Seconds2Bytes(self,seconds):
  result=self.__bass_channelseconds2bytes(self._stream,seconds)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def Bytes2Seconds(self,bytes):
  result=self.__bass_channelbytes2seconds(self._stream,bytes)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def Flags(self,flags,mask):
  result=self.__bass_channelflags(self._stream,flags,mode)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def Get3DAttributes(self):
  mode=DWORD(0)
  min=c_float(0)
  max=c_float(0)
  iangle=DWORD(0)
  oangle=DWORD(0)
  outvol=c_float(0)
  result=self.__bass_channelget3dattributes(self._stream,mode,min,max,iangle,oangle,outvol)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return {'mode':mode.value,'min':min.value,'max':max.value,'iangle':iangle.value,'oangle':oangle.value,'outvol':outvol.value}
 def Get3DPosition(self):
  pos=bass_vector()
  orient=bass_vector()
  vel=bass_vector()
  result=self.__bass_channelget3dposition(self._stream,pos,orient,vel)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return {'pos':{'X':pos.X,'Y':pos.Y,'Z':pos.Z},'orient':{'X':orient.X,'Y':orient.Y,'Z':orient.Z},'vel':{'X':vel.X,'Y':vel.Y,'Z':vel.Z}}
 def GetAttribute(self, attrib):
  value=c_float(0)
  result=self.__bass_channelgetattribute(self._stream,attrib,value)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return value.value
 @property
 def Device(self):
  result=self.__bass_channelgetdevice(self._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 @Device.setter
 def Device(self,device):
  result=self.__bass_channelsetdevice(self._stream,device)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
 @property
 def Info(self):
  bret_=bass_channelinfo()
  result=self.__bass_channelgetinfo(self._stream,bret_)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  plugin=(BASSPLUGIN(bass=self.__bass,plugin=bret_.plugin) if bret_.plugin else 0)
  sample=(BASSSAMPLE(bass=self.__bass,stream=bret_.sample) if bret_.sample else 0)
  return {'freq':bret_.freq,'chans':bret_.chans,'flags':bret_.flags,'ctype':bret_.ctype,'origres':bret_.origres,'plugin':plugin,'sample':sample,'filename':bret_.filename}
 @property
 def Level(self):
  result=self.__bass_channelgetlevel(self._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def GetTags(self,tags):
  result=self.__bass_channelgettags(self._stream,tags)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 @property
 def Active(self):
  result=self.__bass_channelisactive(self._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def IsSliding(self,attrib):
  result=self.__bass_channelissliding(self._stream,attrib)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def Lock(self,lock):
  result=self.__bass_channellock(self._stream,lock)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result
 def __repr__(self):
  return '<BASSCHANNEL object at %s>'%(self._stream)
 def RemoveLink(self, object):
  if not hasattr(object,'_stream'): raise BassMatchingError('This object type isn\'t supported by this function.')
  result=self.__bass_channelremovelink(self._stream,object._stream)
  if self.__bass._Error: raise BassExceptionError(self.__bass._Error)
  return result