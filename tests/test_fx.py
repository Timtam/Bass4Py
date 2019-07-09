from Bass4Py import bass
from Bass4Py.exceptions import BassOutOfRangeError
from Bass4Py.fx.dx8_parameq import BASSFX_DX8PARAMEQ
import os.path
import platform
import unittest

class TestFX(unittest.TestCase):

  def setUp(self):
    self.bass = bass.BASS()
    self.device = self.bass.GetDevice(0)
    self.device.Init(44100, 0, 0)

    # load file
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")
    self.stream = self.device.StreamCreateFile(False, path.encode('utf-8'), 0, 0, 0)
    self.effect = BASSFX_DX8PARAMEQ()
    
  def tearDown(self):
    self.stream.Free()
    self.device.Free()

  def get_bounds(self):
    if platform.uname()[0] == "Windows":
      lbound = 80.0
      ubound = int(self.stream.DefaultFrequency/3) - 1
    else:
      lbound = 1.0
      ubound = int(self.stream.DefaultFrequency/2) - 1
    return (lbound, ubound, )

  def test_limits_before_link(self):
    def set_center(v):
      self.effect.Center = v

    if platform.uname()[0] == "Windows":
      bounds = (80.0, 16000.0, )
    else:
      bounds = (1.0, 20.000, )

    self.assertRaises(BassOutOfRangeError, set_center, bounds[1] + 1)

  def test_limits_after_link(self):
    def set_center(v):
      self.effect.Center = v

    self.effect.Set(self.stream)
    bounds = self.get_bounds()
    
    self.assertRaises(BassOutOfRangeError, set_center, bounds[1] + 1)

    self.effect.Remove()
