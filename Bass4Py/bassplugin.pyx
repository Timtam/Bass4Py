from . cimport bass
from .bassversion cimport BASSVERSION
cdef class BASSPLUGIN:
 def __cinit__(self,HPLUGIN plugin):
  self.__plugin=plugin
 cdef const BASS_PLUGININFO* __getinfo(BASSPLUGIN self):
  cdef const BASS_PLUGININFO *info=bass.BASS_PluginGetInfo(self.__plugin)
  return info
 cpdef Free(BASSPLUGIN self):
  cdef bint res=bass.BASS_PluginFree(self.__plugin)
  bass.__Evaluate()
  return res
 property Version:
  def __get__(BASSPLUGIN self):
   cdef const BASS_PLUGININFO* info=self.__getinfo()
   bass.__Evaluate()
   return BASSVERSION(info.version)
 property Formats:
  def __get__(BASSPLUGIN self):
   cdef int i
   cdef const BASS_PLUGININFO *info=self.__getinfo()
   formats=[]
   bass.__Evaluate()
   for i in range(<int>info.formatc):
    format={'Type':info.formats[i].ctype,'Name':info.formats[i].name,'Extensions':info.formats[i].exts}
    formats.append(format)
   return formats