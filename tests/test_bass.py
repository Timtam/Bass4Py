from Bass4Py.BASS import bass
import unittest

class TestBASS(unittest.TestCase):

  def setUp(self):
    self.bass = bass.BASS()

  def test_available_devices(self):
    self.assertEqual(self.bass.GetDevice(0).Name, "No sound")
