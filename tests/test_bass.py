from Bass4Py.bass import BASS
import unittest

class TestBASS(unittest.TestCase):

  def setUp(self):
    self.bass = BASS()

  def test_available_devices(self):
    self.assertEqual(self.bass.get_output_device(0).name, "No sound")
