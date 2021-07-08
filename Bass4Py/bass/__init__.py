"""
This module wraps the `BASS <http://www.un4seen.com/doc/#bass/>`_ main library, 
which includes audio input and output in/of several formats.

.. currentmodule:: Bass4Py.bass

Main objects
------------

.. autosummary::
   :toctree:
   
   BASS
   Channel
   ChannelBase
   DSP
   FX
   Input
   InputDevice
   InputDeviceEnumerator
   Music
   OutputDevice
   OutputDeviceEnumerator
   Plugin
   Record
   Sample
   Stream
   Sync
   Vector
   Version

Sub-packages
------------

.. autosummary::
   :toctree:
   
   attributes
   effects
   syncs

"""

from Bass4Py.utils import prepare_imports

prepare_imports("bass")

from .bass import BASS
from .channel_base import ChannelBase
from .channel import Channel
from .dsp import DSP
from .fx import FX
from .input import Input
from .input_device import InputDevice
from .input_device_enumerator import InputDeviceEnumerator
from .music import Music
from .output_device import OutputDevice
from .output_device_enumerator import OutputDeviceEnumerator
from .plugin import Plugin
from .record import Record
from .sample import Sample
from .stream import Stream
from .sync import Sync
from .vector import Vector
from .version import Version
