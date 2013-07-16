class BASSVERSION(object):
 def __init__(self, dword):
  self.Dword=dword
  hversion=str(hex(self.Dword))
  hversion=hversion[2:]
  sversion=''
  for i in range(1,4):
   sversion+=str(int('0x%s'%(hversion[0:2].strip('0')), 16))+'.'
   hversion=hversion[2:]
  self.Str=sversion[0:-1]
 def __repr__(self):
  return '<BASSVERSION object; representing %d (v%s)>'%(self.Dword,self.Str)