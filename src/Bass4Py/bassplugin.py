from ctypes import *
try:
 from ctypes.wintypes import *
except:
 BOOL=c_long
 DWORD=c_ulong
 WINFUNCTYPE=CFUNCTYPE
HPLUGIN=DWORD
class bass_pluginform(Structure):
    _fields_ = [
        ("ctype", DWORD),
        ("name", c_char_p),
        ("exts", c_char_p)
    ]
class bass_plugininfo(Structure):
    _fields_ = [
        ("version", DWORD),
        ("formatc", DWORD),
        ("formats", POINTER(bass_pluginform))
    ]
class BASSPLUGIN:
 def __init__(self, bass, plugin):
  self.__bass = bass
  self.__plugin = plugin
  self.__bass_pluginfree = self.__bass.BASS_PluginFree
  self.__bass_pluginfree.restype=BOOL
  self.__bass_pluginfree.argtypes=[DWORD]
  self.__bass_plugingetinfo = self.__bass.BASS_PluginGetInfo
  self.__bass_plugingetinfo.restype=c_void_p
  self.__bass_plugingetinfo.argtypes=[HPLUGIN]
 def Free(self):
  return self.__bass_pluginfree(self.__plugin)
 def __GetInfo(self):
  ret_ = self.__bass_plugingetinfo(self.__plugin)
  if ret_==0:
   return 0
  else:
   dret_ ={}
   ret_ = cast(ret_, POINTER(bass_plugininfo))
   ret_ = ret_.contents
   dret_["version"] = ret_.version
   formats =[]
   for i in range(ret_.formatc):
    form ={}
    form["ctype"] = ret_.formats[i].ctype
    form["name"] = ret_.formats[i].name
    form["exts"] = ret_.formats[i].exts
    formats.append(form)
   dret_["formats"] = formats
   return dret_
 Info = property(__GetInfo)