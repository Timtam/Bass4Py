"""
This module wraps the `BASS <http://www.un4seen.com/doc/#bass/>`_ main library, 
which includes audio input and output in/of several formats.

.. currentmodule:: Bass4Py.bass

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

from Bass4Py.utils import prepare_imports

prepare_imports("bass")

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

__all__ = (
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
)
