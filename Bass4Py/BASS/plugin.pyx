from . cimport bass
from .version cimport Version

cdef class Plugin:
  def __cinit__(self, HPLUGIN plugin):
    self.__plugin = plugin

  cdef const BASS_PLUGININFO* __getinfo(Plugin self):
    cdef const BASS_PLUGININFO *info = bass.BASS_PluginGetInfo(self.__plugin)
    return info

  cpdef Free(Plugin self):
    cdef bint res
    with nogil:
      res = bass.BASS_PluginFree(self.__plugin)
    bass.__Evaluate()
    return res

  property Version:
    def __get__(Plugin self):
      cdef const BASS_PLUGININFO* info = self.__getinfo()
      bass.__Evaluate()
      return Version(info.version)

  property Formats:
    def __get__(Plugin self):
      cdef dict format
      cdef list formats = []
      cdef int i
      cdef const BASS_PLUGININFO *info = self.__getinfo()
      bass.__Evaluate()

      for i in range(<int>info.formatc):
        format={
          'Type': info.formats[i].ctype,
          'Name': info.formats[i].name.decode('utf-8'),
          'Extensions': info.formats[i].exts.decode('utf-8')
        }

        formats.append(format)
      return formats