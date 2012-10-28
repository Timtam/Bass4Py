import sys
import types
import os.path as paths
from win32api import GetModuleFileName
from ctypes import *
from ctypes.wintypes import *
from basschannel import *
from bassplugin import *
from bassstream import *
BASS_DWORD_ERR =4294967295
HSTREAM =DWORD
HPLUGIN=DWORD
tDownloadProc = WINFUNCTYPE(None, c_void_p, DWORD, c_void_p)
class bass_vector(Structure):
 _fields_ =[("X", c_float), ("Y", c_float), ("Z", c_float)]
class bass_deviceinfo(Structure):
 _fields_ = [("name", c_char_p), ("driver", c_char_p), ("flags", DWORD)]
class bass_info(Structure):
    _fields_ = [
        ("flags", DWORD),
        ("hwsize", DWORD),
        ("hwfree", DWORD),
        ("freesam", DWORD),
        ("free3d", DWORD),
        ("minrate", DWORD),
        ("maxrate", DWORD),
        ("eax", BOOL),
        ("minbuf", DWORD),
        ("dsver", DWORD),
        ("latency", DWORD),
        ("initflags", DWORD),
        ("speakers", DWORD),
        ("freq", DWORD),
    ]
class BASS(object):
 def __init__(self):
  self.__bass = bassdll("bass.dll")
  self.__bass_init = self.__bass.BASS_Init
  self.__bass_init.restype = BOOL
  self.__bass_init.argtypes = [c_int, DWORD, DWORD, HWND, c_void_p]
  self.__bass_errorgetcode = self.__bass.BASS_ErrorGetCode
  self.__bass_errorgetcode.restype = c_int
  self.__bass_getdeviceinfo = self.__bass.BASS_GetDeviceInfo
  self.__bass_getdeviceinfo.restype=BOOL
  self.__bass_getdeviceinfo.argtypes=[DWORD, POINTER(bass_deviceinfo)]
  self.__bass_streamcreateurl = self.__bass.BASS_StreamCreateURL
  self.__bass_streamcreateurl.restype = HSTREAM
  self.__bass_streamcreateurl.argtypes =[c_char_p, DWORD, DWORD, tDownloadProc, c_void_p]
  self.__bass_setconfig = self.__bass.BASS_SetConfig
  self.__bass_setconfig.restype = BOOL
  self.__bass_setconfig.argtypes = [DWORD, DWORD]
  self.__bass_getconfig = self.__bass.BASS_GetConfig
  self.__bass_getconfig.restype = DWORD
  self.__bass_getconfig.argtypes = [DWORD]
  self.__bass_getversion = self.__bass.BASS_GetVersion
  self.__bass_getversion.restype = DWORD
  self.__bass_setdevice = self.__bass.BASS_SetDevice
  self.__bass_setdevice.restype = BOOL
  self.__bass_setdevice.argtypes = [DWORD]
  self.__bass_getdevice = self.__bass.BASS_GetDevice
  self.__bass_getdevice.restype=DWORD
  self.__bass_free = self.__bass.BASS_Free
  self.__bass_free.restype=BOOL
  self.__bass_getdsoundobject = self.__bass.BASS_GetDSoundObject
  self.__bass_getdsoundobject.restype=c_void_p
  self.__bass_getdsoundobject.argtypes=[DWORD]
  self.__bass_getinfo = self.__bass.BASS_GetInfo
  self.__bass_getinfo.restype = BOOL
  self.__bass_getinfo.argtypes =[POINTER(bass_info)]
  self.__bass_update = self.__bass.BASS_Update
  self.__bass_update.restype=BOOL
  self.__bass_update.argtypes=[DWORD]
  self.__bass_getcpu = self.__bass.BASS_GetCPU
  self.__bass_getcpu.restype=c_float
  self.__bass_start = self.__bass.BASS_Start
  self.__bass_start.restype=BOOL
  self.__bass_stop = self.__bass.BASS_Stop
  self.__bass_stop.restype=BOOL
  self.__bass_pause = self.__bass.BASS_Pause
  self.__bass_pause.restype=BOOL
  self.__bass_setvolume = self.__bass.BASS_SetVolume
  self.__bass_setvolume.restype=BOOL
  self.__bass_setvolume.argtypes=[c_float]
  self.__bass_getvolume=self.__bass.BASS_GetVolume
  self.__bass_getvolume.restype=c_float
  self.__bass_pluginload = self.__bass.BASS_PluginLoad
  self.__bass_pluginload.restype=HPLUGIN
  self.__bass_pluginload.argtypes=[c_char_p, DWORD]
  self.__bass_set3dfactors = self.__bass.BASS_Set3DFactors
  self.__bass_set3dfactors.restype=BOOL
  self.__bass_set3dfactors.argtypes=[c_float, c_float, c_float]
  self.__bass_get3dfactors = self.__bass.BASS_Get3DFactors
  self.__bass_get3dfactors.restype=BOOL
  self.__bass_get3dfactors.argtypes=[POINTER(c_float), POINTER(c_float), POINTER(c_float)]
  self.__bass_set3dposition = self.__bass.BASS_Set3DPosition
  self.__bass_set3dposition.restype=BOOL
  self.__bass_set3dposition.argtypes=[POINTER(bass_vector), POINTER(bass_vector), POINTER(bass_vector), POINTER(bass_vector)]
  self.__bass_get3dposition=self.__bass.BASS_Get3DPosition
  self.__bass_get3dposition.restype=BOOL
  self.__bass_get3dposition.argtypes=[POINTER(bass_vector), POINTER(bass_vector), POINTER(bass_vector), POINTER(bass_vector)]
  self.__bass_apply3d = self.__bass.BASS_Apply3D
  self.__bass_apply3d.restype=None
  self.__bass_seteaxparameters = self.__bass.BASS_SetEAXParameters
  self.__bass_seteaxparameters.restype=BOOL
  self.__bass_seteaxparameters.argtypes=[c_int, c_float, c_float, c_float]
  self.__bass_geteaxparameters = self.__bass.BASS_GetEAXParameters
  self.__bass_geteaxparameters.restype=BOOL
  self.__bass_geteaxparameters.argtypes=[POINTER(DWORD), POINTER(c_float), POINTER(c_float), POINTER(c_float)]
 def Init(self, device=-1, frequency=44100, flags=0, hwnd=0, clsid=0):
  return self.__bass_init(device,frequency,flags,hwnd,clsid)
 def __ErrorGetCode(self):
  return self.__bass_errorgetcode()
 def GetDeviceInfo(self, index=1):
  bret_ = bass_deviceinfo()
  sret_ = self.__bass_getdeviceinfo(index, bret_)
  if sret_ ==0:
   return 0
  else:
   return {"name":bret_.name, "driver":bret_.driver, "flags":bret_.flags}
 def StreamCreateURL(self, url, offset=0, flags=0, function=None, user=0):
  if function==None:
   function=dDownloadProc
  else:
   if type(function) !=type(dDownloadProc):
    return 0
  ret_ = self.__bass_streamcreateurl(url, offset, flags, function, user)
  if ret_ ==0:
   return 0
  else:
   stream = BASSSTREAM(self.__bass, ret_)
   return stream
 def SetConfig(self, option, value):
  return self.__bass_setconfig(option, value)
 def GetConfig(self, option):
  return self.__bass_getconfig(option)
 def __GetVersion(self):
  return self.__bass_getversion()
 def SetDevice(self, device):
  return self.__bass_setdevice(device)
 def __GetDevice(self):
  ret_ = self.__bass_getdevice()
  if ret_ ==BASS_DWORD_ERR:
   return -1
  else:
   return ret_
 def Free(self):
  return self.__bass_free()
 def GetDSoundObject(self, object):
  return self.__bass_getdsoundobject(object)
 def __GetInfo(self):
  bret_ = bass_info()
  sret_ = self.__bass_getinfo(bret_)
  if sret_ ==0:
   return 0
  else:
   return {"flags":bret_.flags,"hwsize":bret_.hwsize,"hwfree":bret_.hwfree,"freesam":bret_.freesam,"free3d":bret_.free3d,"minrate":bret_.minrate,"maxrate":bret_.maxrate,"eax":bret_.eax,"minbuf":bret_.minbuf,"dsver":bret_.dsver,"latency":bret_.latency,"initflags":bret_.initflags,"speakers":bret_.speakers,"freq":bret_.freq}
 def Update(self, length):
  return self.__bass_update(length)
 def __GetCPU(self):
  return self.__bass_getcpu()
 def Start(self):
  return self.__bass_start()
 def Stop(self):
  return self.__bass_stop()
 def Pause(self):
  return self.__bass_pause()
 def SetVolume(self, volume):
  return self.__bass_setvolume(volume)
 def GetVolume(self):
  return self.__bass_getvolume()
 def PluginLoad(self, file, flags):
  ret_ = self.__bass_pluginload(file, flags)
  if ret_ ==0:
   return 0
  else:
   return BASSPLUGIN(self.__bass, ret_)
 def Set3DFactors(self, distf, rollf, doppf):
  return self.__bass_set3dfactors(distf, rollf, doppf)
 def Get3DFactors(self):
  distf=c_float(0)
  rollf=c_float(0)
  doppf=c_float(0)
  ret_ =self.__bass_get3dfactors(distf, rollf, doppf)
  if ret_==0:
   return 0
  else:
   return {"distf":distf.value, "rollf":rollf.value, "doppf":doppf.value}
 def Set3DPosition(self, pos=None, vel=None, front=None, top=None):
  bpos =0
  bvel =0
  bfront =0
  btop =0
  if type(pos) == types.DictType:
   bpos = bass_vector()
   bpos.X = pos["X"]
   bpos.Y = pos["Y"]
   bpos.Y = pos["Y"]
  if type(vel) ==types.DictType:
   bvel = bass_vector()
   bvel.X = vel["X"]
   bvel.Y = vel["Y"]
   bvel.Z = vel["Z"]
  if type(front) ==types.DictType:
   bfront = bass_vector()
   bfront.X = front["X"]
   bfront.Y = front["Y"]
   bfront.Z = front["Z"]
  if type(top) ==types.DictType:
   btop = bass_vector()
   btop.X = top["X"]
   btop.Y = top["Y"]
   btop.Z = top["Z"]
  return self.__bass_set3dposition(bpos, bvel, bfront, btop)
 def Get3DPosition(self):
  pos = bass_vector()
  vel = bass_vector()
  front = bass_vector()
  top = bass_vector()
  ret_ = self.__bass_get3dposition(pos, vel, front, top)
  if ret_==0:
   return 0
  else:
   return {"pos":{"X":pos.X,"Y":pos.Y,"Z":pos.Z},"vel":{"X":vel.X,"Y":vel.Y,"Z":vel.Z},"front":{"X":front.X,"Y":front.Y,"Z":front.Z},"top":{"X":top.X,"Y":top.Y,"Z":top.Z}}
 def Apply3D(self):
  self.__bass_apply3d()
 def SetEAXParameters(self, env, vol, decay, damp):
  return self.__bass_seteaxparameters(env, vol, decay, damp)
 def GetEAXParameters(self):
  env=DWORD(0)
  vol = c_float(0)
  decay = c_float(0)
  damp = c_float(0)
  ret_ = self.__bass_geteaxparameters(env, vol, decay, damp)
  if ret_==0:
   return 0
  else:
   return {"env":env.value,"vol":vol.value,"decay":decay.value,"damp":damp.value}
 Error = property(__ErrorGetCode)
 Version = property(__GetVersion)
 Device = property(__GetDevice)
 Info = property(__GetInfo)
 CPU = property(__GetCPU)
class BassDllError(Exception):
 def __init__(self, dll):
  self.dll = dll
 def __str__(self):
  return "Unable to find "+self.dll
def fDownloadProc(handle, buffer, user):
 return True
dDownloadProc = tDownloadProc(fDownloadProc)
def bassdll(dll):
 try:
  path = paths.join(paths.dirname(GetModuleFileName(0)), "lib")
  dll = windll.LoadLibrary(paths.join(path, dll))
 except WindowsError:
  try:
   path = paths.join(paths.split(paths.realpath(__file__))[0], "lib")
   dll = windll.LoadLibrary(paths.join(path, dll))
  except WindowsError:
   raise BassDllError(dll)
 return dll