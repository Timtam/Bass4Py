from Bass4Py.bass import BASS
import os.path
import pathlib
import pytest

AUDIO_DIR = os.path.join(
  os.path.dirname(os.path.realpath(__file__)),
  'audio',
  )

def pytest_configure(config):
  config.addinivalue_line(
    "markers", "bass_property(name): automatically restore a property to its original value after usage"
  )

@pytest.fixture
def bass():

  return BASS()

@pytest.fixture(autouse=True)
def bass_property(request, bass):

  property_name = request.node.get_closest_marker("bass_property")
  
  if property_name is not None:
    property_name = property_name.args[0]
  
    orig_value = getattr(bass, property_name)
  
  yield
  
  if property_name is not None:

    setattr(bass, property_name, orig_value)

@pytest.fixture
def audio_files():
  return pathlib.Path(AUDIO_DIR)
