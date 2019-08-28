from Bass4Py.BASS import bass
from Bass4Py.BASS.stream import STREAM
from Bass4Py.constants import STREAM as C_STREAM
from Bass4Py.exceptions import BassError
import os.path
import unittest
import wave

class TestChannel(unittest.TestCase):

  def setUp(self):
    self.bass = bass.BASS()
    self.device = self.bass.GetOutputDevice(0)
    self.device.Init(44100, 0, 0)

    # load files
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")
    self.python_wave = wave.open(path, "rb")
    self.bass_wave = self.device.CreateStreamFromFile(path, C_STREAM.DECODE)
    
  def tearDown(self):
    self.bass_wave.Free()
    self.device.Free()
    self.python_wave.close()

  def test_number_of_channels(self):
    self.assertEqual(self.bass_wave.Channels, self.python_wave.getnchannels())

  def test_sample_rate(self):
    self.assertEqual(self.bass_wave.DefaultFrequency, self.python_wave.getframerate())

  def test_length(self):
    # bass returns entire length, whereas python's wave module returns
    # number of frames, which needs to be multiplied with sample width and
    # number of channels to retrieve length in bytes
    self.assertEqual(self.bass_wave.GetLength(),
                     self.python_wave.getnframes() * \
                     self.python_wave.getsampwidth() * \
                     self.python_wave.getnchannels()
                    )

  def test_data(self):
    frames = 44100 # one second
    # data from python wave
    p_data = self.python_wave.readframes(frames)
    # bass data
    b_data = self.bass_wave.GetData(frames * self.python_wave.getsampwidth() * self.python_wave.getnchannels())
    self.assertEqual(p_data, b_data)
    
  def test_inequality(self):
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")

    strm = self.device.CreateStreamFromFile(path, C_STREAM.DECODE)
    self.assertNotEqual(self.bass_wave, strm)
    strm.Free()

  def test_loading_from_bytes(self):
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")

    f = open(path, "rb")
    data = f.read()
    f.close()
    
    strm = STREAM.FromBytes(data)

    self.assertEqual(strm.GetLength(), self.bass_wave.GetLength())

    strm.Free()

  def test_loading_from_url(self):
    strm = self.device.CreateStreamFromURL("http://horton.com/consulting/portfolio/dwbt/bouncer/media/sample.wav")
    
    strm.Free()

  def test_device_stream(self):
    strm = self.device.CreateStream()

    self.assertRaises(BassError, strm.Free)

  def test_parameterized_stream(self):
    strm = self.device.CreateStreamFromParameters(44100, 2)
    strm.Free()

  def test_loading_from_file_obj(self):
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")

    f = open(path, "rb")
    
    strm = STREAM.FromFileObj(f)

    strm.Free()
