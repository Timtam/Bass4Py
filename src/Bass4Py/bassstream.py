from basschannel import *
class BASSSTREAM(object):
 def __init__(self, **kwargs):
  self.__bass = kwargs['bass']
  self._stream = kwargs['stream']

 @property
 def Channel(self):
  return BASSCHANNEL(bass=self.__bass, stream=self._stream)