cimport bass
from bassexceptions import BassError
from bassversion cimport BASSVERSION

cdef class BASSPLUGIN:
 def __cinit__(self,plugin):
  self.__plugin=plugin
 cpdef __Evaluate(BASSPLUGIN self):
  cdef bass.DWORD error=bass.BASS_ErrorGetCode()
  if error!=bass.BASS_OK: raise BassError(error)
 cdef const bass.BASS_PLUGININFO* __getinfo(BASSPLUGIN self):
  cdef const bass.BASS_PLUGININFO *info=bass.BASS_PluginGetInfo(self.__plugin)
  return info
 cpdef Free(BASSPLUGIN self):
  cdef bint res=bass.BASS_PluginFree(self.__plugin)
  self.__Evaluate()
  return res
 property Version:
  def __get__(BASSPLUGIN self):
   cdef const bass.BASS_PLUGININFO* info=self.__getinfo()
   self.__Evaluate()
   return BASSVERSION(info.version)
 property Formats:
  def __get__(BASSPLUGIN self):
   cdef int i
   cdef const bass.BASS_PLUGININFO *info=self.__getinfo()
   formats=[]
   self.__Evaluate()
   for i in range(<int>info.formatc):
    format={'Type':info.formats[i].ctype,'Name':info.formats[i].name,'Extensions':info.formats[i].exts}
    formats.append(format)
   return formats