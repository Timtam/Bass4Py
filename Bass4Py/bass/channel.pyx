from cpython.mem cimport PyMem_Malloc, PyMem_Free
from libc.string cimport memmove

from ..bindings.bass cimport (
  _BASS_ATTRIB_BUFFER,
  _BASS_ATTRIB_CPU,
  _BASS_ATTRIB_NORAMP,
  _BASS_ATTRIB_TAIL,
  _BASS_MUSIC_POSRESET,
  _BASS_MUSIC_POSRESETEX,
  _BASS_NODEVICE,
  _BASS_POS_BYTE,
  _BASS_POS_DECODETO,
  _BASS_POS_FLUSH,
  _BASS_POS_INEXACT,
  _BASS_POS_MUSIC_ORDER,
  _BASS_POS_RELATIVE,
  _BASS_POS_RESET,
  _BASS_POS_SCAN,
  _BASS_SAMPLE_LOOP,
  _BASS_TAG_ID3V2,
  BASS_Apply3D,
  BASS_ChannelFlags,
  BASS_ChannelGet3DAttributes,
  BASS_ChannelGet3DPosition,
  BASS_ChannelGetDevice,
  BASS_ChannelGetTags,
  BASS_ChannelPlay,
  BASS_ChannelRemoveLink,
  BASS_ChannelSet3DAttributes,
  BASS_ChannelSet3DPosition,
  BASS_ChannelSetDevice,
  BASS_ChannelSetLink,
  BASS_ChannelSetPosition,
  BASS_FXReset,
  MAKELONG)

from .channel_base cimport ChannelBase
from .output_device cimport OutputDevice
from .dsp cimport DSP
from .sync cimport Sync
from .vector cimport Vector, CreateVector
from ..exceptions import BassAPIError, BassAttributeError

