from Bass4Py.constants import STREAM

class TestChannelBase:

  def test_read_channels_property(self, sos_wave, sos_bass_stream):
    assert sos_bass_stream.channels == sos_wave.getnchannels()

  def test_read_default_frequency_property(self, sos_wave, sos_bass_stream):
    assert sos_bass_stream.default_frequency == sos_wave.getframerate()

  def test_get_length(self, sos_wave, sos_bass_stream):
    # bass returns entire length, whereas python's wave module returns
    # number of frames, which needs to be multiplied with sample width and
    # number of channels to retrieve length in bytes
    assert sos_bass_stream.get_length() == sos_wave.getnframes() * sos_wave.getsampwidth() * sos_wave.getnchannels()

  def test_get_data(self, sos_wave, sos_bass_stream):
    frames = 44100 # one second
    # data from python wave
    p_data = sos_wave.readframes(frames)
    # bass data
    b_data = sos_bass_stream.get_data(frames * sos_wave.getsampwidth() * sos_wave.getnchannels())
    assert p_data == b_data

  def test_equality_comparison(self, sos_bass_stream, audio_files, no_sound_device):
    strm = no_sound_device.create_stream_from_file(str(audio_files / 'sos.wav'), STREAM.DECODE)
    assert sos_bass_stream != strm
    strm.free()

  def test_bytes_to_seconds(self, sos_wave, sos_bass_stream):
  
    assert sos_bass_stream.bytes_to_seconds(sos_bass_stream.get_length()) == sos_wave.getnframes() / sos_wave.getframerate()
