from Bass4Py.bass.syncs import Download
from Bass4Py.bass.syncs import MusicInstrument
from Bass4Py.exceptions import BassSyncError
import pytest

class TestSync:

  def test_stream_only_sync(self, sapphire_eyes_bass_music):

    def s_download(strm, *args, **kwargs):
      pass

    sync = Download()
    sync.callback = s_download

    with pytest.raises(BassSyncError):
      sync.set(sapphire_eyes_bass_music)

  def test_music_only_sync(self, sos_bass_stream):
    def s_music_instrument(msc, *args, **kwargs):
      pass
    
    minst = MusicInstrument()
    minst.callback = s_music_instrument

    with pytest.raises(BassSyncError):
      minst.set(sos_bass_stream)
