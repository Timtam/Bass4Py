from cpython.mem cimport PyMem_Free, PyMem_Malloc

from ..bindings.bass cimport (
  _BASS_ATTRIB_FREQ,
  _BASS_ATTRIB_GRANULE,
  _BASS_ATTRIB_MUSIC_PSCALER,
  _BASS_ATTRIB_PAN,
  _BASS_ATTRIB_SRC,
  _BASS_ATTRIB_VOL,
  _BASS_DATA_AVAILABLE,
  _BASS_DATA_FIXED,
  _BASS_DATA_FLOAT,
  _BASS_POS_BYTE,
  _BASS_POS_DECODE,
  _BASS_POS_MUSIC_ORDER,
  _BASS_UNICODE,
  BASS_ChannelBytes2Seconds,
  BASS_ChannelGetAttribute,
  BASS_ChannelGetData,
  BASS_ChannelGetInfo,
  BASS_ChannelGetLength,
  BASS_ChannelGetLevel,
  BASS_ChannelGetLevelEx,
  BASS_ChannelGetPosition,
  BASS_ChannelIsActive,
  BASS_ChannelLock,
  BASS_ChannelPause,
  BASS_ChannelSeconds2Bytes,
  BASS_ChannelStop,
  HIWORD,
  LOWORD,
  WORD,
  )

from ..constants import ACTIVE, CHANNEL_TYPE, SAMPLE
from .plugin cimport Plugin
from .sample cimport Sample

