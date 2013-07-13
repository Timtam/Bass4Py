from basschannel import *
class BASSSTREAM:
 def __init__(self, **kwargs):
  self.__bass = kwargs['bass']
  self._stream = kwargs['stream']

 def __GetChannelObject(self):
  return BASSCHANNEL(bass=self.__bass, stream=self._stream)
 Channel = property(__GetChannelObject)