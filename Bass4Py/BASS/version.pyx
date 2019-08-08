from . cimport bass

cdef class VERSION:
  """
  A helper class which represents BASS version information in a more human-readable format

  :ivar Integer: The actual version (readonly)
  """

  def __cinit__(VERSION self, DWORD version):
    self.Integer = version

  def __eq__(VERSION self, object v):
    if isinstance(v, VERSION):
      return self.Integer == (<VERSION>v).Integer
    elif isinstance(v, int):
      return self.Integer == v
    else:
      return NotImplemented

  property String:
    """
    The version in a human-readable format

    .. note:: no setter implemented
    """
    def __get__(VERSION self):
      cdef WORD loword,hiword
      cdef int lowordcount,hiwordcount
      hiword=bass.HIWORD(self.Integer)
      loword=bass.LOWORD(self.Integer)
      hiwordcount=int(hiword/0x100)
      lowordcount=int(loword/0x100)
      return '{0}.{1}.{2}.{3}'.format(hiwordcount, hiword-hiwordcount*0x100, lowordcount, loword-lowordcount*0x100)
