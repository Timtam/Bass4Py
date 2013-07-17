class BASSSAMPLE(object):
 def __init__(self, **kwargs):
  self.__bass=kwargs['bass']
  self.__stream=kwargs['stream']
 def __repr__(self):
  return '<BASSSAMPLE object at %d>'%(self._stream)