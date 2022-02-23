from Bass4Py.constants import ALGORITHM_3D
from Bass4Py.exceptions import BassPlatformError

import pytest
import sys

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

  def test_async_buffer_property(self, bass):
    assert type(bass.async_buffer) == int
  
  @pytest.mark.bass_property("async_buffer")
  def test_async_buffer_property_setter(self, bass):
    bass.async_buffer = 4096
    assert bass.async_buffer == 8192

  def test_buffer_property(self, bass):
    assert type(bass.buffer) == int
  
  @pytest.mark.bass_property("buffer")
  def test_buffer_property_setter(self, bass):
    bass.buffer = 100
    assert bass.buffer == 100

  def test_curve_volume_property(self, bass):
    assert type(bass.curve_volume) == bool
  
  @pytest.mark.bass_property("curve_volume")
  def test_curve_volume_property_setter(self, bass):
    bass.curve_volume = True
    assert bass.curve_volume is True
  
  def test_curve_pan_property(self, bass):
    assert type(bass.curve_pan) == bool
  
  @pytest.mark.bass_property("curve_pan")
  def test_curve_pan_property_setter(self, bass):
    bass.curve_pan = True
    assert bass.curve_pan is True
  
  @pytest.mark.not_osx
  def test_device_buffer_property(self, bass):
    assert type(bass.device_buffer) == int
    
  @pytest.mark.not_osx
  @pytest.mark.bass_property("device_buffer")
  def test_device_buffer_property_setter(self, bass):
    bass.device_buffer = 100
    assert bass.device_buffer == 100
  
  @pytest.mark.osx
  def test_device_buffer_property_raises_error_on_osx(self, bass):
    with pytest.raises(BassPlatformError):
      bass.device_buffer
  
  @pytest.mark.osx
  def test_device_buffer_property_setter_raises_error_on_osx(self, bass):
    with pytest.raises(BassPlatformError):
      bass.device_buffer = 100

  @pytest.mark.skipif(condition=sys.platform.startswith("linux"), reason="Skip on Linux")
  def test_default_device_property(self, bass):
    assert type(bass.default_device) == bool
  
  @pytest.mark.skipif(condition=sys.platform.startswith("linux"), reason="Skip on Linux")
  @pytest.mark.bass_property("default_device")
  def test_default_device_property_setter(self, bass):
    bass.default_device = True
    assert bass.default_device is True
  
  @pytest.mark.linux
  def test_default_device_property_raises_error_on_linux(self, bass):
    with pytest.raises(BassPlatformError):
      bass.default_device
  
  @pytest.mark.linux
  def test_default_device_property_setter_raises_error_on_linux(self, bass):
    with pytest.raises(BassPlatformError):
      bass.default_device = True

  def test_float_dsp_property(self, bass):
    assert type(bass.float_dsp) == bool
  
  @pytest.mark.bass_property("float_dsp")
  def test_float_dsp_property_setter(self, bass):
    bass.float_dsp = True
    assert bass.float_dsp is True
  
  def test_music_volume_property(self, bass):
    assert type(bass.music_volume) == int
  
  @pytest.mark.bass_property("music_volume")
  def test_music_volume_property_setter(self, bass):
    # for some weird reason, the value doesn't seem to be set to the exact value input
    # e.g. when trying to set it to 8000, it will be set to 7999 instead
    # for now, we're just checking if the value changed instead of checking for equality
    orig = bass.music_volume
    bass.music_volume = 8000
    assert bass.music_volume != orig

  def test_sample_volume_property(self, bass):
    assert type(bass.sample_volume) == int
  
  @pytest.mark.bass_property("sample_volume")
  def test_sample_volume_property_setter(self, bass):
    orig = bass.sample_volume
    bass.sample_volume = 8000
    assert bass.sample_volume != orig

  def test_stream_volume_property(self, bass):
    assert type(bass.stream_volume) == int
  
  @pytest.mark.bass_property("stream_volume")
  def test_stream_volume_property_setter(self, bass):
    orig = bass.stream_volume
    bass.stream_volume = 8000
    assert bass.stream_volume != orig

  @pytest.mark.windows
  def test_mf_video_property(self, bass):
    assert type(bass.mf_video) == bool
  
  @pytest.mark.windows
  @pytest.mark.bass_property("mf_video")
  def test_mf_video_property_setter(self, bass):
    bass.mf_video = True
    assert bass.mf_video is True
  
  @pytest.mark.posix
  def test_mf_video_property_raising_error_on_non_windows(self, bass):
    with pytest.raises(BassPlatformError):
      bass.mf_video
  
  @pytest.mark.posix
  def test_mf_video_property_setter_raising_error_on_non_windows(self, bass):
    with pytest.raises(BassPlatformError):
      bass.mf_video = True

  @pytest.mark.windows
  def test_mf_disable_property(self, bass):
    assert type(bass.mf_disable) == bool
  
  @pytest.mark.windows
  @pytest.mark.bass_property("mf_disable")
  def test_mf_disable_property_setter(self, bass):
    bass.mf_disable = True
    assert bass.mf_disable is True
  
  @pytest.mark.posix
  def test_mf_disable_property_raising_error_on_non_windows(self, bass):
    with pytest.raises(BassPlatformError):
      bass.mf_disable
  
  @pytest.mark.posix
  def test_mf_disable_property_setter_raising_error_on_non_windows(self, bass):
    with pytest.raises(BassPlatformError):
      bass.mf_disable = True

  def test_virtual_channels_property(self, bass):
    assert type(bass.virtual_channels) == int
    
  @pytest.mark.bass_property("virtual_channels")
  def test_virtual_channels_property_setter(self, bass):
    bass.virtual_channels = 384
    assert bass.virtual_channels == 384

  def test_net_buffer_property(self, bass):
    assert type(bass.net_buffer) == int
    
  @pytest.mark.bass_property("net_buffer")
  def test_net_buffer_property_setter(self, bass):
    bass.net_buffer = 100
    assert bass.net_buffer == 100

  def test_net_passive_property(self, bass):
    assert type(bass.net_passive) == bool
  
  @pytest.mark.bass_property("net_passive")
  def test_net_passive_property_setter(self, bass):
    bass.net_passive = False
    assert bass.net_passive is False

  def test_net_playlist_property(self, bass):
    assert type(bass.net_playlist) == int
    
  @pytest.mark.bass_property("net_playlist")
  def test_net_playlist_property_setter(self, bass):
    bass.net_playlist = 2
    assert bass.net_playlist == 2

  def test_net_playlist_depth_property(self, bass):
    assert type(bass.net_playlist_depth) == int
    
  @pytest.mark.bass_property("net_playlist_depth")
  def test_net_playlist_depth_property_setter(self, bass):
    bass.net_playlist_depth = 2
    assert bass.net_playlist_depth == 2

  def test_net_prebuf_property(self, bass):
    assert type(bass.net_prebuf) == int
    
  @pytest.mark.bass_property("net_prebuf")
  def test_net_prebuf_property_setter(self, bass):
    bass.net_prebuf = 100
    assert bass.net_prebuf == 100

  def test_net_prebuf_wait_property(self, bass):
    assert type(bass.net_prebuf_wait) == bool
    
  @pytest.mark.bass_property("net_prebuf_wait")
  def test_net_prebuf_wait_property_setter(self, bass):
    bass.net_prebuf_wait = True
    assert bass.net_prebuf_wait is True

  def test_net_timeout_property(self, bass):
    assert type(bass.net_timeout) == int
    
  @pytest.mark.bass_property("net_timeout")
  def test_net_timeout_property_setter(self, bass):
    bass.net_timeout = 1000
    assert bass.net_timeout == 1000

  def test_net_read_timeout_property(self, bass):
    assert type(bass.net_read_timeout) == int
    
  @pytest.mark.bass_property("net_read_timeout")
  def test_net_read_timeout_property_setter(self, bass):
    bass.net_read_timeout = 500
    assert bass.net_read_timeout == 500

  def test_ogg_prescan_property(self, bass):
    assert type(bass.ogg_prescan) == bool
  
  @pytest.mark.bass_property("ogg_prescan")
  def test_ogg_prescan_property_setter(self, bass):
    bass.ogg_prescan = False
    assert bass.ogg_prescan is False

  def test_pause_noplay_property(self, bass):
    assert type(bass.pause_noplay) == bool
  
  @pytest.mark.bass_property("pause_noplay")
  def test_pause_noplay_property_setter(self, bass):
    bass.pause_noplay = False
    assert bass.pause_noplay is False

  def test_record_buffer_property(self, bass):
    assert type(bass.record_buffer) == int
    
  @pytest.mark.bass_property("record_buffer")
  def test_record_buffer_property_setter(self, bass):
    bass.record_buffer = 3000
    assert bass.record_buffer == 3000

  def test_src_property(self, bass):
    assert type(bass.src) == int
    
  @pytest.mark.bass_property("src")
  def test_src_property_setter(self, bass):
    bass.src = 0
    assert bass.src == 0

  def test_src_sample_property(self, bass):
    assert type(bass.src_sample) == int
    
  @pytest.mark.bass_property("src_sample")
  def test_src_sample_property_setter(self, bass):
    bass.src_sample = 0
    assert bass.src_sample == 0

  def test_update_period_property(self, bass):
    assert type(bass.update_period) == int
    
  @pytest.mark.bass_property("update_period")
  def test_update_period_property_setter(self, bass):
    bass.update_period = 50
    assert bass.update_period == 50

  def test_update_threads_property(self, bass):
    assert type(bass.update_threads) == int
    
  @pytest.mark.bass_property("update_threads")
  def test_update_threads_property_setter(self, bass):
    bass.update_threads = 0
    assert bass.update_threads == 0

  def test_verify_property(self, bass):
    assert type(bass.verify) == int
    
  @pytest.mark.bass_property("verify")
  def test_verify_property_setter(self, bass):
    bass.verify = 24000
    assert bass.verify == 24000

  def test_net_verify_property(self, bass):
    assert type(bass.net_verify) == int
    
  @pytest.mark.bass_property("net_verify")
  def test_net_verify_property_setter(self, bass):
    bass.net_verify = 24000
    assert bass.net_verify == 24000

  def test_device_update_period_property(self, bass):
    assert type(bass.device_update_period) == int
    
  @pytest.mark.bass_property("device_update_period")
  def test_device_update_period_property_setter(self, bass):
    bass.device_update_period = -100
    assert bass.device_update_period == -100

  def test_handles_property(self, bass):
    assert bass.handles == 0

  @pytest.mark.windows
  def test_wasapi_persist_property(self, bass):
    assert type(bass.wasapi_persist) == bool
  
  @pytest.mark.windows
  @pytest.mark.bass_property("wasapi_persist")
  def test_wasapi_persist_property_setter(self, bass):
    bass.wasapi_persist = False
    assert bass.wasapi_persist is False
  
  @pytest.mark.posix
  def test_wasapi_persist_property_raising_error_on_non_windows(self, bass):
    with pytest.raises(BassPlatformError):
      bass.wasapi_persist
  
  @pytest.mark.posix
  def test_wasapi_persist_property_setter_raising_error_on_non_windows(self, bass):
    with pytest.raises(BassPlatformError):
      bass.wasapi_persist = False

  @pytest.mark.linux
  def test_lib_ssl_property_none(self, bass):
    assert type(bass.lib_ssl) is None
  
  @pytest.mark.linux
  @pytest.mark.bass_property("lib_ssl")
  def test_lib_ssl_property_setter_str(self, bass):
    bass.lib_ssl = ''
    assert bass.lib_ssl == ''

  @pytest.mark.linux
  @pytest.mark.bass_property("lib_ssl")
  def test_lib_ssl_property_setter_none(self, bass):
    bass.lib_ssl = None
    assert bass.lib_ssl is None

  @pytest.mark.skipif(condition=sys.platform.startswith("linux"), reason="Skip on Linux")
  def test_lib_ssl_property_raising_error_on_non_linux(self, bass):
    with pytest.raises(BassPlatformError):
      bass.lib_ssl

  @pytest.mark.skipif(condition=sys.platform.startswith("linux"), reason="Skip on Linux")
  def test_lib_ssl_property_setter_raising_error_on_non_linux(self, bass):
    with pytest.raises(BassPlatformError):
      bass.lib_ssl = ''
