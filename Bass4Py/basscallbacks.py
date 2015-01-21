class BASSCALLBACKS(object):
 def __init__(self):
  self.Callbacks=[]
 def AddCallback(self,function,user):
  cb={}
  cb['function']=function
  cb['user']=user
  try:
   ind=self.Callbacks.index(None)
  except ValueError:
   ind=None
  if ind==None:
   self.Callbacks.append(cb)
  else:
   self.Callbacks[ind]=cb
  return self.Callbacks.index(cb)
 def DeleteCallback(self,pos):
  self.Callbacks[pos]=None
  if self.Callbacks[len(self.Callbacks)-1]==None:
   del(self.Callbacks[len(self.Callbacks)-1])
  print self.Callbacks
 def GetCallback(self,pos):
  return self.Callbacks[pos]
Callbacks=BASSCALLBACKS()