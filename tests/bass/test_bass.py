from Bass4Py.constants import ALGORITHM_3D

import pytest

class TestBASS:

  def test_update(self, bass):
    assert bass.update(200) is True
  
  def test_cpu_property_type(self, bass):
    assert type(bass.cpu) == float
  
  def test_device_property_returning_none_when_uninitialized(self, bass):
    assert bass.device is None
  
  def test_device_property_returning_current_device_when_initialized(self, bass, no_sound_device):
    assert bass.device == no_sound_device

  def test_net_agent_property_type(self, bass):
    assert type(bass.net_agent) == str
  
  @pytest.mark.bass_property("net_agent")
  def test_net_agent_property_setter(self, bass):
    bass.net_agent = ''
    assert bass.net_agent == ''

  def test_net_proxy_property_type_str(self, bass):
    assert type(bass.net_proxy) == str
  
  @pytest.mark.bass_property("net_proxy")
  def test_net_proxy_property_setter_str(self, bass):
    bass.net_proxy = ''
    assert bass.net_proxy == ''

  @pytest.mark.bass_property("net_proxy")
  def test_net_proxy_property_setter_none(self, bass):
    bass.net_proxy = None
    assert bass.net_proxy is None

  def test_algorithm_3d_property(self, bass):
    assert type(bass.algorithm_3d) == ALGORITHM_3D
  
  @pytest.mark.bass_property("algorithm_3d")
  def test_algorithm_3d_property_setter(self, bass):
    bass.algorithm_3d = ALGORITHM_3D.OFF
    assert bass.algorithm_3d == ALGORITHM_3D.OFF
