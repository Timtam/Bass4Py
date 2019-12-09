cdef Vector CreateVector(BASS_3DVECTOR *vector):
  return Vector(vector.x,vector.y,vector.z)

cdef class Vector:
  def __cinit__(Vector self, float X, float Y, float Z):
    self.X = X
    self.Y = Y
    self.Z = Z

  def __repr__(Vector self):
    return "BASSVECTOR at X=%f, Y=%f, Z=%f"%(self.X,self.Y,self.Z)

  def __add__(Vector self, other):
    if type(other) is int or type(other) is float:
      return Vector(self.X+other,self.Y+other,self.Z+other)
    elif type(other) is Vector:
      return Vector(self.X+other.X,self.Y+other.Y,self.Z+other.Z)

  def __sub__(Vector self,other):
    if type(other) is int or type(other) is float:
      return Vector(self.X-other,self.Y-other,self.Z-other)
    elif type(other) is Vector:
      return Vector(self.X-other.X,self.Y-other.Y,self.Z-other.Z)

  def __mul__(Vector self,other):
    if type(other) is int or type(other) is float:
      return Vector(self.X*other,self.Y*other,self.Z*other)

  cdef void Resolve(Vector self,BASS_3DVECTOR *vector):
    vector.x=self.X
    vector.y=self.Y
    vector.z=self.Z