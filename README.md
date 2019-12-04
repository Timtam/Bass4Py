# Bass4Py
An object-oriented wrapper for the BASS audio library from [un4seen.com](https://www.un4seen.com).

[![Build status](https://ci.appveyor.com/api/projects/status/wmoa6isbe8fdmg2c?svg=true)](https://ci.appveyor.com/project/timtam/bass4py)
## Building
This package is mainly written in Cython, thus you'll require at least 
Cython to build it. Bass4Py however provides a requirements-dev.txt file to 
install everything you need to run and build it. Install it with pip:

  $ pip install -r requirements-dev.txt

Bass4Py needs to link against the BASS audio library during the build process. 
Download it from here:
* Linux: [Download](https://www.un4seen.com/files/bass24-linux.zip)
* Windows [Download](https://www.un4seen.com/files/bass24.zip)

**NOTE: un4seen.com doesn't allow to download older versions, thus you'll 
always download the latest version of BASS that way. That means that Bass4Py 
might not be able to fully support it yet. Don't hesitate to file an issue if 
you get into trouble during the build process.**

Extract the downloaded zip file inside the Bass4Py folder into a folder that 
is named exactly like the zip file, i.e. bass24-linux on Linux and bass24 on 
Windows. The setup script will try to guess the file locations on its own if 
possible. You can however modify the build behaviour by setting environment 
variables to the include and library paths Bass4Py will use instead. Example:

* Windows:

      SET BASSINC=C:\path\to\bass4py\bass24\c
      SET BASSLIB=C:\path\to\bass4py\bass24\x64

* Linux:

      $ export BASSINC=/path/to/bass4py/bass24-linux
      $ export BASSLIB=/path/to/bass4py/bass24-linux/x64

* BASSINC is the include folder that contains the bass.h file.
* BASSLIB is the library folder that contains the bass.lib file (on Windows) or libbass.so file (on Linux).

