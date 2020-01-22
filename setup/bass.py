import os.path
from setuptools.extension import Extension

from .extension_handler import ExtensionHandler
from .utils import IsX64, GetCurrentDirectory

class BASSExtensionHandler(ExtensionHandler):

  def IsRequired(self):
    return True
  
  def GetExtensions(self):
    return [
      Extension(
        "Bass4Py.BASS.bass",
        [
          "Bass4Py/BASS/bass.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.channel_base",
        [
          "Bass4Py/BASS/channel_base.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.channel",
        [
          "Bass4Py/BASS/channel.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.attribute",
        [
          "Bass4Py/BASS/attribute.pyx"
        ],
        libraries = ["bass"],
        language="c"
      ),
      Extension(
        "Bass4Py.BASS.output_device",
        [
          "Bass4Py/BASS/output_device.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.input_device",
        [
          "Bass4Py/BASS/input_device.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.record",
        [
          "Bass4Py/BASS/record.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.input",
        [
          "Bass4Py/BASS/input.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.dsp",
        [
          "Bass4Py/BASS/dsp.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.fx",
        [
          "Bass4Py/BASS/fx.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.music",
        [
          "Bass4Py/BASS/music.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.plugin",
        [
          "Bass4Py/BASS/plugin.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.sample",
        [
          "Bass4Py/BASS/sample.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.stream",
        [
          "Bass4Py/BASS/stream.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.sync",
        [
          "Bass4Py/BASS/sync.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.vector",
        [
          "Bass4Py/BASS/vector.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.version",
        [
          "Bass4Py/BASS/version.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.constants",
        [
          "Bass4Py/constants.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.dx8.chorus",
        [
          "Bass4Py/BASS/effects/dx8/chorus.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.dx8.compressor",
        [
          "Bass4Py/BASS/effects/dx8/compressor.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.dx8.distortion",
        [
          "Bass4Py/BASS/effects/dx8/distortion.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.dx8.echo",
        [
          "Bass4Py/BASS/effects/dx8/echo.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.dx8.flanger",
        [
          "Bass4Py/BASS/effects/dx8/flanger.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.dx8.gargle",
        [
          "Bass4Py/BASS/effects/dx8/gargle.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.dx8.i3dl2reverb",
        [
          "Bass4Py/BASS/effects/dx8/i3dl2reverb.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.dx8.parameq",
        [
          "Bass4Py/BASS/effects/dx8/parameq.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.dx8.reverb",
        [
          "Bass4Py/BASS/effects/dx8/reverb.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.effects.volume",
        [
          "Bass4Py/BASS/effects/volume.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.set_position",
        [
          "Bass4Py/BASS/syncs/set_position.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.slide",
        [
          "Bass4Py/BASS/syncs/slide.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.position",
        [
          "Bass4Py/BASS/syncs/position.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.stall",
        [
          "Bass4Py/BASS/syncs/stall.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.ogg_change",
        [
          "Bass4Py/BASS/syncs/ogg_change.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.meta",
        [
          "Bass4Py/BASS/syncs/meta.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.free",
        [
          "Bass4Py/BASS/syncs/free.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.end",
        [
          "Bass4Py/BASS/syncs/end.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.download",
        [
          "Bass4Py/BASS/syncs/download.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.device_format",
        [
          "Bass4Py/BASS/syncs/device_format.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.device_fail",
        [
          "Bass4Py/BASS/syncs/device_fail.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.music_position",
        [
          "Bass4Py/BASS/syncs/music_position.pyx"
        ],
        libraries = ["bass"],
        language = "c"
      ),
      Extension(
        "Bass4Py.BASS.syncs.music_instrument",
        [
          "Bass4Py/BASS/syncs/music_instrument.pyx"
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
      "Bass4Py.BASS",
      "Bass4Py.BASS.effects",
      "Bass4Py.BASS.effects.dx8",
      "Bass4Py.BASS.syncs",
    )