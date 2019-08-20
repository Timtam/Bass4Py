from setuptools import setup
from setuptools.command.build_ext import build_ext
from setuptools.extension import Extension

import os
import os.path
import platform
import sys

try:
  from Cython.Build import cythonize
  HAVE_CYTHON = True
except ImportError:
  HAVE_CYTHON = False

USE_CYTHON = HAVE_CYTHON
DEBUG_MODE = False
IS_X64 = sys.maxsize > 2**32

if 'USE_CYTHON' in os.environ:
  USE_CYTHON = os.environ['USE_CYTHON'].lower() in ('1', 'yes')

if 'DEBUG' in os.environ:
  DEBUG_MODE = os.environ['DEBUG'].lower() in ('1', 'yes')

if USE_CYTHON and not HAVE_CYTHON:
  raise RuntimeError("cython not found")

library_dirs = []
include_dirs = []

cd=os.path.dirname(os.path.abspath(__file__))

if platform.uname()[0] == "Windows":

  lib_dir = os.path.join(cd, "bass24", "c")

  if IS_X64:
    lib_dir = os.path.join(lib_dir, "x64")

elif platform.uname()[0] == "Linux":

  lib_dir = os.path.join(cd, "bass24-linux")
  
  if IS_X64:
    lib_dir = os.path.join(lib_dir, "x64")
    
library_dirs.append(lib_dir)

if platform.uname()[0] == "Windows":

  inc_dir = os.path.join(cd, "bass24", "c")

elif platform.uname()[0] == "Linux":

  inc_dir = os.path.join(cd, "bass24-linux")
  
include_dirs.append(inc_dir)

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
    "Bass4Py.BASS.bass",
    [
      "Bass4Py/BASS/bass.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.channel_base",
    [
      "Bass4Py/BASS/channel_base.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.channel",
    [
      "Bass4Py/BASS/channel.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.attribute",
    [
      "Bass4Py/BASS/attribute.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language="c"
  ),
  Extension(
    "Bass4Py.BASS.output_device",
    [
      "Bass4Py/BASS/output_device.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.input_device",
    [
      "Bass4Py/BASS/input_device.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.record",
    [
      "Bass4Py/BASS/record.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.input",
    [
      "Bass4Py/BASS/input.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.dsp",
    [
      "Bass4Py/BASS/dsp.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.fx",
    [
      "Bass4Py/BASS/fx.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.music",
    [
      "Bass4Py/BASS/music.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.plugin",
    [
      "Bass4Py/BASS/plugin.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.sample",
    [
      "Bass4Py/BASS/sample.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.stream",
    [
      "Bass4Py/BASS/stream.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.sync",
    [
      "Bass4Py/BASS/sync.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.vector",
    [
      "Bass4Py/BASS/vector.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.version",
    [
      "Bass4Py/BASS/version.pyx"
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
    "Bass4Py.BASS.effects.dx8_chorus",
    [
      "Bass4Py/BASS/effects/dx8_chorus.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.effects.dx8_compressor",
    [
      "Bass4Py/BASS/effects/dx8_compressor.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.effects.dx8_distortion",
    [
      "Bass4Py/BASS/effects/dx8_distortion.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.effects.dx8_echo",
    [
      "Bass4Py/BASS/effects/dx8_echo.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.effects.dx8_flanger",
    [
      "Bass4Py/BASS/effects/dx8_flanger.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.effects.dx8_gargle",
    [
      "Bass4Py/BASS/effects/dx8_gargle.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.effects.dx8_i3dl2reverb",
    [
      "Bass4Py/BASS/effects/dx8_i3dl2reverb.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.effects.dx8_parameq",
    [
      "Bass4Py/BASS/effects/dx8_parameq.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.effects.dx8_reverb",
    [
      "Bass4Py/BASS/effects/dx8_reverb.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.effects.volume",
    [
      "Bass4Py/BASS/effects/volume.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.set_position",
    [
      "Bass4Py/BASS/syncs/set_position.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.slide",
    [
      "Bass4Py/BASS/syncs/slide.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.position",
    [
      "Bass4Py/BASS/syncs/position.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.stall",
    [
      "Bass4Py/BASS/syncs/stall.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.ogg_change",
    [
      "Bass4Py/BASS/syncs/ogg_change.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.meta",
    [
      "Bass4Py/BASS/syncs/meta.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.free",
    [
      "Bass4Py/BASS/syncs/free.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.end",
    [
      "Bass4Py/BASS/syncs/end.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.download",
    [
      "Bass4Py/BASS/syncs/download.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.device_format",
    [
      "Bass4Py/BASS/syncs/device_format.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.device_fail",
    [
      "Bass4Py/BASS/syncs/device_fail.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.music_position",
    [
      "Bass4Py/BASS/syncs/music_position.pyx"
    ],
    libraries = ["bass"],
    library_dirs = library_dirs,
    include_dirs = include_dirs,
    language = "c"
  ),
  Extension(
    "Bass4Py.BASS.syncs.music_instrument",
    [
      "Bass4Py/BASS/syncs/music_instrument.pyx"
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
    "Bass4Py",
    "Bass4Py.BASS",
  ],
  cmdclass = {
    'build_ext': build_ext_compiler_check
  },
  install_requires = [
    "filelike==0.5.0",
    "aenum==2.2.1;python_version < '3.6'",
  ]
)