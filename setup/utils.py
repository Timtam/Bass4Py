import os.path
import sys

def IsX64():
  return sys.maxsize > 2**32

def GetCurrentDirectory():
  return os.path.dirname(os.path.abspath(os.path.join(__file__, '..')))
