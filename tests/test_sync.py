from Bass4Py.BASS import bass
from Bass4Py.BASS.syncs.download import SYNC_DOWNLOAD
from Bass4Py.BASS.syncs.music_instrument import SYNC_MUSIC_INSTRUMENT
from Bass4Py.exceptions import BassSyncError
import os.path
import unittest

class TestSync(unittest.TestCase):

  def setUp(self):
    self.bass = bass.BASS()
    self.device = self.bass.GetOutputDevice(0)
    self.device.Init(44100, 0, 0)

    # paths
    self.music_path = os.path.join(os.path.dirname(__file__), "audio", "sapphire_eyes.xm")
    self.stream_path = os.path.join(os.path.dirname(__file__), "audio", "sos.wav")

  def tearDown(self):
    self.device.Free()

  def test_stream_only_sync(self):

    def s_download(strm, *args, **kwargs):
      pass

    music = self.device.CreateMusicFromFile(self.music_path)
    sync = SYNC_DOWNLOAD()
    sync.Callback = s_download
    self.assertRaises(BassSyncError, sync.Set, music)
    music.Free()

  def test_music_only_sync(self):
    def s_music_instrument(msc, *args, **kwargs):
      pass
    
    stream = self.device.CreateStreamFromFile(self.stream_path)
    minst = SYNC_MUSIC_INSTRUMENT()
    minst.Callback = s_music_instrument
    self.assertRaises(BassSyncError, minst.Set, stream)
    stream.Free()