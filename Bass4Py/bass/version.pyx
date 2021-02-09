from ..bindings.bass cimport (
  HIWORD,
  LOWORD,
  WORD)

cdef class Version(str):
  """
  A class representing versions in the context of Bass4Py, including all its 
  dependencies. This class inherits Python's :obj:`str` class, so that it can 
  be handled just like any other string. In addition to that, it can also be 
  converted into an integer value, using the :obj:`int` object on it.
  """

  def __cinit__(Version self, DWORD version):
    self._version = version

  def __str__(self):
    cdef WORD loword,hiword
    cdef int lowordcount,hiwordcount

    hiword=HIWORD(self.Integer)
    loword=LOWORD(self.Integer)
    hiwordcount=int(hiword/0x100)
    lowordcount=int(loword/0x100)

    return '{0}.{1}.{2}.{3}'.format(hiwordcount, hiword-hiwordcount*0x100, lowordcount, loword-lowordcount*0x100)

  def __repr__(self):
    return self.__str__()

  def __int__(self):
    return self._version

  def __index__(self):
    return self._version