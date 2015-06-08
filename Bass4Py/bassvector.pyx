from bass cimport BASS_3DVECTOR
cdef inline BASSVECTOR BASSVECTOR_Create(BASS_3DVECTOR *vector):
 return BASSVECTOR(vector.x,vector.y,vector.z)
cdef class BASSVECTOR:
 def __cinit__(BASSVECTOR self, float X,float Y,float Z):
  self.X=X
  self.Y=Y
  self.Z=Z
 def __repr__(BASSVECTOR self):
  return "Vector at X=%f, Y=%f, Z=%f"%(self.X,self.Y,self.Z)
 def __add__(BASSVECTOR self,other):
  if type(other) is int or type(other) is float:
   return BASSVECTOR(self.X+other,self.Y+other,self.Z+other)
  elif type(other) is BASSVECTOR:
   return BASSVECTOR(self.X+other.X,self.Y+other.Y,self.Z+other.Z)
 def __sub__(BASSVECTOR self,other):
  if type(other) is int or type(other) is float:
   return BASSVECTOR(self.X-other,self.Y-other,self.Z-other)
  elif type(other) is BASSVECTOR:
   return BASSVECTOR(self.X-other.X,self.Y-other.Y,self.Z-other.Z)
 def __mul__(BASSVECTOR self,other):
  if type(other) is int or type(other) is float:
   return BASSVECTOR(self.X*other,self.Y*other,self.Z*other)