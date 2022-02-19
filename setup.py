from distutils.errors import (
  CCompilerError,
  DistutilsExecError,
  DistutilsPlatformError)

import os
import os.path
from setuptools import setup
from setuptools.command.build_ext import build_ext
import shutil
import warnings

from Bass4Py import __version__
from setup.bass import BASSExtensionHandler
from setup.tags import TAGSExtensionHandler

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

extensions = []
library_dirs = []
include_dirs = []
packages = []
requirement_flags = []
data_files = {}

def LoadExtensions(exthandler):

  global extensions, include_dirs, library_dirs, packages, requirement_flags, data_files
  
  exts = exthandler.GetExtensions()

  extensions += exts
  
  requirement_flags += [exthandler.IsRequired()] * len(exts)
  
  library_dirs += exthandler.GetLibraryDirectories()
  
  include_dirs += exthandler.GetIncludeDirectories()
  
  packages += exthandler.GetContainedPackages()

  data_files.update(exthandler.GetDataFiles())

  try:
    library_dirs.append(os.environ[exthandler.GetLibraryVariable()])
  except KeyError:
    pass

  try:
    include_dirs.append(os.environ[exthandler.GetIncludeVariable()])
  except KeyError:
    pass

class BuildFailure(Exception):
  pass

class build_ext_compiler_check(build_ext):

  def build_extension(self, ext):
  
    global extensions, requirement_flags
    
    i = extensions.index(ext)
    required = requirement_flags[i]
    
    try:
      build_ext.build_extension(self, ext)
    except (CCompilerError, DistutilsExecError, DistutilsPlatformError):
      
      if required:
        raise BuildFailure('extension {name} is required'.format(name = ext.name))
      else:
        warnings.warn('extension {name} is not required, ignoring build failure'.format(name = ext.name))

  def build_extensions(self):

    global include_dirs, library_dirs

    compiler = self.compiler.compiler_type
    for i, ext in enumerate(self.extensions):

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
      ext.library_dirs = library_dirs
      ext.include_dirs = include_dirs

      if DEBUG_MODE:
        ext.define_macros.append(('CYTHON_TRACE', '1', ))
        ext.define_macros.append(('CYTHON_TRACE_NOGIL', '1', ))

    build_ext.build_extensions(self)

  # ensure that failed extensions won't get copied
  # otherwise builds with --inplace flag will crash
  def copy_extensions_to_source(self):
  
    self.extensions = [ext for ext in self.extensions if os.path.exists(os.path.join(self.build_lib, self.get_ext_filename(self.get_ext_fullname(ext.name))))]

    build_ext.copy_extensions_to_source(self)

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

# loading all extensions
LoadExtensions(BASSExtensionHandler())
LoadExtensions(TAGSExtensionHandler())

if USE_CYTHON:
  extensions = cythonize(
    extensions,
    gdb_debug = DEBUG_MODE,
    compiler_directives = {
      'embedsignature': True if DEBUG_MODE else False,
      'language_level': 3,
      'linetrace': True if DEBUG_MODE else False,
    }
  )
else:
  extensions = no_cythonize(extensions)

for package, files in data_files.items():

  package_dir = package.replace('.', os.path.sep)

  for i, _ in enumerate(files):

    file_path = files[i]
    file = os.path.split(file_path)[-1]

    if not os.path.exists(file_path):
      continue

    files[i] = file

    if os.path.exists(os.path.join(package_dir, file)):
      continue
    
    print(os.path.join(package_dir, file) + " doesn't exist; copying...")

    shutil.copyfile(file_path, os.path.join(package_dir, file))

requirements_file = os.path.join(os.path.dirname(__file__), "requirements.txt")

with open(requirements_file, "r") as f:
  requirements = f.read()

setup(
  name="Bass4Py",
  version=__version__,
  author="Toni Barth",
  author_email="software@satoprogs.de",
  url="https://github.com/Timtam/Bass4Py",
  ext_modules = extensions,
  include_package_data=True,
  packages = packages,
  package_data = data_files,
  cmdclass = {
    'build_ext': build_ext_compiler_check
  },
  install_requires=requirements.split("\r\n"),
)
