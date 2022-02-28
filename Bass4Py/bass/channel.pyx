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
    with nogil:
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
    cdef bint res
    with nogil:
      res = BASS_FXReset(self._channel)
    self._evaluate()
    return res

  cpdef set_dsp(Channel self, DSP dsp):
    dsp.set(self)

  cpdef link(Channel self, Channel obj):
    cdef bint res
    res = BASS_ChannelSetLink(self._channel, obj._channel)
    self._evaluate()
    return res

  cpdef unlink(Channel self, Channel obj):
    cdef bint res
    res = BASS_ChannelRemoveLink(self._channel, obj._channel)
    self._evaluate()
    return res

  cpdef set_position(Channel self, object pos, DWORD mode=_BASS_POS_BYTE, bint decodeto=False, bint flush=False, bint inexact=False, bint relative=False, bint reset=False, bint scan=False, bint posreset=False, bint posresetex=False):
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
    
    if reset is True:
      flags |= _BASS_POS_RESET
    
    if scan is True:
      flags |= _BASS_POS_SCAN
    
    if posreset is True:
      flags |= _BASS_MUSIC_POSRESET
    
    if posresetex is True:
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
    def __get__(Channel self):
      return self._get_flags()&_BASS_SAMPLE_LOOP == _BASS_SAMPLE_LOOP

    def __set__(Channel self, bint switch):
      self._set_flags(_BASS_SAMPLE_LOOP, switch)

  property device:
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
