cdef VECTOR VECTOR_Create(BASS_3DVECTOR *vector):
  return VECTOR(vector.x,vector.y,vector.z)

cdef class VECTOR:
  def __cinit__(VECTOR self, float X, float Y, float Z):
    self.X = X
    self.Y = Y
    self.Z = Z

  def __repr__(VECTOR self):
    return "BASSVECTOR at X=%f, Y=%f, Z=%f"%(self.X,self.Y,self.Z)

  def __add__(VECTOR self, other):
    if type(other) is int or type(other) is float:
      return VECTOR(self.X+other,self.Y+other,self.Z+other)
    elif type(other) is VECTOR:
      return VECTOR(self.X+other.X,self.Y+other.Y,self.Z+other.Z)

  def __sub__(VECTOR self,other):
    if type(other) is int or type(other) is float:
      return VECTOR(self.X-other,self.Y-other,self.Z-other)
    elif type(other) is VECTOR:
      return VECTOR(self.X-other.X,self.Y-other.Y,self.Z-other.Z)

  def __mul__(VECTOR self,other):
    if type(other) is int or type(other) is float:
      return VECTOR(self.X*other,self.Y*other,self.Z*other)

  cdef void Resolve(VECTOR self,BASS_3DVECTOR *vector):
    vector.x=self.X
    vector.y=self.Y
    vector.z=self.Z