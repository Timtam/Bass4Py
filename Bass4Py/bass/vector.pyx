cdef Vector CreateVector(BASS_3DVECTOR *vector):
  return Vector(vector.x,vector.y,vector.z)

cdef class Vector:
  def __cinit__(Vector self, float x, float y, float z):
    self.x = X
    self.y = Y
    self.z = Z

  def __repr__(Vector self):
    return "Vector at X=%f, Y=%f, Z=%f"%(self.x,self.y,self.z)

  def __add__(Vector self, other):
    if type(other) is int or type(other) is float:
      return Vector(self.x+other,self.y+other,self.z+other)
    elif type(other) is Vector:
      return Vector(self.x+other.x,self.y+other.y,self.z+other.z)

  def __sub__(Vector self,other):
    if type(other) is int or type(other) is float:
      return Vector(self.x-other,self.y-other,self.z-other)
    elif type(other) is Vector:
      return Vector(self.x-other.x,self.y-other.y,self.z-other.z)

  def __mul__(Vector self,other):
    if type(other) is int or type(other) is float:
      return Vector(self.x*other,self.y*other,self.z*other)

  cdef void Resolve(Vector self,BASS_3DVECTOR *vector):
    vector.x=self.x
    vector.y=self.y
    vector.z=self.z