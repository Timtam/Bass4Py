from Bass4Py.constants import STREAM
import pytest
import wave

@pytest.fixture
def no_sound_device(bass):

  device = bass.output_devices[0]
  device.init()
  
  yield device
  
  device.free()

@pytest.fixture
def sos_wave(audio_files):

  wave_file = wave.open(str(audio_files / 'sos.wav'), 'rb')

  yield wave_file
  
  wave_file.close()

@pytest.fixture
def sos_bass_stream(audio_files, no_sound_device):

  wave_file = no_sound_device.create_stream_from_file(str(audio_files / 'sos.wav'), STREAM.DECODE)
    
  yield wave_file
  
  wave_file.free()

@pytest.fixture
def sapphire_eyes_bass_music(audio_files, no_sound_device):

  music_file = no_sound_device.create_music_from_file(str(audio_files / 'sapphire_eyes.xm'))
    
  yield music_file
  
  music_file.free()
