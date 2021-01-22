from .._evaluable cimport _Evaluable
from ..bindings.bass cimport (
  BASS_PluginFree,
  BASS_PluginGetInfo,
  )

from .version cimport Version

cdef class Plugin(_Evaluable):
  def __cinit__(self, HPLUGIN plugin):
    self._plugin = plugin

  cdef const BASS_PLUGININFO* _get_info(Plugin self):
    cdef const BASS_PLUGININFO *info = BASS_PluginGetInfo(self._plugin)
    return info

  cpdef free(Plugin self):
    cdef bint res
    with nogil:
      res = BASS_PluginFree(self._plugin)
    self._evaluate()
    return res

  property version:
    def __get__(Plugin self):
      cdef const BASS_PLUGININFO* info = self._get_info()
      self._evaluate()
      return Version(info.version)

  property formats:
    def __get__(Plugin self):
      cdef dict format
      cdef list formats = []
      cdef int i
      cdef const BASS_PLUGININFO *info = self._get_info()
      self._evaluate()

      for i in range(<int>info.formatc):
        format={
          'Type': info.formats[i].ctype,
          'Name': info.formats[i].name.decode('utf-8'),
          'Extensions': info.formats[i].exts.decode('utf-8')
        }

        formats.append(format)
      return formats