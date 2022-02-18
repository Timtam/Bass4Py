from Bass4Py.bass.stream import Stream
from Bass4Py.exceptions import BassFileFormatError, BassInitError, BassNotAvailableError
import pytest

class TestStream:

  def test_error_when_creating_without_device(self, audio_files):

    with pytest.raises(BassInitError):
      strm = Stream.from_file(str(audio_files / 'sos.wav'))

  def test_creating_from_file(self, audio_files, no_sound_device):
  
    strm = Stream.from_file(str(audio_files / 'sos.wav'), device=no_sound_device)
    
    assert strm.get_length() == 518252
    
    strm.free()

  def test_creating_from_bytes(self, audio_files, no_sound_device):
    f = (audio_files / 'sos.wav').open("rb")
    data = f.read()
    f.close()
    
    strm = Stream.from_bytes(data, device=no_sound_device)

    assert strm.get_length() == 518252

    strm.free()

  def test_creating_from_file_obj(self, audio_files, no_sound_device):
    f = (audio_files / 'sos.wav').open("rb")
    
    strm = Stream.from_file_obj(f, device=no_sound_device)

    assert strm.get_length() == 518252

    strm.free()

  def test_creating_from_url(self, no_sound_device):

    strm = Stream.from_url("http://horton.com/consulting/portfolio/dwbt/bouncer/media/sample.wav", device=no_sound_device)
    
    assert strm.default_frequency == 22050

    strm.free()

  def test_creating_from_device(self, no_sound_device):

    strm = Stream.from_device(device=no_sound_device)

  def test_error_when_freeing_device_stream(self, no_sound_device):

    strm = Stream.from_device(device=no_sound_device)

    with pytest.raises(BassNotAvailableError):
      strm.free()

  def test_creating_parameterized(self, no_sound_device):
    strm = Stream.from_parameters(44100, 2, device=no_sound_device)

    strm.free()

  @pytest.mark.filterwarnings("ignore::RuntimeWarning")
  def test_error_when_creating_from_non_filelike_object(self, no_sound_device):

    with pytest.raises(BassFileFormatError):
      strm = Stream.from_file_obj(object(), device=no_sound_device)
