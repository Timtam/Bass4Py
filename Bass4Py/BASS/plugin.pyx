from .bass cimport __Evaluate
from ..bindings.bass cimport (
  BASS_PluginFree,
  BASS_PluginGetInfo,
  )

from .version cimport Version

cdef class Plugin:
  def __cinit__(self, HPLUGIN plugin):
    self._plugin = plugin

  cdef const BASS_PLUGININFO* _getinfo(Plugin self):
    cdef const BASS_PLUGININFO *info = BASS_PluginGetInfo(self._plugin)
    return info

  cpdef Free(Plugin self):
    cdef bint res
    with nogil:
      res = BASS_PluginFree(self._plugin)
    __Evaluate()
    return res

  property Version:
    def __get__(Plugin self):
      cdef const BASS_PLUGININFO* info = self._getinfo()
      __Evaluate()
      return Version(info.version)

  property Formats:
    def __get__(Plugin self):
      cdef dict format
      cdef list formats = []
      cdef int i
      cdef const BASS_PLUGININFO *info = self._getinfo()
      __Evaluate()

      for i in range(<int>info.formatc):
        format={
          'Type': info.formats[i].ctype,
          'Name': info.formats[i].name.decode('utf-8'),
          'Extensions': info.formats[i].exts.decode('utf-8')
        }

        formats.append(format)
      return formats