cdef class Channel(ChannelBase):
  """
  .. todo::

     The reset parameter to :meth:`Bass4Py.bass.Channel.set_position` isn't yet 
     supported and requires a new method (reset?) for the channel class.

  .. todo::

     3D properties need to be reworked. Right now, each call to their setters 
     will result in BASS_Apply3D() being executed, which makes them non-atomic 
     and might cause issues when changing multiple settings in quick succession. 
     I also don't like the naming scheme right now, it's not intuitive and 
     doesn't refer to 3D settings by just looking at them.
   
  .. todo::
  
     :meth:`~Bass4Py.bass.Channel.get_tags` requires custom implementations to 
     properly return the plain tag data for all different tag formats. But we 
     also do have the :class:`~Bass4Py.tags.Tags` extension which allows us to 
     interpret at least ID3 tags properly. What should we do now then?
     
     * properly implement :meth:`~Bass4Py.bass.Channel.get_tags` plus 
       :class:`~Bass4Py.tags.Tags` extension?
     * get rid of :meth:`~Bass4Py.bass.Channel.get_tags` completely and 
       implement the :class:`~Bass4Py.tags.Tags` extension properly instead?
     * should we bind the Tags extension to the Channel object directly or 
       handle it as an external class which can be executed by handing it the 
       :class:`~Bass4Py.bass.Channel` as a parameter?

  """

  cdef void _set_handle(Channel self, HCHANNEL handle):
    cdef DWORD dev

    ChannelBase._set_handle(self, handle)

    dev = BASS_ChannelGetDevice(self._channel)
    
    self._evaluate()
    
    if dev == _BASS_NODEVICE:
      self._device = None
    else:
      self._device = OutputDevice(dev)

  cdef void _init_attributes(Channel self):

    ChannelBase._init_attributes(self)

    self.buffer = FloatAttribute(self._channel, _BASS_ATTRIB_BUFFER)
    self.cpu = FloatAttribute(self._channel, _BASS_ATTRIB_CPU, True)
    self.no_ramping = BoolAttribute(self._channel, _BASS_ATTRIB_NORAMP)
    self.tail = FloatAttribute(self._channel, _BASS_ATTRIB_TAIL)

  cdef DWORD _get_flags(Channel self):
    return BASS_ChannelFlags(self._channel, 0, 0)

  cpdef _set_flags(Channel self, DWORD flag, bint switch):
    if switch:
      BASS_ChannelFlags(self._channel, flag, flag)
    else:
      BASS_ChannelFlags(self._channel, 0, flag)
    self._evaluate()

  cpdef play(Channel self, bint restart=False):
    """
    Starts (or resumes) playback. 

    Parameters
    ----------
    restart : :obj:`bool`
      Restart playback from the beginning? If this is a user stream (created 
      with :meth:`Bass4Py.bass.OutputDevice.create_stream_from_parameters` or 
      :meth:`Bass4Py.bass.Stream.from_parameters`), its current buffer contents 
      are cleared. If this is a :class:`Bass4Py.bass.Music`, its BPM/etc are 
      reset to their initial values. 

    Returns
    -------
    :obj:`bool`
      success

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassStartError`
      The output is paused/stopped, use :meth:`Bass4Py.bass.OutputDevice.start` 
      to start it. 
    :exc:`Bass4Py.exceptions.BassDecodeError`
      The channel is not playable; it is a "decoding channel". 


    When streaming in blocks (:attr:`Bass4Py.constants.STREAM.BLOCK`), the 
    restart parameter is ignored as it is not possible to go back to the start. 
    The restart parameter is also of no consequence with recording channels. 
    If other channels have been linked to the specified channel via 
    :meth:`~Bass4Py.bass.Channel.link`, this function will attempt to 
    simultaneously start playing them too but if any fail, it will be silently. 
    The exception raised only reflects what happened with the specified channel. 
    :attr:`Bass4Py.bass.Channel.active` can be used to confirm the status of 
    linked channels. 
    """
    cdef bint res
    res = BASS_ChannelPlay(self._channel, restart)
    self._evaluate()
    return res

  cpdef set_sync(Channel self, Sync sync):
    """
    Sets up a synchronizer. 
    
    Parameters
    ----------
    sync : :obj:`Bass4Py.bass.Sync`
      One of the subclasses of :obj:`Bass4Py.bass.Sync`, which can be found in 
      the :mod:`Bass4Py.bass.syncs` package.

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassSyncError`
      Either a callback wasn't provided when creating the sync object or the 
      required parameters weren't set beforehand. Please read the documentation 
      of the according sync object and read the raised exception for more 
      details.


    Multiple synchronizers may be used per channel, and they can be set before 
    and while playing. Equally, synchronizers can also be removed at any time, 
    using :meth:`Bass4Py.bass.Sync.remove`. If the 
    :attr:`Bass4Py.bass.Sync.one_time` attribute is used then the sync is 
    automatically removed after its first occurrence. 
    The method :meth:`Bass4Py.bass.Sync.set_mix_time` (with threading disabled) 
    can be used with :class:`Bass4Py.bass.syncs.End` or 
    :class:`Bass4Py.bass.syncs.Position` / 
    :class:`Bass4Py.bass.syncs.MusicPosition` syncs to implement custom 
    looping, by using :meth:`~Bass4Py.bass.Channel.set_position` in the callback. 
    A mixtime sync can also be used to make DSP/FX changes at specific points, 
    or change a :class:`Bass4Py.bass.Music` channel's attributes. The 
    :meth:`Bass4Py.bass.Sync.set_mix_time` method can also be useful with a 
    :class:`Bass4Py.bass.syncs.SetPosition` sync, to reset DSP states after 
    seeking. 
    Several of the sync types are triggered in the process of rendering the 
    channel's sample data; for example, :class:`Bass4Py.bass.syncs.Position` 
    and :class:`Bass4Py.bass.syncs.End` syncs, when the rendering reaches the 
    sync position or the end, respectively. Those sync types should be set 
    before starting playback or pre-buffering (ie. before any rendering), to 
    avoid missing any early sync events. 
    A channel does not need to be playing for its 
    :class:`Bass4Py.bass.syncs.DeviceFail` and 
    :class:`Bass4Py.bass.syncs.DeviceFormat` syncs to be triggered but the 
    device does need to be active, which means it needs to be playing other 
    channels or the :attr:`Bass4Py.bass.BASS.device_nonstop` option needs to be 
    enabled. 
    With recording channels, :class:`Bass4Py.bass.syncs.Position` syncs are 
    triggered just before the callback receives the block of data containing 
    the sync position. 
    """
    (<object>sync).set(self)

  cpdef set_fx(Channel self, FX fx):
    """
    Apply an effect to this channel. 

    Parameters
    ----------
    fx : :obj:`Bass4Py.bass.FX`
      one of the subclasses of :class:`Bass4Py.bass.FX`, which can be found 
      within the :mod:`Bass4Py.bass.effects` package.

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassNoFXError`
      The specified DX8 effect is unavailable. 
    :exc:`Bass4Py.exceptions.BassFormatError`
      The channel's format is not supported by the effect. 
    :exc:`Bass4Py.exceptions.BassUnknownError`
      Some other mystery problem! 


    Multiple effects may be used per channel. Use 
    :meth:`Bass4Py.bass.FX.remove` to remove an effect. Use the effect-specific 
    attributes to set an effect's parameters. An effect's priority value can be 
    changed via the :attr:`Bass4Py.bass.FX.priority` attribute. 
    Effects can be applied to :class:`Bass4Py.bass.Music` and 
    :class:`Bass4Py.bass.Stream`, but not :class:`Bass4Py.bass.Sample`. If you 
    want to apply an effect to a sample, you could use a stream instead. 

    Platform-specific

    DX8 effects are a Windows feature requiring DirectX 8, or DirectX 9 for 
    floating-point support. On other platforms, they are emulated by BASS, 
    except for the following which are currently unsupported: 
    :class:`Bass4Py.bass.effects.dx8.Compressor`, 
    :class:`Bass4Py.bass.effects.dx8.Gargle`, and 
    :class:`Bass4Py.bass.effects.dx8.I3DL2Reverb`. 
    """
    (<object>fx).set(self)

  cpdef reset_fx(Channel self):
    """
    Resets the state of all effects on this channel. 

    Returns
    -------
    :obj:`bool`
      success
    
    Raises
    ------
    :exc:`Bass4Py.exceptions.BassUnknownError`
      Some other mystery problem! 


    This method flushes the internal buffers of the effects. Effects are 
    automatically reset by :meth:`~Bass4Py.bass.Channel.set_position`, except 
    when called from a "mixtime" :attr:`Bass4Py.bass.Sync.callback`. 
    """
    cdef bint res
    res = BASS_FXReset(self._channel)
    self._evaluate()
    return res

  cpdef set_dsp(Channel self, DSP dsp):
    """
    Sets up a :class:`Bass4Py.bass.DSP` on this channel. 

    Parameters
    ----------
    dsp : :obj:`Bass4Py.bass.DSP`
      the dsp object
    
    
    DSPs can be set and removed at any time, including mid-playback. Use 
    :meth:`Bass4Py.bass.DSP.remove` to remove a DSP from a channel. 
    Multiple DSP functions may be used per channel, in which case the order 
    that the callbacks are called is determined by their priorities. The 
    priorities can be changed via the :attr:`Bass4Py.bass.DSP.priority` 
    attribute. Any DSPs that have the same priority are called in the order 
    that they were given that priority. 
    DSPs can be applied to :class:`Bass4Py.bass.Music` and 
    :class:`Bass4Py.bass.Stream`, but not :class:`Bass4Py.bass.Sample`. If you 
    want to apply a DSP to a sample then you should stream it instead. 
    """
    dsp.set(self)

  cpdef link(Channel self, Channel channel):
    """
    Links two :class:`Bass4Py.bass.Music` or :class:`Bass4Py.bass.Stream` 
    channels together. 

    Parameters
    ----------
    channel : :obj:`Bass4Py.bass.Channel`
      the channel to link with
    
    Returns
    -------
    :obj:`bool`
      success
    
    Raises
    ------
    :exc:`Bass4Py.exceptions.BassHandleError`
      At least one of channels is not a valid channel (only 
      :class:`Bass4Py.bass.Music` or :class:`Bass4Py.bass.Stream` are supported).
    :exc:`Bass4Py.exceptions.BassDecodeError`
      At least one of the channels is a "decoding channel", so cannot be linked. 
    :exc:`Bass4Py.exceptions.BassAlreadyError`
      the channels are already linked together. 
    :exc:`Bass4Py.exceptions.BassUnknownError`
      Some other mystery problem! 


    Linked channels are started/stopped/paused/resumed together. Linked 
    channels on the same device are guaranteed to start playing simultaneously. 
    Links are one-way: starting playback on this channel will result in the 
    linked channel starting playback as well, but not vice versa unless another 
    link has been set in that direction. 
    If a linked channel has reached the end, it will not be restarted when a 
    channel it is linked to is started. If you want a linked channel to be 
    restarted, you will need to have resetted its position using 
    :meth:`~Bass4Py.bass.Channel.set_position` beforehand. 
    """
    cdef bint res
    res = BASS_ChannelSetLink(self._channel, channel._channel)
    self._evaluate()
    return res

  cpdef unlink(Channel self, Channel channel):
    """
    Removes a link between two :class:`Bass4Py.bass.Music` or 
    :class:`Bass4Py.bass.Stream` channels. 

    Parameters
    ----------
    channel : :obj:`Bass4Py.bass.Channel`
      the channel to unlink
    
    Returns
    -------
    :obj:`bool`
      success
    
    Raises
    ------
    :exc:`Bass4Py.exceptions.BassAlreadyError`
      either one of the channels cannot be linked (only 
      :class:`Bass4Py.bass.Music` or :class:`Bass4Py.bass.Stream` are 
      supported), or the two channels are already unlinked. 
    """
    cdef bint res
    res = BASS_ChannelRemoveLink(self._channel, channel._channel)
    self._evaluate()
    return res

  cpdef set_position(Channel self, object pos, DWORD mode=_BASS_POS_BYTE, bint decodeto=False, bint flush=False, bint inexact=False, bint relative=False, bint scan=False, bint stop_when_seeking=False, bint reset_when_seeking=False):
    """
    Sets the playback position.

    Parameters
    ----------
    pos : :obj:`int` or :obj:`tuple`
      the playback position. When the mode parameter is set to 
      :attr:`Bass4Py.constants.POSITION.MUSIC_ORDER`, a tuple with two entries 
      (order, row) is required, otherwise an integer.
    mode : :class:`Bass4Py.constants.POSITION`
      one of the following:
      
      - :attr:`Bass4Py.constants.POSITION.BYTE` (default): The position is in 
        bytes, which will be rounded down to the nearest sample boundary.
      - :attr:`Bass4Py.constants.POSITION.MUSIC_ORDER`: The position is a tuple 
        with order and row (available for :class:`Bass4Py.bass.Music` only)
      - :attr:`Bass4Py.constants.POSITION.OGG`: The position is a bitstream 
        number in an OGG file... 0 = first. 
      - :attr:`Bass4Py.constants.POSITION.END`: The position is in bytes and is 
        where the channel will end... 0 = normal end position. This will have 
        no effect if it is beyond the channel's normal end position. If the 
        channel is already at/beyond the position then it will end at its 
        current position. 
      - :attr:`Bass4Py.constants.POSITION.LOOP`: The position is in bytes and 
        is where looping will start from (when looping is enabled). If this is 
        at/beyond the end then the default loop position of 0 will be used 
        instead. 

    decodeto : :obj:`bool`
      Decode/render up to the position rather than seeking to it. This is 
      useful for streams that are unseekable or that have inexact seeking, but 
      it is generally slower than normal seeking and the requested position 
      cannot be behind the current decoding position. This flag can only be 
      used with the :attr:`Bass4Py.constants.POSITION.BYTE` mode. 
    flush : :obj:`bool`
      Flush all output buffers (including FX) so that no remnant of the old 
      position is heard after seeking. This is automatic on normal playback 
      channels (not decoding channels) outside of a "mixtime" 
      :class:`Bass4Py.bass.Sync`. 
    inexact : :obj:`bool`
      Allow inexact seeking. For speed, seeking may stop at the beginning of a 
      block rather than partially processing the block to reach the requested 
      position. 
    relative : :obj:`bool`
      The requested position is relative to the current position. pos can be 
      negative in this case. 
    scan : :obj:`bool`
      Scan the file to build a seek table up to the position, if it has not 
      already been scanned. Scanning will continue from where it left off 
      previously rather than restarting from the beginning of the file each 
      time. This flag only applies to MP3/MP2/MP1 files and will be ignored 
      with other file formats. 
    stop_when_seeking : :obj:`bool`
      Stop all notes. This flag is applied automatically if it has been set on 
      the channel via the :attr:`Bass4Py.bass.Music.stop_when_seeking` 
      attribute. (available for :class:`Bass4Py.bass.Music` only) 
    reset_when_seeking : :obj:`bool`
      Stop all notes and reset bpm/etc to defaults. This flag is applied 
      automatically if it has been set on the channel via the 
      :attr:`Bass4Py.bass.Music.reset_when_seeking` attribute. (available for 
      :class:`Bass4Py.bass.Music` only) 

    Returns
    -------
    :obj:`bool`
      success
    
    Raises
    ------
    :exc:`Bass4Py.exceptions.BassNotAFileError`
      The stream is not a file stream. 
    :exc:`Bass4Py.exceptions.BassPositionError`
      The requested position is invalid, eg. it is beyond the end or the 
      download has not yet reached it. 
    :exc:`Bass4Py.exceptions.BassNotAvailableError`
      The requested mode is not available. Invalid flags are ignored and do not 
      result in this error. 
    :exc:`Bass4Py.exceptions.BassUnknownError`
      Some other mystery problem! 


    Setting the position of a :class:`Bass4Py.bass.Music` in bytes (other than 
    0) requires that the :attr:`Bass4Py.constants.MUSIC.PRESCAN` flag was used 
    in the :meth:`Bass4Py.bass.OutputDevice.create_music_from_file` call, or 
    the use of the decodeto flag. When setting the position in orders and rows, 
    the channel's byte position (as reported by 
    :meth:`~Bass4Py.bass.ChannelBase.get_position`) is reset to 0. That is 
    because it is not possible to get the byte position of an order/row 
    position; it is possible for an order/row position to never be played in 
    the normal course of events, or it may be played multiple times. 
    When setting the position of a :class:`Bass4Py.bass.Music`, and the 
    stop_when_seeking flag is active, all notes that were playing before the 
    position changed will be stopped. Otherwise, the notes will continue 
    playing until they are stopped in the MOD music. When setting the position 
    in bytes, the BPM, speed and global volume are updated to what they would 
    normally be at the new position. Otherwise they are left as they were prior 
    to the position change, unless the seek position is 0 (the start), in which 
    case they are also reset to the starting values (with the stop_when_seeking 
    flag). When the reset_when_seeking flag is active, the BPM, speed and 
    global volume are reset with every seek. The reset_when_seeking flag (or 
    seeking to position 0) also resets channel volume and panning to defaults.
    For MP3/MP2/MP1 streams, unless the file is scanned via the scan flag or 
    the :attr:`Bass4Py.constants.STREAM.PRESCAN` flag at stream creation, 
    seeking will be approximate but generally still quite accurate. Besides 
    scanning, exact seeking can also be achieved with the decodeto flag. 
    Seeking in internet file (and "buffered" user file) streams is possible 
    once the download has reached the requested position, so long as the file 
    is not being streamed in blocks (:attr:`Bass4Py.constants.STREAM.BLOCK` 
    flag). 
    The stop_when_seeking flag can be used to reset/flush a buffered user file 
    stream, so that new data can be processed, but it may not be supported by 
    some decoders. When it is not supported, 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file_obj` can be used 
    again instead to create a new stream for the new data. 
    User streams (created with 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_parameters`) are not 
    seekable, but it is possible to reset a user stream (including its buffer 
    contents) by setting its position to byte 0. 
    The decodeto flag can be used to seek forwards in streams that are not 
    normally seekable, like custom streams or internet streams that are using 
    the :attr:`Bass4Py.constants.STREAM.BLOCK` flag, but it will only go as far 
    as what is currently available; it will not wait for more data to be 
    downloaded, for example. 
    In some cases, particularly when the inexact flag is used, the new position 
    may not be what was requested. 
    :meth:`~Bass4Py.bass.ChannelBase.get_position` can be used to confirm what 
    the new position actually is. 
    The scan flag works the same way as the 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file` 
    :attr:`Bass4Py.constants.STREAM.PRESCAN` flag, and can be used to delay the 
    scanning until after the stream has been created. When a position beyond 
    the end is requested, the call will fail 
    (:exc:`Bass4Py.exceptions.BassPositionError` error) but the seek table and 
    exact length will have been scanned. When a file has been scanned, all 
    seeking (even without the scan flag) within the scanned part of it will use 
    the scanned infomation. 
    When looping is enabled, the :attr:`Bass4Py.constants.POSITION.LOOP` and 
    :attr:`Bass4Py.constants.POSITION.END` modes can be used to set custom loop 
    start and end points in bytes. Non-byte position (eg. 
    :attr:`Bass4Py.constants.POSITION.MUSIC_ORDER`) custom looping is also 
    possible by setting a "mixtime" sync at the loop end position via 
    :meth:`~Bass4Py.bass.Channel.set_sync` and then seeking to the loop start 
    position in the :attr:`Bass4Py.bass.Sync.callback`. 
    """
    cdef bint res
    cdef DWORD flags = 0
    cdef QWORD c_pos = 0

    if mode == _BASS_POS_MUSIC_ORDER:
      if not isinstance(pos, tuple) or len(pos) != 2:
        raise BassAttributeError("music order must be provided as a tuple with two entries")
      c_pos = MAKELONG(pos[0], pos[1])
    else:
      c_pos = int(pos)

    if decodeto is True:
      flags |= _BASS_POS_DECODETO
    
    if flush is True:
      flags |= _BASS_POS_FLUSH
    
    if inexact is True:
      flags |= _BASS_POS_INEXACT
    
    if relative is True:
      flags |= _BASS_POS_RELATIVE
    
    if scan is True:
      flags |= _BASS_POS_SCAN
    
    if stop_when_seeking is True:
      flags |= _BASS_MUSIC_POSRESET
    
    if reset_when_seeking is True:
      flags |= _BASS_MUSIC_POSRESETEX

    res = BASS_ChannelSetPosition(self._channel, c_pos, mode | flags)
    self._evaluate()
    return res
  
  cpdef get_tags(Channel self, DWORD tag_type):
    cdef DWORD offset = 0
    cdef DWORD length = 0
    cdef char *res = BASS_ChannelGetTags(self._channel, tag_type)
    
    self._evaluate()
    
    if tag_type == _BASS_TAG_ID3V2:
      # first three bytes are ID3
      # two bytes describe the version information of the tag
      # one byte describes the flags
      offset += 6
      # next 4 bytes note the length of the remaining tag
      length |= res[offset] << 21
      length |= res[offset + 1] << 14
      length |= res[offset + 2] << 7
      length |= res[offset + 3]
      offset += 4
      
      return res[:length + 10]

    return res.decode('utf-8')

  property loop:
    """
    :obj:`bool`: Loop the channel?
    """
    def __get__(Channel self):
      return self._get_flags()&_BASS_SAMPLE_LOOP == _BASS_SAMPLE_LOOP

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_SAMPLE_LOOP, switch)

  property device:
    """
    :obj:`Bass4Py.bass.OutputDevice` or :obj:`None`: the output device 
    associated with this channel.

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassDeviceError`
      device is invalid. 
    :exc:`Bass4Py.exceptions.BassInitError`
      The requested device has not been initialized. 
    :exc:`Bass4Py.exceptions.BassAlreadyError`
      The channel is already using the requested device. 
    :exc:`Bass4Py.exceptions.BassNotAvailableError`
      Only decoding channels are allowed to have this property set to 
      :obj:`None`. Final output mix streams (using 
      :meth:`Bass4Py.bass.OutputDevice.create_stream`) cannot be moved to 
      another device. 
    :exc:`Bass4Py.exceptions.BassFormatError`
      The sample format is not supported by the device/drivers. If the channel 
      is more than stereo or the :attr:`Bass4Py.constants.SAMPLE.FLOAT` flag is 
      used, it could be that they are not supported. 
    :exc:`Bass4Py.exceptions.BassMemoryError`
      There is insufficient memory. 
    :exc:`Bass4Py.exceptions.BassUnknownError`
      Some other mystery problem! 


    When changing a :class:`Bass4Py.bass.Sample`'s device, all the sample's 
    existing channels are freed. It is not possible to change the device of an 
    individual sample channel. 
    :obj:`None` can be used to disassociate a decoding channel from a device, 
    so that it does not get freed when :meth:`Bass4Py.bass.OutputDevice.free` 
    is called. 
    """
    def __get__(Channel self):
      return self._device

    def __set__(Channel self, OutputDevice dev):
      if dev is None:
        BASS_ChannelSetDevice(self._channel, _BASS_NODEVICE)
      else:
        BASS_ChannelSetDevice(self._channel, (<OutputDevice?>dev)._device)

      self._evaluate()

      if not dev:
        self._device = None
      else:
        self._device = (<OutputDevice>dev)

  property mode_3d:
    def __get__(Channel self):
      cdef DWORD mode
      BASS_ChannelGet3DAttributes(self._channel, &mode, NULL, NULL, NULL, NULL, NULL)
      self._evaluate()
      return mode

    def __set__(Channel self, int mode):
      BASS_ChannelSet3DAttributes(self._channel, mode, 0.0, 0.0, -1, -1, -1.0)
      self._evaluate()
      BASS_Apply3D()

  property minimum_distance:
    def __get__(Channel self):
      cdef float min
      BASS_ChannelGet3DAttributes(self._channel, NULL, &min, NULL, NULL, NULL, NULL)
      self._evaluate()
      return min

    def __set__(Channel self, float min):
      BASS_ChannelSet3DAttributes(self._channel, -1, min, 0.0, -1, -1, -1.0)
      self._evaluate()
      BASS_Apply3D()

  property maximum_distance:
    def __get__(Channel self):
      cdef float max
      BASS_ChannelGet3DAttributes(self._channel, NULL, NULL, &max, NULL, NULL, NULL)
      self._evaluate()
      return max

    def __set__(Channel self, float max):
      BASS_ChannelSet3DAttributes(self._channel, -1, 0.0, max, -1, -1, -1.0)
      self._evaluate()
      BASS_Apply3D()

  property angle:
    def __get__(Channel self):
      cdef DWORD iangle,oangle
      BASS_ChannelGet3DAttributes(self._channel, NULL, NULL, NULL, &iangle, &oangle, NULL)
      self._evaluate()
      return (iangle, oangle, )

    def __set__(Channel self, list angle):
      if len(angle) != 2: raise BassAPIError()
      BASS_ChannelSet3DAttributes(self._channel, -1, 0.0, 0.0, angle[0], angle[1], -1.0)
      self._evaluate()
      BASS_Apply3D()

  property outer_volume:
    def __get__(Channel self):
      cdef float outvol
      BASS_ChannelGet3DAttributes(self._channel, NULL, NULL, NULL, NULL, NULL, &outvol)
      self._evaluate()
      return outvol

    def __set__(Channel self, float outvol):
      BASS_ChannelSet3DAttributes(self._channel, -1, 0.0, 0.0, -1, -1, outvol)
      self._evaluate()
      BASS_Apply3D()

  property position_3d:
    def __get__(Channel self):
      cdef BASS_3DVECTOR pos
      BASS_ChannelGet3DPosition(self._channel, &pos, NULL, NULL)
      self._evaluate()
      return CreateVector(&pos)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR pos
      value.Resolve(&pos)
      BASS_ChannelSet3DPosition(self._channel, &pos, NULL, NULL)
      self._evaluate()
      BASS_Apply3D()

  property orientation_3d:
    def __get__(Channel self):
      cdef BASS_3DVECTOR orient
      BASS_ChannelGet3DPosition(self._channel, NULL, &orient, NULL)
      self._evaluate()
      return CreateVector(&orient)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR orient
      value.Resolve(&orient)
      BASS_ChannelSet3DPosition(self._channel, NULL, &orient, NULL)
      self._evaluate()
      BASS_Apply3D()

  property velocity_3d:
    def __get__(Channel self):
      cdef BASS_3DVECTOR vel
      BASS_ChannelGet3DPosition(self._channel, NULL, NULL, &vel)
      self._evaluate()
      return CreateVector(&vel)

    def __set__(Channel self, Vector value):
      cdef BASS_3DVECTOR vel
      value.Resolve(&vel)
      BASS_ChannelSet3DPosition(self._channel, NULL, NULL, &vel)
      self._evaluate()
      BASS_Apply3D()
