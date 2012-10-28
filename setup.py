from distutils.core import setup
from glob import glob
setup(
 name="Bass4Py",
 version="1.0",
 author="Satoprogs",
 author_email="software@satoprogs.de",
 url="http://www.satoprogs.de/",
 package_dir={"Bass4Py":"src/Bass4Py"},
 packages=["Bass4Py"],
 data_files=[("lib", glob('src/Bass4Py/lib/*.dll'))])