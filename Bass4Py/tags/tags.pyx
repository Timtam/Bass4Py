from ..bindings.tags cimport (
  TAGS_GetLastErrorDesc,
  TAGS_GetVersion,
  TAGS_ReadEx,
  TAGS_SetUTF8)

from Bass4Py.bass.channel cimport Channel
from Bass4Py.bass.version cimport Version

from collections import namedtuple

include "../transform.pxi"

IF UNAME_SYSNAME == "Windows":
  TAGS_SetUTF8(True)
  
cpdef get_version():
  return Version(TAGS_GetVersion())

cdef class Tags:

  def __cinit__(Tags self, Channel chan):
  
    self._channel = (<Channel>chan)._channel
    
    self._tag_result = namedtuple(
      'TagResult',
      [
        'title',
        'song_artist',
        'album',
        'genre',
        'year',
        'comment',
        'track',
        'composer',
        'copyright',
        'subtitle',
        'album_artist',
        'disc',
        'publisher'
      ])

  cpdef read(Tags self, object fmt = None, DWORD tagtype = -1):

    cdef const unsigned char[:] c_fmt
    cdef char *res

    if fmt is not None:

      c_fmt = to_readonly_bytes(fmt)
    
      res = TAGS_ReadEx(self._channel, <char *>(&(c_fmt[0])), tagtype, 65001)
    
      return res.decode('utf-8')

    return self._tag_result(
      TAGS_ReadEx(self._channel, "%TITL", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%ARTI", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%ALBM", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%GNRE", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%YEAR", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%CMNT", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%TRCK", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%COMP", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%COPY", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%SUBT", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%AART", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%DISC", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self._channel, "%PUBL", tagtype, 65001).decode('utf-8')
    )
  
  property error:
    def __get__(Tags self):
      return (<char*>TAGS_GetLastErrorDesc()).decode('utf-8')