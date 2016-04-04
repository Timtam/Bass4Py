from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
from glob import iglob,glob
import os
import os.path
import shutil
import sys
try:
 WindowsError
except:
 WindowsError=None
if len(sys.argv)==1:
 sys.argv.append('build_ext')
 sys.argv.append('--inplace')
cd=os.path.dirname(os.path.abspath(__file__))
library_dirs=[cd]
include_dirs=[cd]
try:
 library_dirs.append(os.environ["LIBBASS"])
except KeyError:
 pass
try:
 include_dirs.append(os.environ["LIBBASS"])
except KeyError:
 pass
exts=['c','dll','pdb','pyd','so']
print 'Removing old files'
for ext in exts:
 ifiles=iglob(os.path.join(cd,'Bass4Py','*.%s'%ext))
 for file in ifiles:
  try:
   os.remove(file)
  except (IOError,OSError,WindowsError):
   pass
try:
 os.remove(glob(os.path.join(cd,'*.pdb'))[0])
except:
 pass
shutil.rmtree(os.path.join(cd,'cython_debug'),True)
modules=cythonize(Extension("*",
  ["Bass4Py/*.pyx"],
  libraries=["bass"],
  library_dirs=library_dirs,
  include_dirs=include_dirs,
  language="c",
#  extra_compile_args=['-Zi','/Od'],
#  extra_link_args=['-debug']
 )
#  ,gdb_debug=True
)
setup(
 name="Bass4Py",
 version="1.0",
 author="Satoprogs",
 author_email="software@satoprogs.de",
 url="http://www.satoprogs.de/",
 packages=['Bass4Py'],
 ext_modules=modules
)
print "Removing build artifacts"
shutil.rmtree(os.path.join(cd,'build'),True)
print "Finished Bass4Py build process"