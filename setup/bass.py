import os.path
import platform
from setuptools.extension import Extension

from .extension_handler import ExtensionHandler
from .utils import IsX64, GetCurrentDirectory

class BASSExtensionHandler(ExtensionHandler):

  def IsRequired(self):
    return True
  
  def GetExtensions(self):
    return [
      Extension(
        "Bass4Py.bass.bass",
        [
          "Bass4Py/bass/bass.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.channel_base",
        [
          "Bass4Py/bass/channel_base.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.channel",
        [
          "Bass4Py/bass/channel.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.attribute",
        [
          "Bass4Py/bass/attribute.pyx"
        ],
        libraries = ["bass"],
        language="c"
      ),
      Extension(
        "Bass4Py.bass.output_device",
        [
          "Bass4Py/bass/output_device.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.input_device",
        [
          "Bass4Py/bass/input_device.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.record",
        [
          "Bass4Py/bass/record.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.input",
        [
          "Bass4Py/bass/input.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.dsp",
        [
          "Bass4Py/bass/dsp.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.fx",
        [
          "Bass4Py/bass/fx.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.music",
        [
          "Bass4Py/bass/music.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.plugin",
        [
          "Bass4Py/bass/plugin.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.sample",
        [
          "Bass4Py/bass/sample.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.stream",
        [
          "Bass4Py/bass/stream.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.sync",
        [
          "Bass4Py/bass/sync.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.vector",
        [
          "Bass4Py/bass/vector.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.version",
        [
          "Bass4Py/bass/version.pyx"
        ],
        language = "c"
      ),
      Extension(
        "Bass4Py._evaluable",
        [
          "Bass4Py/_evaluable.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.constants",
        [
          "Bass4Py/constants.pyx"
        ],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.dx8.chorus",
        [
          "Bass4Py/bass/effects/dx8/chorus.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.dx8.compressor",
        [
          "Bass4Py/bass/effects/dx8/compressor.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.dx8.distortion",
        [
          "Bass4Py/bass/effects/dx8/distortion.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.dx8.echo",
        [
          "Bass4Py/bass/effects/dx8/echo.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.dx8.flanger",
        [
          "Bass4Py/bass/effects/dx8/flanger.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.dx8.gargle",
        [
          "Bass4Py/bass/effects/dx8/gargle.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.dx8.i3dl2reverb",
        [
          "Bass4Py/bass/effects/dx8/i3dl2reverb.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.dx8.parameq",
        [
          "Bass4Py/bass/effects/dx8/parameq.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.dx8.reverb",
        [
          "Bass4Py/bass/effects/dx8/reverb.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.effects.volume",
        [
          "Bass4Py/bass/effects/volume.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.set_position",
        [
          "Bass4Py/bass/syncs/set_position.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.slide",
        [
          "Bass4Py/bass/syncs/slide.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.position",
        [
          "Bass4Py/bass/syncs/position.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.stall",
        [
          "Bass4Py/bass/syncs/stall.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.ogg_change",
        [
          "Bass4Py/bass/syncs/ogg_change.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.meta",
        [
          "Bass4Py/bass/syncs/meta.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.free",
        [
          "Bass4Py/bass/syncs/free.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.end",
        [
          "Bass4Py/bass/syncs/end.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.download",
        [
          "Bass4Py/bass/syncs/download.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.device_format",
        [
          "Bass4Py/bass/syncs/device_format.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.device_fail",
        [
          "Bass4Py/bass/syncs/device_fail.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.music_position",
        [
          "Bass4Py/bass/syncs/music_position.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.bass.syncs.music_instrument",
        [
          "Bass4Py/bass/syncs/music_instrument.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
    ]

  def GetIncludeVariable(self):
    return 'BASSINC'
  
  def GetLibraryVariable(self):
    return 'BASSLIB'
  
  def GetLibraryDirectories(self):

    folders = [
      os.path.join(GetCurrentDirectory(), 'bass24', 'c'), # Windows
      os.path.join(GetCurrentDirectory(), 'bass24-linux'), # Linux
    ]

    if IsX64():
      folders = [os.path.join(f, 'x64') for f in folders]
    
    return folders

  def GetIncludeDirectories(self):

    folders = [
      os.path.join(GetCurrentDirectory(), 'bass24', 'c'), # Windows
      os.path.join(GetCurrentDirectory(), 'bass24-linux'), # Linux
    ]

    return folders

  def GetContainedPackages(self):
    return (
      "Bass4Py",
      "Bass4Py.bass",
      "Bass4Py.bass.effects",
      "Bass4Py.bass.effects.dx8",
      "Bass4Py.bass.syncs",
    )
  
  def GetDataFiles(self):
  
    files = {}

    if platform.system() == 'Windows':
      if IsX64():
        files.update({'Bass4Py.bass': [os.path.join('bass24', 'x64', 'bass.dll')]})
      else:
        files.update({'Bass4Py.bass': [os.path.join('bass24', 'bass.dll')]})
    elif platform.system() == 'Linux':
      if IsX64():
        files.update({'Bass4Py.bass': [os.path.join('bass24-linux', 'x64', 'libbass.so')]})
      else:
        files.update({'Bass4Py.bass': [os.path.join('bass24-linux', 'libbass.so')]})

    files.update({
      'Bass4Py': ['*.pyi'],
      'Bass4Py.bass': ['*.pyi'],
      'Bass4Py.bass.effects': ['*.pyi'],
      'Bass4Py.bass.effects.dx8': ['*.pyi'],
      'Bass4Py.bass.syncs': ['*.pyi'],
    })

    return files
