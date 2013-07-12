from basschannel import *
class BASSSTREAM:
 def __init__(self, bass, stream):
  self.__bass = bass
  self.__stream = stream

 def __GetChannelObject(self):
  return BASSCHANNEL(self.__bass, self.__stream)
 Channel = property(__GetChannelObject)