from distutils.core import setup
from distutils.command.build_ext import build_ext
from distutils.extension import Extension

import os
import os.path

try:
  from Cython.Build import cythonize
  HAVE_CYTHON = True
except ImportError:
  HAVE_CYTHON = False

USE_CYTHON = HAVE_CYTHON
DEBUG_MODE = False

if 'USE_CYTHON' in os.environ:
  USE_CYTHON = os.environ['USE_CYTHON'].lower() in ('1', 'yes')

if 'DEBUG' in os.environ:
  DEBUG_MODE = os.environ['DEBUG'].lower() in ('1', 'yes')

if USE_CYTHON and not HAVE_CYTHON:
  raise RuntimeError("cython not found")

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

class build_ext_compiler_check(build_ext):
  def build_extensions(self):
    compiler = self.compiler.compiler_type
    for ext in self.extensions:
      comp_args = []
      link_args = []
      if compiler == 'mingw32' or compiler == 'unix' or compiler == 'cygwin':
        if ext.language == "c++":
          comp_args.append('-std=c++11')
        if DEBUG_MODE:
          comp_args += ['-g', '-O0']
      elif compiler == 'msvc':
        if DEBUG_MODE:
          comp_args += ['/Od', '-Zi']
          link_args.append('-debug')
      ext.extra_compile_args = comp_args
      ext.extra_link_args = link_args
    build_ext.build_extensions(self)

def no_cythonize(extensions, **_ignore):
  for extension in extensions:
    sources = []
    for sfile in extension.sources:
      path, ext = os.path.splitext(sfile)
      if ext in ('.pyx', '.py'):
        if extension.language == 'c++':
          ext = '.cpp'
        else:
          ext = '.c'
        sfile = path + ext
      sources.append(sfile)
    extension.sources[:] = sources
  return extensions

extensions = [
  Extension(
    "Bass4Py.bass",
    [
      "Bass4Py/bass.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.basschannel",
    [
      "Bass4Py/basschannel.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.basschannelattribute",
    [
      "Bass4Py/basschannelattribute.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language="c"
  ),
  Extension(
    "Bass4Py.bassdevice",
    [
      "Bass4Py/bassdevice.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.bassdsp",
    [
      "Bass4Py/bassdsp.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.bassfx",
    [
      "Bass4Py/bassfx.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.bassmusic",
    [
      "Bass4Py/bassmusic.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.bassplugin",
    [
      "Bass4Py/bassplugin.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.bassposition",
    [
      "Bass4Py/bassposition.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.basssample",
    [
      "Bass4Py/basssample.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.bassstream",
    [
      "Bass4Py/bassstream.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.basssync",
    [
      "Bass4Py/basssync.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.bassvector",
    [
      "Bass4Py/bassvector.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.bassversion",
    [
      "Bass4Py/bassversion.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
]

if USE_CYTHON:
  extensions = cythonize(
    extensions,
    gdb_debug = DEBUG_MODE
  )
else:
  extensions = no_cythonize(extensions)

setup(
  name="Bass4Py",
  version="1.0",
  author="Toni Barth",
  author_email="software@satoprogs.de",
  url="https://github.com/Timtam/Bass4Py",
  ext_modules = extensions,
  packages = [
    "Bass4Py"
  ],
  cmdclass = {
    'build_ext': build_ext_compiler_check
  }
)