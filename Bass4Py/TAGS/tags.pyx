from Bass4Py.BASS.channel cimport Channel
from Bass4Py.BASS.version cimport Version

from collections import namedtuple

include "../transform.pxi"

cpdef GetVersion():
  return Version(TAGS_GetVersion())

cdef class Tags:

  def __cinit__(Tags self, Channel chan):
  
    self.__channel = (<Channel>chan).__channel
    
    self.__tagresult = namedtuple(
      'TagResult',
      [
        'Title',
        'SongArtist',
        'Album',
        'Genre',
        'Year',
        'Comment',
        'Track',
        'Composer',
        'Copyright',
        'Subtitle',
        'AlbumArtist',
        'Disc',
        'Publisher'
      ])

    IF UNAME_SYSNAME == "Windows":
      TAGS_SetUTF8(True)
  
  cpdef Read(Tags self, object fmt = None, DWORD tagtype = -1):

    cdef const unsigned char[:] c_fmt
    cdef char *res

    if fmt is not None:

      c_fmt = to_readonly_bytes(fmt)
    
      res = TAGS_ReadEx(self.__channel, <char *>(&(c_fmt[0])), tagtype, 65001)
    
      return res.decode('utf-8')

    return self.__tagresult(
      TAGS_ReadEx(self.__channel, "%TITL", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%ARTI", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%ALBM", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%GNRE", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%YEAR", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%CMNT", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%TRCK", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%COMP", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%COPY", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%SUBT", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%AART", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%DISC", tagtype, 65001).decode('utf-8'),
      TAGS_ReadEx(self.__channel, "%PUBL", tagtype, 65001).decode('utf-8')
    )