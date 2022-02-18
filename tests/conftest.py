from Bass4Py.bass import BASS
import os.path
import pathlib
import pytest

AUDIO_DIR = os.path.join(
  os.path.dirname(os.path.realpath(__file__)),
  'audio',
  )

@pytest.fixture
def bass():

  return BASS()

@pytest.fixture
def audio_files():
  return pathlib.Path(AUDIO_DIR)
