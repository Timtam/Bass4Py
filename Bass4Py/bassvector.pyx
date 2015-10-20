cdef BASSVECTOR BASSVECTOR_Create(BASS_3DVECTOR *vector):
 return BASSVECTOR(vector.x,vector.y,vector.z)
cdef class BASSVECTOR:
 def __cinit__(BASSVECTOR self, float X,float Y,float Z):
  self.X=X
  self.Y=Y
  self.Z=Z
 def __repr__(BASSVECTOR self):
  return "BASSVECTOR at X=%f, Y=%f, Z=%f"%(self.X,self.Y,self.Z)
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
 cdef void Resolve(BASSVECTOR self,BASS_3DVECTOR *vector):
  vector.x=self.X
  vector.y=self.Y
  vector.z=self.Z