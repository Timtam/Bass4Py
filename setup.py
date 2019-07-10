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
library_dirs=[os.path.join(cd, "bass24", "c")]
include_dirs=[os.path.join(cd, "bass24", "c")]

try:
  library_dirs.append(os.environ["BASSLIB"])
except KeyError:
  pass

try:
  include_dirs.append(os.environ["BASSINC"])
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
  Extension(
    "Bass4Py.constants",
    [
      "Bass4Py/constants.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.fx.dx8_chorus",
    [
      "Bass4Py/fx/dx8_chorus.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.fx.dx8_compressor",
    [
      "Bass4Py/fx/dx8_compressor.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.fx.dx8_distortion",
    [
      "Bass4Py/fx/dx8_distortion.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.fx.dx8_echo",
    [
      "Bass4Py/fx/dx8_echo.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.fx.dx8_flanger",
    [
      "Bass4Py/fx/dx8_flanger.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.fx.dx8_gargle",
    [
      "Bass4Py/fx/dx8_gargle.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.fx.dx8_i3dl2reverb",
    [
      "Bass4Py/fx/dx8_i3dl2reverb.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.fx.dx8_parameq",
    [
      "Bass4Py/fx/dx8_parameq.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.fx.dx8_reverb",
    [
      "Bass4Py/fx/dx8_reverb.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.set_position",
    [
      "Bass4Py/sync/set_position.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.slide",
    [
      "Bass4Py/sync/slide.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.position",
    [
      "Bass4Py/sync/position.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.stall",
    [
      "Bass4Py/sync/stall.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.ogg_change",
    [
      "Bass4Py/sync/ogg_change.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.meta",
    [
      "Bass4Py/sync/meta.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.free",
    [
      "Bass4Py/sync/free.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.end",
    [
      "Bass4Py/sync/end.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.download",
    [
      "Bass4Py/sync/download.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.device_format",
    [
      "Bass4Py/sync/device_format.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.device_fail",
    [
      "Bass4Py/sync/device_fail.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.music_position",
    [
      "Bass4Py/sync/music_position.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.sync.music_instrument",
    [
      "Bass4Py/sync/music_instrument.pyx"
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
    gdb_debug = DEBUG_MODE,
    compiler_directives = {
      'embedsignature': True,
      'language_level': 3
    }
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