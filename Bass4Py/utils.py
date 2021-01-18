import os
import os.path
import platform
import sys

_prepared = False

def prepare_imports(package):

  global _prepared

  if _prepared:
    return

  _prepared = True
  
  # following paths are searched
  paths = []
  # current working directory
  paths.append(os.getcwd())

  # package directory
  paths.append(os.path.join(os.path.dirname(__file__), package))

  if platform.system() == 'Windows':
  
    if sys.version_info < (3, 8, ):
    
      # python versions < 3.8 need to set PATH environment variable
      os.environ["PATH"] = ';'.join(paths) + ';' + os.environ["PATH"]
    else:
    
      # Python 3.8+ use os.add_dll_directory for locating dll files
      for path in paths:
        os.add_dll_directory(path)
    
  elif platform.system() == 'Linux':
  
    # Linux requires setting the LD_LIBRARY_PATH environment variable
    os.environ["LD_LIBRARY_PATH"] = ':'.join(paths) + ':' + os.environ["LD_LIBRARY_PATH"]
