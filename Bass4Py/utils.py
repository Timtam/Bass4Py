import os
import platform
import sys

_prepared = False

def prepare_imports():

  global _prepared

  if _prepared:
    return

  _prepared = True
  
  if platform.system() != 'Windows' or sys.version_info < (3, 8, ):
    return
  
  # current working directory
  os.add_dll_directory(os.getcwd())
  
  # TODO: more directories, like when provided with wheel etc
