from bass cimport BASS_GetVersion, HIWORD, LOWORD, DWORD

cdef class BassVersion:
 def __cinit__(self):
  self.Integer=BASS_GetVersion()
 property String:
  def __get__(self):
   cdef unsigned int loword,hiword
   cdef int lowordcount,hiwordcount
   hiword=HIWORD(self.Integer)
   loword=LOWORD(self.Integer)
   hiwordcount=hiword/0x100
   lowordcount=loword/0x100
   return '%d.%d.%d.%d'%(hiwordcount,hiword-hiwordcount*0x100,lowordcount,loword-lowordcount*0x100)