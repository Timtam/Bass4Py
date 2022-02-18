from Bass4Py.exceptions import BassInitError, BassNotAvailableError
import pytest

class TestOutputDevice:

  def test_creating_from_stream_file(self, audio_files, no_sound_device):
  
    strm = no_sound_device.create_stream_from_file(str(audio_files / 'sos.wav'))
    
    assert strm.get_length() == 518252
    
    strm.free()

  def test_creating_stream_from_bytes(self, audio_files, no_sound_device):
    f = (audio_files / 'sos.wav').open("rb")
    data = f.read()
    f.close()
    
    strm = no_sound_device.create_stream_from_bytes(data)

    assert strm.get_length() == 518252

    strm.free()

  def test_creating_stream_from_file_obj(self, audio_files, no_sound_device):
    f = (audio_files / 'sos.wav').open("rb")
    
    strm = no_sound_device.create_stream_from_file_obj(f)

    assert strm.get_length() == 518252

    strm.free()

  def test_creating_stream__from_url(self, no_sound_device):

    strm = no_sound_device.create_stream_from_url("http://horton.com/consulting/portfolio/dwbt/bouncer/media/sample.wav")
    
    assert strm.default_frequency == 22050

    strm.free()

  def test_creating_stream__from_device(self, no_sound_device):

    strm = no_sound_device.create_stream()

  def test_error_when_freeing_device_stream(self, no_sound_device):

    strm = no_sound_device.create_stream()

    with pytest.raises(BassNotAvailableError):
      strm.free()

  def test_creating_stream_from_parameters(self, no_sound_device):
    strm = no_sound_device.create_stream_from_parameters(44100, 2)

    strm.free()