cdef class ChannelBase(Evaluable):
  """
  .. todo::
  
     :meth:`~Bass4Py.bass.ChannelBase.get_levels` has a flags parameter; rewrite 
     to have pythonic boolean parameter flags instead.

  .. todo::
  
     Add support for all the fft flags to 
     :meth:`~Bass4Py.bass.ChannelBase.get_data` or add a separate method for 
     that purpose.
  """

  _map = {}

  def __cinit__(ChannelBase self):

    self._flags_enum = SAMPLE

  def __init__(self, HCHANNEL channel):
    if channel != 0:
      self._set_handle(channel)

  cdef void _set_handle(ChannelBase self, HCHANNEL handle):
    self._channel = handle
    self._map[handle] = self
    self._init_attributes()

  cdef void _init_attributes(ChannelBase self):
    self.frequency = FloatAttribute(self._channel, _BASS_ATTRIB_FREQ)
    self.pan = FloatAttribute(self._channel, _BASS_ATTRIB_PAN)
    self.src = FloatAttribute(self._channel, _BASS_ATTRIB_SRC)
    self.volume = FloatAttribute(self._channel, _BASS_ATTRIB_VOL)
    self.granularity = FloatAttribute(self._channel, _BASS_ATTRIB_GRANULE)

  cdef BASS_CHANNELINFO _get_info(ChannelBase self):
    cdef BASS_CHANNELINFO info
    cdef bint res
    res=BASS_ChannelGetInfo(self._channel, &info)
    return info

  cpdef pause(ChannelBase self):
    """
    Pauses this channel. 

    Returns
    -------
    :obj:`bool`
      success
    
    Raises
    ------
    :exc:`Bass4Py.exceptions.BassNoPlayError`
      The channel is not playing. 
    :exc:`Bass4Py.exceptions.BassDecodeError`
      The channel is not playable; it is a "decoding channel". 
    :exc:`Bass4Py.exceptions.BassAlreadyError`
      The channel is already paused. 


    Use :meth:`Bass4Py.bass.Channel.play` to resume a paused channel. 
    :meth:`~Bass4Py.bass.ChannelBase.stop` can be used to stop a paused channel. 
    """
    cdef bint res 
    res = BASS_ChannelPause(self._channel)
    self._evaluate()
    return res

  cpdef stop(ChannelBase self):
    """
    Stops this channel. 

    Returns
    -------
    :obj:`bool`
      success
    

    Stopping a user stream (created with 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_parameters`) will clear 
    its buffer contents, and stopping a :class:`Bass4Py.bass.Sample` channel or 
    :class:`Bass4Py.bass.Record` will result in it being freed. Use 
    :meth:`~Bass4Py.bass.ChannelBase.pause` instead if you wish to be able to 
    resume them (with :meth:`Bass4Py.bass.Channel.play`). 
    When used with a decoding channel, this function will end the channel at 
    its current position, so that it is not possible to decode any more data 
    from it. Any :class:`Bass4Py.bass.syncs.End` syncs that have been set on 
    the channel will not be triggered by this; they are only triggered when 
    reaching the natural end. :meth:`Bass4Py.bass.Channel.set_position` can be 
    used to reset the channel and start decoding again. 
    """
    cdef bint res 
    res = BASS_ChannelStop(self._channel)
    self._evaluate()
    return res

  cpdef get_levels(ChannelBase self, float length, DWORD flags):
    cdef int chans = self.channels
    cdef int i=0
    cdef float *levels
    cdef list plevels=[]
    levels = <float*>PyMem_Malloc(chans * sizeof(float))
    if levels == NULL: return plevels
    BASS_ChannelGetLevelEx(self._channel, levels, length, flags)
    self._evaluate()
    for i in range(chans):
      plevels.append(levels[i])
    PyMem_Free(<void*>levels)
    return tuple(plevels)

  cpdef lock(ChannelBase self):
    """
    Locks a channel to the current thread. 

    Returns
    -------
    :obj:`bool`
      success
    
    
    Locking a channel prevents other threads from performing most functions on 
    it, including buffer updates. Other threads wanting to access a locked 
    channel will block until it is unlocked, so a channel should only be locked 
    very briefly. A channel must be unlocked in the same thread that it was 
    locked. 
    """
    cdef bint res

    res = BASS_ChannelLock(self._channel, True)

    self._evaluate()
    
    return res

  cpdef unlock(ChannelBase self):
    """
    Removes the lock from this channel. 

    Returns
    -------
    :obj:`bool`
      success
    
    
    Locking a channel prevents other threads from performing most functions on 
    it, including buffer updates. Other threads wanting to access a locked 
    channel will block until it is unlocked, so a channel should only be locked 
    very briefly. A channel must be unlocked in the same thread that it was 
    locked. 
    """
    cdef bint res
    
    res = BASS_ChannelLock(self._channel, False)

    self._evaluate()
    
    return res

  cpdef get_position(ChannelBase self, DWORD mode = _BASS_POS_BYTE, bint decode = False):
    """
    Retrieves the playback position of this channel. 

    Returns
    -------
    :obj:`int` or :obj:`tuple`
      the position as a :obj:`tuple` when mode is set to 
      :attr:`Bass4Py.constants.POSITION.MUSIC_ORDER`, otherwise :obj:`int`

    Parameters
    ----------
    mode : :class:`Bass4Py.constants.POSITION`
      how to retrieve the position. One of the following:
      
      - :attr:`Bass4Py.constants.POSITION.BYTE` (default): Get the position in bytes. 
      - :attr:`Bass4Py.constants.POSITION.MUSIC_ORDER`: get the position as 
        order, row tuple. (available only for :class:`Bass4Py.bass.Music` only)

    decode: :obj:`bool`
      Get the decoding/rendering position, which may be ahead of the playback 
      position due to buffering. This flag is unnecessary with decoding 
      channels because the decoding position will always be given for them 
      anyway, as they do not have playback buffers. 

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassNotAvailableError`
      The requested position is not available. 
    :exc:`Bass4Py.exceptions.BassUnknownError`
      Some other mystery problem! 
    """
    cdef QWORD res
    cdef float attrib
    cdef DWORD flags = 0

    if decode is True:
      flags = flags | _BASS_POS_DECODE

    res = BASS_ChannelGetPosition(self._channel, mode | flags)
    self._evaluate()

    if mode == _BASS_POS_MUSIC_ORDER:
      BASS_ChannelGetAttribute(self._channel, _BASS_ATTRIB_MUSIC_PSCALER, &attrib)
      self._evaluate()
      return (LOWORD(res), int(HIWORD(res) / attrib), )
    return res
  
  cpdef bytes_to_seconds(ChannelBase self, QWORD bytes):
    """
    Translates a byte position into time (seconds), based on a channel's format. 

    Parameters
    ----------
    pos : :obj:`int`
      The position to translate. 

    Returns
    -------
    :obj:`float`
      the translated time
    
    
    The translation is based on the channel's initial sample rate, when it was 
    created. 
    """
    cdef double secs
    secs = BASS_ChannelBytes2Seconds(self._channel, bytes)
    self._evaluate()
    return secs
  
  cpdef seconds_to_bytes(ChannelBase self, double secs):
    """
    Translates a time (seconds) position into bytes, based on a channel's format. 

    Parameters
    ----------
    pos : :obj:`float`
      The position to translate. 
    
    Returns
    -------
    :obj:`int`
      the position in bytes
    
    
    The translation is based on the channel's initial sample rate, when it was created. 
    The return value is rounded down to the position of the nearest sample. 
    """
    cdef QWORD bytes
    bytes = BASS_ChannelSeconds2Bytes(self._channel, secs)
    self._evaluate()
    return bytes

  cpdef get_data(ChannelBase self, DWORD length, DWORD format = 0):
    """
    Retrieves the immediate sample data of this channel. 

    Parameters
    ----------
    length : :obj:`int`
      Number of bytes wanted (up to 268435455 or 0xFFFFFFF).
    format : :class:`Bass4Py.constants.DATA`
      the format to return the data in, one of the following:
      
      - :attr:`Bass4Py.constants.DATA.SRC` (default): the format the stream is 
        in by its own
      - :attr:`Bass4Py.constants.DATA.FIXED`: output as 8.24 fixed-point stream
      - :attr:`Bass4Py.constants.DATA.FLOAT`: output as 32-bit floating-point stream

    Returns
    -------
    :obj:`bytes`
      the data retrieved by this method.

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassEndedError`
      The channel has reached the end.
    :exc:`Bass4Py.exceptions.BassNotAvailableError`
      It is not possible to get data from final output mix streams (using 
      :meth:`Bass4Py.bass.OutputDevice.create_stream`).


    Unless the channel is a decoding channel, this method can only return as 
    much data as has been written to the channel's playback buffer, so it may 
    not always be possible to get the amount of data requested, especially if 
    it is a large amount. If larger amounts are needed, the buffer length 
    (:attr:`Bass4Py.bass.BASS.buffer`) can be increased. The 
    :attr:`~Bass4Py.bass.ChannelBase.data_available` attribute can be used to 
    check how much data a channel's buffer contains at any time, including when 
    stopped or stalled. BASS will retain some extra data beyond the configured 
    buffer length to account for device latency and give the data that is 
    currently being heard, so the amount of available data can actually exceed 
    the configured buffer length. 
    When requesting data from a decoding channel, data is decoded directly from 
    the channel's source (no playback buffer) and as much data as the channel 
    has available can be decoded at a time. 
    When retrieving sample data, 8-bit samples are unsigned (0 to 255), 16-bit 
    samples are signed (-32768 to 32767), 32-bit floating-point samples range 
    from -1 to +1 (not clipped, so can actually be outside this range). That is 
    unless the :attr:`Bass4Py.constants.DATA.FLOAT` flag is used, in which case 
    the sample data will be converted to 32-bit floating-point (if it is not 
    already), or if the :attr:`Bass4Py.constants.DATA.FIXED` flag is used, in 
    which case the data will be coverted to 8.24 fixed-point. 
    """
    cdef DWORD l = length&0xfffffff
    cdef void *buffer = <void*>PyMem_Malloc(l)
    cdef bytes b

    if buffer == NULL:
      raise MemoryError()
    
    if format == _BASS_DATA_FIXED:
      l |= _BASS_DATA_FIXED
    
    if format == _BASS_DATA_FLOAT:
      l |= _BASS_DATA_FLOAT

    l = BASS_ChannelGetData(self._channel, buffer, length)
    try:
      self._evaluate()
      b = (<char*>buffer)[:l]
    finally:
      PyMem_Free(buffer)
    return b

  cpdef get_length(ChannelBase self, DWORD mode = _BASS_POS_BYTE):
    """
    Retrieves the playback length of a channel. 

    Parameters
    ----------
    mode : :class:`Bass4Py.constants.POSITION`
      one of the following:
      
      - :attr:`Bass4Py.constants.POSITION.BYTE` (default): Get the length in 
        bytes. 
      - :attr:`Bass4Py.constants.POSITION.MUSIC_ORDER`: Get the length in 
        orders. (available for :class:`Bass4Py.bass.Music` only)
      - :attr:`Bass4Py.constants.POSITION.OGG`: Get the number of bitstreams in 
        an OGG file. 

    Returns
    -------
    :obj:`int`
      the length in the format determined by the mode parameter
    
    Raises
    ------
    :exc:`Bass4Py.exceptions.BassNotAvailableError`
      The requested length is not available. 


    The exact length of a stream will be returned once the whole file has been 
    streamed, but until then it is not always possible to 100% accurately 
    estimate the length. The length is always exact for MP3/MP2/MP1 files when 
    the :attr:`Bass4Py.constants.STREAM.PRESCAN` flag is used in the 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file` call, otherwise 
    it is an (usually accurate) estimation based on the file size. The length 
    returned for OGG files will usually be exact (assuming the file is not 
    corrupt), but when streaming from the internet (or "buffered" user file), 
    it can be a very rough estimation until the whole file has been downloaded. 
    Retrieving the byte length of a :class:`Bass4Py.bass.Music` requires that 
    the :attr:`Bass4Py.constants.MUSIC.PRESCAN` flag was used in the 
    :meth:`Bass4Py.bass.OutputDevice.create_music_from_file` call. 
    """
    cdef QWORD res = BASS_ChannelGetLength(self._channel, mode)
    self._evaluate()
    return res

  cpdef free(self):
    """
    Frees a channel, including any sync/DSP/FX it has. 

    Returns
    -------
    :obj:`bool`
      success
    """
    try:
      del self._map[self._channel]
    except KeyError:
      pass

  def __eq__(ChannelBase self, object y):
    cdef ChannelBase chan
    if isinstance(y, ChannelBase):
      chan = <ChannelBase>y
      return self._channel == chan._channel
    return NotImplemented

  property default_frequency:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      return info.freq

  property channels:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      return info.chans

  property type:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()

      return CHANNEL_TYPE(info.ctype)

  property resolution:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      return info.origres

  property plugin:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      if info.plugin:
        return Plugin(info.plugin)
      else:
        return None

  property name:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()

      if info.filename == NULL:
        return u''
      return info.filename.decode('utf-8')

  property sample:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      if info.sample:
        return Sample(info.sample)
      else:
        return None

  property level:
    def __get__(ChannelBase self):
      cdef WORD left, right
      cdef DWORD level = BASS_ChannelGetLevel(self._channel)
      self._evaluate()
      left = LOWORD(level)
      right = HIWORD(level)
      return (left, right, )

  property active:
    def __get__(ChannelBase self):
      cdef DWORD act

      act = BASS_ChannelIsActive(self._channel)

      self._evaluate()
      
      return ACTIVE(act)

  @property
  def data_available(ChannelBase self):
    cdef DWORD res
    res = BASS_ChannelGetData(self._channel, NULL, _BASS_DATA_AVAILABLE)
    self._evaluate()
    return res

  property flags:
    def __get__(ChannelBase self):
      cdef BASS_CHANNELINFO info = self._get_info()
      self._evaluate()
      if info.flags&_BASS_UNICODE:
        return self._flags_enum(info.flags^_BASS_UNICODE)
      return self._flags_enum(info.flags)

  def __dealloc__(self):
    FloatAttribute._clean(self._channel)
