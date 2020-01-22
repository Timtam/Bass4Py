from abc import abstractmethod

try:
  from abc import ABC
except ImportError:
  # Python 2 compatibility
  from abc import ABCMeta
  
  ABC = ABCMeta('ABC', (object,), {'__slots__': ()}) 

class ExtensionHandler(ABC):

  def IsRequired(self):
    return False
  
  @abstractmethod
  def GetExtensions(self):
    return tuple()
  
  def GetIncludeDirectories(self):
    return tuple()
  
  def GetLibraryDirectories(self):
    return tuple()

  def GetIncludeVariable(self):
    return ''
  
  def GetLibraryVariable(self):
    return ''
  
  def GetContainedPackages(self):
    return tuple()