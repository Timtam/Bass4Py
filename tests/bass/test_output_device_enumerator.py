import pytest

@pytest.mark.order(1)
class TestOutputDeviceEnumerator:

  def test_first_device_is_no_sound_device(self, bass):
  
    assert bass.output_devices[0].name == 'No sound'

  def test_default_device_is_default_device(self, bass):
  
    assert bass.output_devices.default.default is True

  def test_negative_index_returns_default_device(self, bass):
  
    assert bass.output_devices.default == bass.output_devices[-1]
