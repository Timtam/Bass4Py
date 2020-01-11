"""
Bass4Py provides access to all functionalities the BASS audio library from `un4seen.com <http://www.un4seen.com/>`_ has to offer, organized in a nice object-oriented interface.

The main class is the :class:`Bass4Py.BASS.BASS` class which should be consulted in order to get any project going.

.. currentmodule:: Bass4Py.BASS

.. autosummary::
   :toctree:
   
   Attribute
   BASS
   Channel
   ChannelBase
   DSP
   FX
   Input
   InputDevice
   Music
   OutputDevice
   Plugin
   Record
   Sample
   Stream
   Sync
   Vector
   Version

"""

from .bass import BASS
from .attribute import Attribute
from .channel_base import ChannelBase
from .channel import Channel
from .dsp import DSP
from .fx import FX
from .input import Input
from .input_device import InputDevice
from .music import Music
from .output_device import OutputDevice
from .plugin import Plugin
from .record import Record
from .sample import Sample
from .stream import Stream
from .sync import Sync
from .vector import Vector
from .version import Version

__all__ = [
  'Attribute',
  'BASS',
  'Channel',
  'ChannelBase',
  'DSP',
  'FX',
  'Input',
  'InputDevice',
  'Music',
  'OutputDevice',
  'Plugin',
  'Record',
  'Sample',
  'Stream',
  'Sync',
  'Vector',
  'Version',
]
