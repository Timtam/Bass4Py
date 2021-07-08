"""
This package contains all :class:`Bass4Py.bass.Sync` implementations that can 
be used to flexibly react to events within the audio engine. See the relevant 
class for more information on what they specifically do.

.. currentmodule:: Bass4Py.bass.syncs

.. autosummary::
   :toctree:
   
   DeviceFail
   DeviceFormat
   Download
   End
   Free
   Meta
   MusicInstrument
   MusicPosition
   OggChange
   Position
   SetPosition
   Slide
   Stall
"""

from .device_fail import DeviceFail
from .device_format import DeviceFormat
from .download import Download
from .end import End
from .free import Free
from .meta import Meta
from .music_instrument import MusicInstrument
from .music_position import MusicPosition
from .ogg_change import OggChange
from .position import Position
from .set_position import SetPosition
from .slide import Slide
from .stall import Stall