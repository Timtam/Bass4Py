from Bass4Py.bass import BASS
from Bass4Py.exceptions import BassOutOfRangeError
from Bass4Py.bass.effects.dx8 import Parameq
import os.path
import platform
import unittest

class TestFX(unittest.TestCase):

  def setUp(self):
    self.bass = BASS()
    self.device = self.bass.get_output_device(0)
    self.device.init(44100, 0, 0)

    # load file
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")
    self.stream = self.device.create_stream_from_file(path)
    self.effect = Parameq()
    
  def tearDown(self):
    self.stream.free()
    self.device.free()

  def get_bounds(self):
    if platform.uname()[0] == "Windows":
      lbound = 80.0
      ubound = int(self.stream.default_frequency/3) - 1
    else:
      lbound = 1.0
      ubound = int(self.stream.default_frequency/2) - 1
    return (lbound, ubound, )

  def test_limits_before_link(self):
    def set_center(v):
      self.effect.Center = v

    if platform.uname()[0] == "Windows":
      bounds = (80.0, 16000.0, )
    else:
      bounds = (1.0, 20000.0, )

    self.assertRaises(BassOutOfRangeError, set_center, bounds[1] + 1)

  def test_limits_after_link(self):
    def set_center(v):
      self.effect.Center = v

    self.effect.set(self.stream)
    bounds = self.get_bounds()
    
    self.assertRaises(BassOutOfRangeError, set_center, bounds[1] + 1)

    self.effect.remove()
