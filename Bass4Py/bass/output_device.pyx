from ..evaluable cimport Evaluable
from ..bindings.bass cimport (
  _BASS_DEVICE_DEFAULT,
  _BASS_DEVICE_ENABLED,
  _BASS_DEVICE_INIT,
  _BASS_DEVICE_TYPE_MASK,
  _STREAMFILE_BUFFER,
  BASS_Apply3D,
  BASS_Free,
  BASS_Get3DFactors,
  BASS_Get3DPosition,
  BASS_GetDeviceInfo,
  BASS_GetInfo,
  BASS_GetVolume,
  BASS_Init,
  BASS_IsStarted,
  BASS_Pause,
  BASS_Set3DFactors,
  BASS_Set3DPosition,
  BASS_SetDevice,
  BASS_SetVolume,
  BASS_Start,
  BASS_Stop)

from .music cimport Music
from .sample cimport Sample
from .stream cimport Stream
from .vector cimport Vector, CreateVector
from ..exceptions import BassAPIError, BassPlatformError

from ..constants import DEVICE, DEVICE_TYPE, STARTED

cdef class OutputDevice(Evaluable):
  """
  Control several settings related to your specific output device and create 
  new audio streams.

  An output device allows to configure several device-related settings, read 
  device-related information like :attr:`~Bass4Py.bass.OutputDevice.name` and 
  create streams or sample, e.g. with the 
  :meth:`~Bass4Py.bass.OutputDevice.create_stream_from_file` method.

  Before a device can actively be used, it must be initialized via the 
  :meth:`~Bass4Py.bass.OutputDevice.init` method. A few things can be done 
  without doing so though, mostly accessing some attributes like the 
  :attr:`~Bass4Py.bass.OutputDevice.name` attribute.
  """

  def __cinit__(OutputDevice self, int device):
    self._device=device

  def __richcmp__(OutputDevice self, other, int op):
    if op == 2:
      return (type(self) == type(other)) and (self._device == (<OutputDevice>other)._device)

  cdef BASS_DEVICEINFO _get_device_info(OutputDevice self):
    cdef BASS_DEVICEINFO info
    BASS_GetDeviceInfo(self._device, &info)
    return info

  cdef BASS_INFO _get_info(OutputDevice self):
    cdef BASS_INFO info
    cdef bint res = BASS_GetInfo(&info)
    return info

  cpdef free(OutputDevice self):
    """
    Frees all resources used by the output device, including all its 
    :class:`samples <Bass4Py.bass.Sample>`, 
    :class:`streams <Bass4Py.bass.Stream>` and 
    :class:`MOD musics <Bass4Py.bass.Music>`.

    Returns
    -------
    success: :obj:`bool`

    Raises
    ------
    
    :exc:`Bass4Py.exceptions.BassInitError`
      :meth:`~Bass4Py.bass.OutputDevice.init` has not been successfully called. 


    This function should be called for all initialized devices before the 
    program closes. It is not necessary to individually free the 
    :class:`samples <Bass4Py.bass.Sample>`/
    :class:`streams <Bass4Py.bass.Stream>`/
    :class:`musics <Bass4Py.bass.Music>` as these are all automatically freed 
    by this method.
    """
    cdef bint res
    self.set()
    with nogil:
      res = BASS_Free()
    self._evaluate()
    return res

  cpdef init(OutputDevice self, DWORD freq = 44100, DWORD flags = 0):
    """
    Initializes an output device. 

    Parameters
    ----------
    
    freq: :obj:`int`
    
      Output sample rate. 

    flags: :class:`Bass4Py.constants.DEVICE`
    
      a combination of the :class:`Bass4Py.constants.DEVICE` flags

    Returns
    -------
    
      success: :obj:`bool`

    Raises
    ------
    
      :exc:`Bass4Py.exceptions.BassDxError`
      
        DirectX (or ALSA on Linux) is not installed. 

      :exc:`Bass4Py.exceptions.BassDeviceError`
      
        device is invalid. 

      :exc:`Bass4Py.exceptions.BassAlreadyError`
      
        The device has already been initialized. 
        :meth:`~Bass4Py.bass.OutputDevice.free` must be called before it can be 
        initialized again. 

      :exc:`Bass4Py.exceptions.BassDriverError`
      
        There is no available device driver. 

      :exc:`Bass4Py.exceptions.BassBusyError`
      
        Something else has exclusive use of the device. 

      :exc:`Bass4Py.exceptions.BassFormatError`
      
        The specified format is not supported by the device. Try changing the freq and flags parameters. 

      :exc:`Bass4Py.exceptions.BassMemoryError`
      
        There is insufficient memory. 

      :exc:`Bass4Py.exceptions.BassNo3DError`
      
        Could not initialize 3D support. 

      :exc:`Bass4Py.exceptions.BassUnknownError`
      
        Some other mystery problem! 


    This function must be successfully called before using any 
    :class:`sample <Bass4Py.bass.Sample>`, 
    :class:`stream <Bass4Py.bass.Stream>` or 
    :class:`MOD music <Bass4Py.bass.Music>` functions. The recording functions 
    may be used without having called this function. The 
    :attr:`Bass4Py.bass.BASS.device_buffer` and 
    :attr:`Bass4Py.bass.BASS.device_update_period` config options determine how much 
    data is buffered for the device and how often it is updated. 

    Platform-specific

    The sample format specified in the freq and flags parameters has no effect 
    on the device output on iOS or OSX, and not on Windows unless VxD drivers 
    are used (on Windows 98/95); with WDM drivers (on Windows XP/2000/Me/98SE), 
    the output format is automatically set depending on the format of what is 
    played and what the device supports, while on Vista and newer, the output 
    format is determined by the user's choice in the Sound control panel. On 
    Linux, the output device will use the specified format if possible, but 
    will otherwise use a format as close to it as possible. If the 
    :attr:`Bass4Py.constants.DEVICE.FREQ` flag is specified on iOS or OSX, then 
    the device's output rate will be set to the freq parameter if possible. 
    The :attr:`Bass4Py.constants.DEVICE.FREQ` flag has no effect on other 
    platforms. :attr:`~Bass4Py.bass.OutputDevice.flags` attribute can be used 
    to check what the output format actually is. When DirectSound output is 
    used on Windows, BASS will not be generating the final output mix and so 
    some BASS features will be unavailable, including sample rate conversion 
    quality configuration, playback buffer bypassing, and access to the final 
    mix. The :attr:`Bass4Py.constants.DEVICE.CPSPEAKERS` and 
    :attr:`Bass4Py.constants.DEVICE.SPEAKERS` flags only have effect on 
    pre-Vista Windows; the number of available speakers is always accurately 
    detected otherwise. The :attr:`Bass4Py.constants.DEVICE.STEREO` flag is 
    ignored on Windows and OSX. The :attr:`Bass4Py.constants.DEVICE.DMIX` flag 
    is only available on Linux, and allows multiple applications to share the 
    device (if they all use "dmix"). It may also be possible for multiple 
    applications to use exclusive access if the device is capable of hardware 
    mixing. If exclusive access initialization fails, the 
    :attr:`Bass4Py.constants.DEVICE.DMIX` flag will automatically be tried; if 
    that happens, it can be detected via 
    :attr:`Bass4Py.bass.OutputDevice.init_flags`. 
    """
    cdef bint res = BASS_Init(self._device, freq, flags, NULL, NULL)
    self._evaluate()
    return res

  cpdef pause(OutputDevice self):
    """
    Stops the output, pausing all 
    :class:`musics <Bass4Py.bass.Music>`/
    :class:`samples <Bass4Py.bass.Sample>`/
    :class:`streams <Bass4Py.bass.Stream>` on it.

    Returns
    -------
    success: :obj:`bool`

    Raises
    ------
    
    :exc:`Bass4Py.exceptions.BassInitError`
    
      :meth:`~Bass4Py.bass.OutputDevice.init` has not been successfully called. 

    
    Use :meth:`~Bass4Py.bass.OutputDevice.start` to resume the output and 
    paused channels. 
    """
    cdef bint res
    self.set()
    with nogil:
      res = BASS_Pause()
    self._evaluate()
    return res

  cdef void set(self):
    with nogil:
      BASS_SetDevice(self._device)
    self._evaluate()

  cpdef start(OutputDevice self):
    """
    Starts (or resumes) the output. 

    Returns
    -------
    
      success: :obj:`bool`
      
    Raises
    ------
    
      :exc:`Bass4Py.exceptions.BassInitError`
      
        :meth:`~Bass4Py.bass.OutputDevice.init` has not been successfully called. 

      :exc:`Bass4Py.exceptions.BassUnknownError`
      
        Some other mystery problem! 


    The output is automatically started by 
    :meth:`~Bass4Py.bass.OutputDevice.init`, so there is usually no need to use 
    this function unless :meth:`~Bass4Py.bass.OutputDevice.stop` or 
    :meth:`~Bass4Py.bass.OutputDevice.pause` has been used. But the output may 
    also be paused automatically if the output device becomes unavailable (eg. 
    disconnected). A :class:`Bass4Py.bass.syncs.DeviceFail` sync can be used 
    to be notified when that happens. 
    :attr:`~Bass4Py.bass.OutputDevice.started` can be used to check if the 
    output is currently running. 

    Platform-specific

    When using DirectSound output on Windows, and the device becomes 
    unavailable (eg. disconnected), this function will not be able to resume 
    output once the device becomes available again; the device will need to be 
    reinitialized via :meth:`~Bass4Py.bass.OutputDevice.init`. 
    """
    cdef bint res
    self.set()
    with nogil:
      res = BASS_Start()
    self._evaluate()
    return res

  cpdef stop(OutputDevice self):
    """
    Stops the output, stopping all :class:`musics <Bass4Py.bass.Music>`/
    :class:`samples <Bass4Py.bass.Sample>`/
    :class:`streams <Bass4Py.bass.Stream>` on it. 

    Returns
    -------
    
      success: :obj:`bool`
      
    Raises
    ------
    
      :exc:`Bass4Py.exceptions.BassInitError`
      
        :meth:`~Bass4Py.bass.OutputDevice.init` has not been successfully called. 


    This function can be used after :meth:`~Bass4Py.bass.OutputDevice.pause` to 
    stop the paused channels, so that they will not be resumed the next time 
    :meth:`~Bass4Py.bass.OutputDevice.start` is called. 
    """
    cdef bint res
    self.set()
    with nogil:
      res = BASS_Stop()
    self._evaluate()
    return res

  cpdef create_stream_from_parameters(OutputDevice self, DWORD freq, DWORD chans, DWORD flags = 0, object callback = None):
    """
    Creates a :class:`user sample stream <Bass4Py.bass.Stream>`. 

    Parameters
    ----------
    
    freq: :obj:`int`

      The default sample rate. The sample rate can be changed using 
      :attr:`Bass4Py.bass.Stream.frequency`. 

    chans: :obj:`int`
    
      The number of channels... 1 = mono, 2 = stereo, 4 = quadraphonic, 
      6 = 5.1, 8 = 7.1. 

    flags: :class:`Bass4Py.constants.STREAM`
    
      a combination of the :class:`Bass4Py.constants.STREAM` flags

    callback: callable

      the callback parameter can be either :obj:`None`, in which case the data 
      for the stream needs to be pushed manually via 
      :meth:`Bass4Py.bass.Stream.put_data`, or it can be a callable that 
      accepts two parameters, the corresponding :class:`Bass4Py.bass.Stream` 
      object and an integer length of data expected, and needs to return a 
      :obj:`bytes` object that should contain as much data as the length 
      parameter indicates to prevent buffer underflows.

    Returns
    -------
    
      stream: :class:`Bass4Py.bass.Stream`
    
    Raises
    ------
    
      :exc:`Bass4Py.exceptions.BassInitError`
      
        :meth:`~Bass4Py.bass.OutputDevice.init` has not been successfully called. 

      :exc:`Bass4Py.exceptions.BassNotAvailableError`
      
        The :attr:`Bass4Py.constants.STREAM.AUTOFREE` flag cannot be combined 
        with the :attr:`Bass4Py.constants.STREAM.DECODE` flag. 

      :exc:`Bass4Py.exceptions.BassFormatError`

        The sample format is not supported by the device/drivers. If the stream 
        is more than stereo or the :attr:`Bass4Py.constants.STREAM.FLOAT` flag 
        is used, it could be that they are not supported. 

      :exc:`Bass4Py.exceptions.BassSpeakerError`
      
        The specified speaker flags are invalid. The device/drivers do not 
        support them, they are attempting to assign a stereo stream to a mono 
        speaker or 3D functionality is enabled. 

      :exc:`Bass4Py.exceptions.BassMemoryError`
      
        There is insufficient memory. 

      :exc:`Bass4Py.exceptions.BassNo3DError`
      
        Could not initialize 3D support. 

      :exc:`Bass4Py.exceptions.BassUnknownError`

        Some other mystery problem! 


    Sample streams allow any sample data to be played through BASS, and are 
    particularly useful for playing a large amount of sample data without 
    requiring a large amount of memory. If you wish to play a sample format 
    that BASS does not support, then you can create a stream and decode the 
    sample data into it. 
    """
    return Stream.from_parameters(freq, chans, flags, callback, self)

  cpdef create_stream_from_bytes(OutputDevice self, const unsigned char[:] data, DWORD flags = 0, QWORD length = 0):
    return Stream.from_bytes(data, flags, length, self)

  cpdef create_stream_from_file(OutputDevice self, object filename, DWORD flags = 0, QWORD offset = 0):
    return Stream.from_file(filename, flags, offset, self)

  cpdef create_stream_from_url(OutputDevice self, object url, DWORD flags = 0, QWORD offset = 0, object callback = None):
    return Stream.from_url(url, flags, offset, callback, self)

  cpdef create_stream(OutputDevice self):
    return Stream.from_device(self)

  cpdef create_stream_from_file_obj(OutputDevice self, object obj, DWORD system = _STREAMFILE_BUFFER, DWORD flags = 0):
    return Stream.from_file_obj(obj, system, flags, self)

  cpdef create_sample_from_bytes(OutputDevice self, const unsigned char[:] data, DWORD max = 65535, DWORD flags = 0, DWORD length = 0):
    return Sample.from_bytes(data, max, flags, length, self)

  cpdef create_sample_from_file(OutputDevice self, object filename, DWORD max = 65535, DWORD flags = 0, QWORD offset = 0):
    return Sample.from_file(filename, max, flags, offset, self)

  cpdef create_sample_from_parameters(OutputDevice self, DWORD length, DWORD freq, DWORD chans, DWORD max = 65535, DWORD flags = 0):
    return Sample.from_parameters(length, freq, chans, max, flags, self)

  cpdef create_music_from_bytes(OutputDevice self, const unsigned char[:] data, DWORD flags = 0, QWORD length = 0, bint device_frequency = True):
    return Music.from_bytes(data, flags, length, device_frequency, self)

  cpdef create_music_from_file(OutputDevice self, object filename, DWORD flags = 0, QWORD offset = 0, bint device_frequency = True):
    return Music.from_file(filename, flags, offset, device_frequency, self)

  property name:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return info.name.decode('utf-8')

  property driver:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      if info.driver == NULL:
        return u''
      return info.driver.decode('utf-8')

  property enabled:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return <bint>(info.flags&_BASS_DEVICE_ENABLED)

  property default:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return <bint>(info.flags&_BASS_DEVICE_DEFAULT)

  property initialized:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()
      return <bint>(info.flags&_BASS_DEVICE_INIT)

  property type:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._get_device_info()
      self._evaluate()

      if info.flags&_BASS_DEVICE_TYPE_MASK:

        return DEVICE_TYPE(info.flags&_BASS_DEVICE_TYPE_MASK)
      return None

  property flags:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.flags

  property direct_x:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.dsver

  property buffer:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.minbuf

  property latency:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.latency

  property init_flags:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()

      return DEVICE(info.initflags)

  property speakers:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.speakers

  property frequency:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.freq

  property volume:
    def __get__(OutputDevice self):
      cdef float volume
      self.set()
      volume = BASS_GetVolume()
      self._evaluate()
      return volume

    def __set__(OutputDevice self, float value):
      cdef bint res
      self.set()
      with nogil:
        res = BASS_SetVolume(value)
      self._evaluate()

  property position_3d:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR pos
      self.set()
      BASS_Get3DPosition(&pos, NULL, NULL, NULL)
      self._evaluate()
      return CreateVector(&pos)

    def __set__(OutputDevice self, Vector value):
      cdef BASS_3DVECTOR pos
      cdef bint res
      self.set()
      value.Resolve(&pos)
      res = BASS_Set3DPosition(&pos, NULL, NULL, NULL)
      self._evaluate()
      BASS_Apply3D()

  property velocity_3d:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR vel
      self.set()
      BASS_Get3DPosition(NULL, &vel, NULL, NULL)
      self._evaluate()
      return CreateVector(&vel)

    def __set__(OutputDevice self,Vector value):
      cdef BASS_3DVECTOR vel
      cdef bint res
      self.set()
      value.Resolve(&vel)
      res = BASS_Set3DPosition(NULL, &vel, NULL, NULL)
      self._evaluate()
      BASS_Apply3D()

  property front_3d:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR front, top
      self.set()
      BASS_Get3DPosition(NULL, NULL, &front, &top)
      self._evaluate()
      return CreateVector(&front)

    def __set__(OutputDevice self, Vector value):
      cdef BASS_3DVECTOR front, top
      cdef bint res
      self.set()
      BASS_Get3DPosition(NULL, NULL, &front, &top)
      value.Resolve(&front)
      res = BASS_Set3DPosition(NULL, NULL, &front, &top)
      self._evaluate()
      BASS_Apply3D()

  property top_3d:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR front, top
      self.set()
      BASS_Get3DPosition(NULL, NULL, &front, &top)
      self._evaluate()
      return CreateVector(&top)

    def __set__(OutputDevice self,Vector value):
      cdef BASS_3DVECTOR front, top
      cdef bint res
      self.set()
      BASS_Get3DPosition(NULL, NULL, &front, &top)
      value.Resolve(&top)
      res = BASS_Set3DPosition(NULL, NULL, &front, &top)
      self._evaluate()
      BASS_Apply3D()

  property distance:
    def __get__(OutputDevice self):
      cdef float distf
      self.set()
      BASS_Get3DFactors(&distf, NULL, NULL)
      self._evaluate()
      return distf

    def __set__(OutputDevice self, float value):
      self.set()
      BASS_Set3DFactors(value,-1.0,-1.0)
      self._evaluate()
      BASS_Apply3D()

  property rolloff:
    def __get__(OutputDevice self):
      cdef float rollf
      self.set()
      BASS_Get3DFactors(NULL, &rollf, NULL)
      self._evaluate()
      return rollf

    def __set__(OutputDevice self,float value):
      self.set()
      BASS_Set3DFactors(-1.0, value, -1.0)
      self._evaluate()
      BASS_Apply3D()

  property doppler:
    def __get__(OutputDevice self):
      cdef float doppf
      self.set()
      BASS_Get3DFactors(NULL, NULL, &doppf)
      self._evaluate()
      return doppf

    def __set__(OutputDevice self,float value):
      self.set()
      BASS_Set3DFactors(-1.0, -1.0, value)
      self._evaluate()
      BASS_Apply3D()

  property started:
    def __get__(OutputDevice self):
      cdef DWORD res
      self.set()
      res = BASS_IsStarted()
      self._evaluate()
      return STARTED(res)
