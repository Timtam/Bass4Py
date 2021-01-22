from Bass4Py.bass import BASS, Stream
from Bass4Py.constants import STREAM
from Bass4Py.exceptions import BassNotAvailableError
import os.path
import unittest
import wave

class TestChannel(unittest.TestCase):

  def setUp(self):
    self.bass = BASS()
    self.device = self.bass.get_output_device(0)
    self.device.init(44100, 0, 0)

    # load files
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")
    self.python_wave = wave.open(path, "rb")
    self.bass_wave = self.device.create_stream_from_file(path, STREAM.DECODE)
    
  def tearDown(self):
    self.bass_wave.free()
    self.device.free()
    self.python_wave.close()

  def test_number_of_channels(self):
    self.assertEqual(self.bass_wave.channels, self.python_wave.getnchannels())

  def test_sample_rate(self):
    self.assertEqual(self.bass_wave.default_frequency, self.python_wave.getframerate())

  def test_length(self):
    # bass returns entire length, whereas python's wave module returns
    # number of frames, which needs to be multiplied with sample width and
    # number of channels to retrieve length in bytes
    self.assertEqual(self.bass_wave.get_length(),
                     self.python_wave.getnframes() * \
                     self.python_wave.getsampwidth() * \
                     self.python_wave.getnchannels()
                    )

  def test_data(self):
    frames = 44100 # one second
    # data from python wave
    p_data = self.python_wave.readframes(frames)
    # bass data
    b_data = self.bass_wave.get_data(frames * self.python_wave.getsampwidth() * self.python_wave.getnchannels())
    self.assertEqual(p_data, b_data)
    
  def test_inequality(self):
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")

    strm = self.device.create_stream_from_file(path, STREAM.DECODE)
    self.assertNotEqual(self.bass_wave, strm)
    strm.free()

  def test_loading_from_bytes(self):
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")

    f = open(path, "rb")
    data = f.read()
    f.close()
    
    strm = Stream.from_bytes(data)

    self.assertEqual(strm.get_length(), self.bass_wave.get_length())

    strm.free()

  def test_loading_from_url(self):
    strm = self.device.create_stream_from_url("http://horton.com/consulting/portfolio/dwbt/bouncer/media/sample.wav")
    
    strm.free()

  def test_device_stream(self):
    strm = self.device.create_stream()

    self.assertRaises(BassNotAvailableError, strm.free)

  def test_parameterized_stream(self):
    strm = self.device.create_stream_from_parameters(44100, 2)
    strm.free()

  def test_loading_from_file_obj(self):
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")

    f = open(path, "rb")
    
    strm = Stream.from_file_obj(f)

    strm.free()
