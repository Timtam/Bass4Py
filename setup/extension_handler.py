from abc import ABC, abstractmethod

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