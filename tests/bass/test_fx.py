from Bass4Py.exceptions import BassOutOfRangeError
from Bass4Py.bass.effects.dx8 import Parameq
import platform
import pytest

class TestFX:

  @pytest.fixture
  def effect(self):
    return Parameq()

  def get_bounds(self, stream):
    if platform.uname()[0] == "Windows":
      lbound = 80.0
      ubound = int(stream.default_frequency/3) - 1
    else:
      lbound = 1.0
      ubound = int(stream.default_frequency/2) - 1
    return (lbound, ubound, )

  def test_limits_before_link(self, effect):

    if platform.uname()[0] == "Windows":
      bounds = (80.0, 16000.0, )
    else:
      bounds = (1.0, 20000.0, )

    with pytest.raises(BassOutOfRangeError):
      effect.center = bounds[1] + 1

  def test_limits_after_link(self, sos_bass_stream, effect):

    effect.set(sos_bass_stream)

    bounds = self.get_bounds(sos_bass_stream)
    
    with pytest.raises(BassOutOfRangeError):
      effect.center = bounds[1] + 1

    effect.remove()
