import os.path
from setuptools.extension import Extension

from .extension_handler import ExtensionHandler
from .utils import IsX64, GetCurrentDirectory

class TAGSExtensionHandler(ExtensionHandler):

  def GetExtensions(self):
    return [
      Extension(
        "Bass4Py.tags.tags",
        [
          "Bass4Py/tags/tags.pyx"
        ],
        libraries = ["tags", "bass"],
        language = "c"
      ),
    ]

  def GetIncludeVariable(self):
    return 'TAGSINC'
  
  def GetLibraryVariable(self):
    return 'TAGSLIB'
  
  def GetLibraryDirectories(self):

    folders = [
      os.path.join(GetCurrentDirectory(), 'tags18', 'c'), # Windows
      os.path.join(GetCurrentDirectory(), 'tags18-linux'), # Linux
    ]

    if IsX64():
      folders = [os.path.join(f, 'x64') for f in folders]
    
    return folders

  def GetIncludeDirectories(self):

    folders = [
      os.path.join(GetCurrentDirectory(), 'tags18', 'c'), # Windows
      os.path.join(GetCurrentDirectory(), 'tags18-linux'), # Linux
    ]

    return folders

  def GetContainedPackages(self):
    return (
      "Bass4Py.tags",
    )
