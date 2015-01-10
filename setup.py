from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import os
import os.path
cd=os.path.dirname(os.path.abspath(__file__))
setup(
 name="Bass4Py",
 version="1.0",
 author="Satoprogs",
 author_email="software@satoprogs.de",
 url="http://www.satoprogs.de/",
 packages=['Bass4Py'],
 ext_modules=cythonize(Extension("*",
  ["Bass4Py/*.pyx"],
  libraries=["bass"],
  library_dirs=[cd],
  include_dirs=[cd],
  language="c"
 )
))