from Bass4Py import bass
import os.path
import unittest
import wave

class TestChannel(unittest.TestCase):

  def setUp(self):
    self.bass = bass.BASS()
    self.device = self.bass.GetDevice(0)
    self.device.Init(44100, 0, 0)

    # load files
    path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")
    self.python_wave = wave.open(path, "rb")
    self.bass_wave = self.device.StreamCreateFile(False, path.encode("utf-8"), 0, 0, bass.BASS_STREAM_DECODE)
    
  def tearDown(self):
    self.bass_wave.Free()
    self.device.Free()
    self.python_wave.close()

  def test_number_of_channels(self):
    self.assertEqual(self.bass_wave.Channels, self.python_wave.getnchannels())

  def test_sample_rate(self):
    self.assertEqual(self.bass_wave.Frequency.Get(), self.python_wave.getframerate())

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