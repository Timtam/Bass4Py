class BASSCALLBACKS(object):
 def __init__(self):
  self.Callbacks=[]
 def AddCallback(self,function,user,id=None):
  if id==None:
   cb={}
   cb['function']=[function]
   cb['user']=user
   try:
    ind=self.Callbacks.index(None)
   except ValueError:
    ind=None
   if ind==None:
    self.Callbacks.append(cb)
    ind=len(self.Callbacks)-1
   else:
    self.Callbacks[ind]=cb
   return ind
  else:
   self.Callbacks[id]['function'].append(function)
   return id
 def DeleteCallback(self,pos):
  self.Callbacks[pos]=None
  if self.Callbacks[len(self.Callbacks)-1]==None:
   del(self.Callbacks[len(self.Callbacks)-1])
 def GetCallback(self,pos):
  return self.Callbacks[pos]
Callbacks=BASSCALLBACKS()