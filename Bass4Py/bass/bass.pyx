# api version supported by Bass4Py
cdef DWORD _BASS4PY_API_VERSION = 0x2040f00

from .output_device cimport OutputDevice
from .plugin cimport Plugin
from .version cimport Version
from ..constants import ALGORITHM_3D
from .. import exceptions
from ..bindings.bass cimport (
  _BASS_CONFIG_3DALGORITHM,
  _BASS_CONFIG_ASYNCFILE_BUFFER,
  _BASS_CONFIG_BUFFER,
  _BASS_CONFIG_CURVE_PAN,
  _BASS_CONFIG_CURVE_VOL,
  _BASS_CONFIG_DEV_BUFFER,
  _BASS_CONFIG_DEV_DEFAULT,
  _BASS_CONFIG_DEV_PERIOD,
  _BASS_CONFIG_FLOATDSP,
  _BASS_CONFIG_GVOL_MUSIC,
  _BASS_CONFIG_GVOL_SAMPLE,
  _BASS_CONFIG_GVOL_STREAM,
  _BASS_CONFIG_HANDLES,
  _BASS_CONFIG_LIBSSL,
  _BASS_CONFIG_MF_DISABLE,
  _BASS_CONFIG_MF_VIDEO,
  _BASS_CONFIG_MUSIC_VIRTUAL,
  _BASS_CONFIG_NET_AGENT,
  _BASS_CONFIG_NET_BUFFER,
  _BASS_CONFIG_NET_PASSIVE,
  _BASS_CONFIG_NET_PLAYLIST,
  _BASS_CONFIG_NET_PLAYLIST_DEPTH,
  _BASS_CONFIG_NET_PREBUF,
  _BASS_CONFIG_NET_PREBUF_WAIT,
  _BASS_CONFIG_NET_PROXY,
  _BASS_CONFIG_NET_READTIMEOUT,
  _BASS_CONFIG_NET_TIMEOUT,
  _BASS_CONFIG_OGG_PRESCAN,
  _BASS_CONFIG_PAUSE_NOPLAY,
  _BASS_CONFIG_REC_BUFFER,
  _BASS_CONFIG_SRC,
  _BASS_CONFIG_SRC_SAMPLE,
  _BASS_CONFIG_UNICODE,
  _BASS_CONFIG_UPDATEPERIOD,
  _BASS_CONFIG_UPDATETHREADS,
  _BASS_CONFIG_VERIFY,
  _BASS_CONFIG_VERIFY_NET,
  _BASS_CONFIG_WASAPI_PERSIST,
  BASS_GetConfig,
  BASS_GetConfigPtr,
  BASS_GetCPU,
  BASS_GetDevice,
  BASS_GetVersion,
  BASS_PluginLoad,
  BASS_SetConfig,
  BASS_SetConfigPtr,
  BASS_Update,
  HPLUGIN)
from ..evaluable cimport Evaluable

include "../transform.pxi"

cdef extern from "Python.h":
  void PyEval_InitThreads()

PyEval_InitThreads()

IF UNAME_SYSNAME == "Windows":
  BASS_SetConfig(_BASS_CONFIG_UNICODE, <DWORD>True)

cdef class BASS(Evaluable):
  """
  This class represents the main entrypoint to all Bass4Py related 
  functionalities. It allows to control various global settings and gain access 
  to :class:`output devices <Bass4Py.bass.OutputDevice>` and 
  :class:`input devices <Bass4Py.bass.InputDevice>` to playback audio 
  data or record from various input sources. All global properties are also 
  accessible through this class.
  
  See :attr:`~Bass4Py.bass.BASS.input_devices` or 
  :attr:`~Bass4Py.bass.BASS.output_devices` to get further access to the 
  really important features.
  """

  def __cinit__(BASS self):

    self.api_version = Version(_BASS4PY_API_VERSION)
    self.input_devices = InputDeviceEnumerator()
    self.output_devices = OutputDeviceEnumerator()
    self.version = Version(BASS_GetVersion())

  cpdef load_plugin(BASS self, object filename):
    """
    Plugs an "add-on" into the standard stream and sample creation functions.

    Parameters
    ----------
    filename : :obj:`str`
      path to the plugin file

    Returns
    -------
    :class:`Bass4Py.bass.Plugin`
      the plugin object

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassFileOpenError`
      The file could not be opened. 
    :exc:`Bass4Py.exceptions.BassFileFormatError`
      The file is not a plugin. 
    :exc:`Bass4Py.exceptions.BassVersionError`
      The plugin requires a different BASS version. Due to the use of the 
      "stdcall" calling-convention, and so risk of stack faults from 
      unexpected API differences, an add-on won't load at all on Windows if 
      the BASS version is unsupported, and a 
      :exc:`Bass4Py.exceptions.BassFileFormatError` error will be generated 
      instead of this. 
    :exc:`Bass4Py.exceptions.BassAlreadyError`
      The plugin is already loaded. 


    There are two ways in which add-ons can provide support for additional 
    formats. They can provide dedicated functions to create streams of the 
    specific format(s) they support and/or they can plug into the standard 
    stream creation functions: 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file`, 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_bytes`, 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_url`, and 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file_obj`. This function 
    enables the latter method. Both methods can be used side by side. The 
    obvious advantage of the plugin system is convenience, while the dedicated 
    functions can provide extra options that are not possible via the shared 
    function interfaces. See an add-on's documentation for more specific 
    details on it. 

    As well as the stream creation functions, plugins also add their 
    additional format support to sample creation functions:
    :meth:`Bass4Py.bass.OutputDevice.create_sample_from_bytes` and 
    :meth:`Bass4Py.bass.OutputDevice.create_sample_from_file`.
    
    Information on what file formats a plugin supports is available via the 
    :attr:`Bass4Py.bass.Plugin.formats` property.

    When using multiple plugins, the stream/sample creation functions will 
    try each of them in the order that they were loaded via this function, 
    until one that accepts the file is found. 

    When an add-on is already loaded (eg. if you are using functions from it), 
    the plugin system will use the same instance (the reference count will 
    just be incremented); there will not be 2 copies of the add-on in memory. 
    """
    cdef const unsigned char[:] fn = to_readonly_bytes(filename)
    cdef HPLUGIN plugin = BASS_PluginLoad(<const char *>(&(fn[0])), 0)
    self._evaluate()
    return Plugin(plugin)

  cpdef update(BASS self, DWORD length):
    """
    Updates the :class:`Bass4Py.bass.Stream` and :class:`Bass4Py.bass.Music` 
    channel playback buffers.

    Parameters
    ----------
    length : :obj:`int`
      The amount of data to render, in milliseconds.

    Returns
    -------
    :obj:`bool`
      success

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassNotAvailableError`
      Updating is already in progress. 


    When automatic updating is disabled, this function, 
    :meth:`Bass4Py.bass.Music.update` or :meth:`Bass4Py.bass.Stream.update` 
    needs to be used to keep the playback buffers updated. The length 
    parameter should include some safety margin, in case the next update cycle 
    gets delayed. For example, if calling this function every 100ms, 200 
    would be a reasonable length parameter. 
    """
    cdef bint res
    res = BASS_Update(length)
    self._evaluate()
    return res

  property cpu:
    """
    :obj:`float`: The current CPU usage of BASS. 

    This function includes the time taken to render stream 
    (:class:`Bass4Py.bass.Stream`) and MOD music 
    (:class:`Bass4Py.bass.Music`) channels during playback, and any DSP 
    functions set on those channels. It also includes any FX that are not 
    using the "with FX flag" DX8 effect implementation. The processing of 
    some add-on stream formats may not be entirely included, if they use 
    additional decoding threads; see the add-on documentation for details. 
    This function does not strictly tell the CPU usage, but rather how timely 
    the processing is. For example, if it takes 10ms to generate 100ms of 
    data, that would be 10%. If the reported usage gets to 100%, that means 
    the channel data is being played faster than it can be generated and 
    buffer underruns are likely to occur. If automatic updating is disabled, 
    then the value returned by this function is only updated after each 
    call to :meth:`Bass4Py.bass.BASS.update`. 
    :meth:`Bass4Py.bass.Music.update` or :meth:`Bass4Py.bass.Stream.update` 
    usage is not included. The CPU usage of an individual channel is 
    available via the :attr:`Bass4Py.bass.Channel.cpu` attribute. 

    Platform-specific

    When using DirectSound output on Windows, the CPU usage does not include 
    sample channels (:class:`Bass4Py.bass.Channel`), which are mixed by the 
    output device/drivers (hardware mixing) or Windows (software mixing). On 
    other platforms and when using WASAPI output on Windows, the CPU usage does 
    include sample playback as well as the generation of the final output mix. 
    On Windows, the CPU usage value does not include the decoding of internet 
    (or "buffered" user file) streams that use Media Foundation codecs. 
    """
    def __get__(BASS self):
      return BASS_GetCPU()

  property device:
    """
    :class:`Bass4Py.bass.OutputDevice` or :obj:`None`: the output device setting of the current thread. 
    """
    def __get__(BASS self):
      cdef DWORD device=BASS_GetDevice()
      try:
        self._evaluate()
      except exceptions.BassInitError:
        return None
      return OutputDevice(device)

  property net_agent:
    """
    :obj:`str`: The "User-Agent" request header sent to servers. 

    Changes take effect from the next internet stream creation call. 
    """
    def __get__(BASS self):
      return (<char*>BASS_GetConfigPtr(_BASS_CONFIG_NET_AGENT)).decode('utf-8')

    def __set__(BASS self, object value):

      cdef bytes agent = to_readonly_bytes(value)

      BASS_SetConfigPtr(_BASS_CONFIG_NET_AGENT, <unsigned char*>agent)

  property net_proxy:
    """
    :obj:`str` or :obj:`None`: Proxy server settings. 

    The proxy server settings, in the form of "user:pass@server:port"... 
    :obj:`None` = don't use a proxy. "" (empty string) = use the OS's default 
    proxy settings. If only the "user:pass@" part is specified, then those 
    authorization credentials are used with the default proxy server. If only 
    the "server:port" part is specified, then that proxy server is used 
    without any authorization credentials. 
    """
    def __get__(BASS self):
      cdef void *proxy = BASS_GetConfigPtr(_BASS_CONFIG_NET_PROXY)

      if proxy == NULL:
        return None
      
      return (<char*>proxy).decode('utf-8')

    def __set__(BASS self, object value):
      cdef bytes proxy

      if value is None:
        BASS_SetConfigPtr(_BASS_CONFIG_NET_PROXY, NULL)
      else:
        proxy = to_readonly_bytes(value)

        BASS_SetConfigPtr(_BASS_CONFIG_NET_PROXY, <unsigned char *>proxy)

  property algorithm_3d:
    """
    :class:`Bass4Py.constants.ALGORITHM_3D`: The positioning algorithm for 3D channels.

    One of these algorithms.

    * :attr:`Bass4Py.constants.ALGORITHM_3D.DEFAULT`: 
      The default algorithm. If the user has selected a surround sound 
      speaker configuration (eg. 4 or 5.1) in the control panel, the sound is 
      panned among the available directional speakers. Otherwise it equates to 
      :attr:`Bass4Py.constants.ALGORITHM_3D.OFF`. 
    * :attr:`Bass4Py.constants.ALGORITHM_3D.OFF`:
      Uses normal left and right panning. The vertical axis is ignored 
      except for scaling of volume due to distance. Doppler shift and volume 
      scaling are still applied, but the 3D filtering is not performed. This 
      is the most CPU efficient algorithm, but provides no virtual 3D audio 
      effect. Head Related Transfer Function processing will not be done. 
      Since only normal stereo panning is used, a channel using this algorithm 
      may be accelerated by a 2D hardware voice if no free 3D hardware voices 
      are available. 

    The default setting is :attr:`Bass4Py.constants.ALGORITHM_3D.DEFAULT`. 
    Changes only affect subsequently created 3D channels, not any that already 
    exist.
    """
    def __get__(BASS self):
      return ALGORITHM_3D(BASS_GetConfig(_BASS_CONFIG_3DALGORITHM))

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_3DALGORITHM, value)

  property async_buffer:
    """
    :obj:`int`: The buffer length for asynchronous file reading. 

    The buffer length in bytes. This will be rounded up to the nearest 4096 
    byte (4KB) boundary. 

    This determines the amount of file data that can be read ahead of time 
    with asynchronous file reading. The default setting is 65536 bytes (64KB). 
    Changes only affect streams that are created afterwards, not any that 
    already exist. So it is possible to have streams with differing buffer 
    lengths by using this config option before creating each of them. When 
    asynchronous file reading is enabled, the buffer level is available from 
    :meth:`Bass4Py.bass.Stream.get_file_position`. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_ASYNCFILE_BUFFER)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_ASYNCFILE_BUFFER, value)

  property buffer:
    """
    :obj:`int`: The playback buffer length for :class:`Bass4Py.bass.Stream` and 
    :class:`Bass4Py.bass.Music` channels. 

    The buffer length in milliseconds. The minimum length is 10ms, the maximum 
    is 5000 milliseconds. If the length specified is outside this range, it 
    is automatically capped. 

    The default buffer length is 500 milliseconds. Increasing the length, 
    decreases the chance of the sound possibly breaking-up on slower computers, 
    but also increases the latency for DSP/FX. The buffer length should always 
    be greater than the update period (:attr:`Bass4Py.bass.BASS.update_period`), 
    which determines how often the buffer is refilled. Small buffer lengths 
    are only required if the sound is going to be changing in real-time, for 
    example, in a soft-synth. If you need to use a small buffer, then the 
    :attr:`Bass4Py.bass.OutputDevice.buffer` attribute should be used to get 
    the recommended minimum buffer length supported by the device and its 
    drivers, and add that to the update period plus some margin for the 
    stream's processing. Even then, it is still possible that the sound could 
    break up on some systems, it is also possible that smaller buffers may be 
    fine. So when using small buffers, you should have an option in your 
    software for the user to finetune the length used, for optimal 
    performance. Using this config option only affects the 
    :class:`Bass4Py.bass.Music`/:class:`Bass4Py.bass.Stream` channels that are 
    created afterwards, not any that have already been created. So you can 
    have channels with differing buffer lengths by using this config option 
    each time before creating them. A channel's buffer length can be also 
    reduced (or bypassed entirely) at any time via the 
    :attr:`Bass4Py.bass.Stream.buffer` attribute. If automatic updating is 
    disabled, make sure you call :meth:`Bass4Py.bass.BASS.update` frequently 
    enough to keep the buffers updated. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_BUFFER)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_BUFFER, value)

  property curve_volume:
    """
    :obj:`bool`: The translation curve of volume values. False = linear, True = logarithmic. 

    When using the linear curve, the volume range is from 0% (silent) to 100% 
    (full). When using the logarithmic curve, the volume range is from -100 dB 
    (effectively silent) to 0 dB (full). For example, a volume level of 0.5 is 
    50% linear or -50 dB logarithmic. The linear curve is used by default. 
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_CURVE_VOL)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_CURVE_VOL, <DWORD>value)

  property curve_pan:
    """
    :obj:`bool`: The translation curve of panning values. False = linear, True = logarithmic. 

    The panning curve affects panning in exactly the same way as the volume 
    curve (:attr:`Bass4Py.bass.BASS.curve_volume`) affects the volume. The 
    linear curve is used by default. 
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_CURVE_PAN)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_CURVE_PAN, <DWORD>value)

  property device_buffer:
    """
    :obj:`int`: The output device buffer length in milliseconds. 

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassPlatformError`
      the feature is not supported on this platform


    The device buffer is where the final mix of all playing channels is 
    placed, ready for the device to play. Its length affects the latency of 
    things like starting and stopping playback of a channel, so you will 
    probably want to avoid setting it unnecessarily high, but setting it too 
    short could result in breaks in the sound. When using a large device 
    buffer, the :attr:`Bass4Py.bass.Channel.buffer` attribute could be used to 
    skip the channel buffering step, to avoid further increasing latency for 
    real-time generated sound and/or DSP/FX changes. The buffer length needs 
    to be a multiple of, and at least double, the device's update period, 
    which can be set via the :attr:`Bass4Py.bass.BASS.device_update_period` 
    option. The buffer length will be rounded up automatically if necessary 
    to achieve that. The system may also choose to use a different buffer 
    length if the requested one is too short or long, or needs rounding for 
    granularity. Changes to this config setting only affect subsequently 
    initialized devices, not any that are already initialized. The "No Sound" 
    device does not have a buffer, so is unaffected by this option. 

    Platform-specific

    The default setting is 30ms on Windows, 40ms on Linux and 200ms 
    on Windows CE. This option is not available on OSX; the device 
    buffer length on this platform is twice the device update period, 
    which can be set via the :attr:`Bass4Py.bass.BASS.device_update_period` 
    option. On Windows, this config option only applies when WASAPI output is 
    used. On Linux, BASS will attempt to set the device buffer-feeding thread 
    to real-time priority (as on other platforms) to reduce the chances of it 
    getting starved of CPU, but if that is not possible (eg. the user account 
    lacks permission) then it may be necessary to increase the buffer length 
    to avoid breaks in the output when the CPU is busy.
    """
    def __get__(BASS self):
      IF UNAME_SYSNAME == "Darwin":
        raise exceptions.BassPlatformError()
      ELSE:
        return BASS_GetConfig(_BASS_CONFIG_DEV_BUFFER)

    def __set__(BASS self, DWORD value):
      IF UNAME_SYSNAME == "Darwin":
        raise exceptions.BassPlatformError()
      ELSE:
        BASS_SetConfig(_BASS_CONFIG_DEV_BUFFER, value)

  property default_device:
    """
    :obj:`bool`: Include a "Default" entry in the output device list?

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassPlatformError`
      the feature isn't supported on this platform


    This option adds a "Default" entry to the output device list, which maps 
    to the device that is currently the system's default. Its output will 
    automatically switch over when the system's default device setting 
    changes. When enabled, the "Default" device will also become the default 
    device accessible via :attr:`Bass4Py.bass.BASS.output_devices.default`. 
    Both it and the device that it currently maps to will have the 
    :attr:`Bass4Py.bass.OutputDevice.default` attribute set. This option can 
    only be set before :meth:`Bass4Py.bass.OutputDevice.init` has been called. 

    Platform-specific

    This config option is only available on Windows and OSX. On Windows, the 
    automatic device switching feature requires Windows Vista or above 
    (Windows 7 when DirectSound is used). When the "Default" device is used 
    with DirectSound, the :attr:`Bass4Py.bass.OutputDevice.volume` attribute 
    work a bit differently to usual; it deals with the "session" volume, 
    which only affects the current process's output on the device, rather than 
    the device's volume. 
    """
    def __get__(BASS self):

      IF UNAME_SYSNAME != "Windows" and UNAME_SYSNAME != "Darwin":
        raise exceptions.BassPlatformError()
      ELSE:
        return <bint>BASS_GetConfig(_BASS_CONFIG_DEV_DEFAULT)

    def __set__(BASS self, bint value):

      IF UNAME_SYSNAME != "Windows" and UNAME_SYSNAME != "Darwin":
        raise exceptions.BassPlatformError()
      ELSE:
        BASS_SetConfig(_BASS_CONFIG_DEV_DEFAULT, <DWORD>value)

  property float_dsp:
    """
    :obj:`bool`: Pass 32-bit floating-point sample data to all :attr:`Bass4Py.bass.DSP.callback` functions? 

    Normally DSP functions receive sample data in whatever format the channel 
    is using, ie. it can be 8, 16 or 32-bit. But when this config option is 
    enabled, BASS will convert 8/16-bit sample data to 32-bit floating-point 
    before passing it to DSP functions, and then convert it back after all the 
    DSP functions are done. As well as simplifying the DSP code (no need for 
    8/16-bit processing), this also means that there is no degradation of 
    quality as sample data passes through a chain of DSP. This config option 
    also applies to effects set via :meth:`Bass4Py.bass.Channel.set_fx` or 
    :meth:`Bass4Py.bass.FX.set`, except for DX8 effects when using the "With 
    FX flag" DX8 effect implementation. Changing the setting while there are 
    DSP or FX set could cause problems, so should be avoided. 

    Platform-specific

    Floating-point data is not supported on some platforms/architectures, 
    in which case this config option will enable 8.24 fixed-point data instead 
    of floating-point. The :attr:`Bass4Py.bass.BASS.float` attribute can be 
    used to check that. 
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_FLOATDSP)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_FLOATDSP, <DWORD>value)

  property music_volume:
    """
    :obj:`int`: The global MOD music volume level. 0 (silent) to 10000 (full). 

    This config option allows you to have control over the volume levels of 
    all the MOD musics, which may be useful for setup options, eg. separate 
    music and effect volume controls. 
    :math:`\\text{A channel's final volume} = \\frac{\\text{channel volume} \\cdot \\text{global volume}}{10000}`.
    For example, if a stream's volume is 0.5 
    and the global stream volume is 8000, then effectively the stream's volume 
    level is 0.4 (
    :math:`\\frac{0.5 \\cdot 8000}{10000} = 0.4`). 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_GVOL_MUSIC)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_GVOL_MUSIC, value)

  property sample_volume:
    """
    :obj:`int`: The global sample volume level. 0 (silent) to 10000 (full). 

    This config option allows you to have control over the volume levels of 
    all the samples, which may be useful for setup options, eg. separate music 
    and effect volume controls. 
    :math:`\\text{A channel's final volume} = \\frac{\\text{channel volume} \\cdot \\text{global volume}}{10000}`. 
    For example, if a stream's volume is 0.5 and the global stream volume is 
    8000, then effectively the stream's volume level is 0.4 (
    :math:`\\frac{0.5 \\cdot 8000}{10000} = 0.4`). 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_GVOL_SAMPLE)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_GVOL_SAMPLE, value)

  property stream_volume:
    """
    :obj:`int`: The global stream volume level. 0 (silent) to 10000 (full). 

    This config option allows you to have control over the volume levels of 
    all the streams, which may be useful for setup options, eg. separate music 
    and effect volume controls. 
    :math:`\\text{A channel's final volume} = \\frac{\\text{channel volume} \\cdot \\text{global volume}}{10000}`. 
    For example, if a stream's volume is 0.5 and the global stream volume is 
    8000, then effectively the stream's volume level is 0.4 (
    :math:`\\frac{0.5 \\cdot 8000}{10000} = 0.4`). 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_GVOL_STREAM)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_GVOL_STREAM, value)

  property mf_video:
    """
    :obj:`bool`: Play the audio from video files using Media Foundation? 

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassPlatformError`
      the feature isn't available on this platform


    Platform-specific

    This config option is only available on Windows. 
    """
    def __get__(BASS self):

      IF UNAME_SYSNAME != "Windows":
        raise exceptions.BassPlatformError()
      ELSE:
        return <bint>BASS_GetConfig(_BASS_CONFIG_MF_VIDEO)

    def __set__(BASS self, bint value):

      IF UNAME_SYSNAME != "Windows":
        raise exceptions.BassPlatformError()
      ELSE:
        BASS_SetConfig(_BASS_CONFIG_MF_VIDEO, <DWORD>value)

  property mf_disable:
    """
    :obj:`bool`: Disable Media Foundation?

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassPlatformError`
      the feature isn't available on this platform


    This option determines whether Media Foundation codecs can be used to 
    decode files and streams. It is set to :obj:`False` by default when Media 
    Foundation codecs are available, which is on Windows 7 and above, and 
    updated versions of Vista. It will otherwise be :obj:`True` and read-only. 

    Platform-specific

    This config option is only available on Windows. 
    """
    def __get__(BASS self):

      IF UNAME_SYSNAME != "Windows":
        raise exceptions.BassPlatformError()
      ELSE:
        return <bint>BASS_GetConfig(_BASS_CONFIG_MF_DISABLE)

    def __set__(BASS self, bint value):

      IF UNAME_SYSNAME != "Windows":
        raise exceptions.BassPlatformError()
      ELSE:
        BASS_SetConfig(_BASS_CONFIG_MF_DISABLE, <DWORD>value)

  property virtual_channels:
    """
    :obj:`int`: The maximum number of virtual channels to use in the rendering of IT files. 

    The number of virtual channels... 1 (min) to 512 (max). If the value 
    specified is outside this range, it is automatically capped. 

    This setting only affects IT files, as the other MOD music formats do not 
    have virtual channels. The default setting is 64. Changes only apply to 
    subsequently loaded files, not any that are already loaded. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_MUSIC_VIRTUAL)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_MUSIC_VIRTUAL, value)

  property net_buffer:
    """
    :obj:`int`: The internet download buffer length in milliseconds. 
    
    Increasing the buffer length decreases the chance of the stream stalling, 
    but also increases the time taken to create the stream as more data has to 
    be pre-buffered (adjustable via the :attr:`Bass4Py.bass.BASS.net_prebuf` 
    attribute). Aside from the pre-buffering, this setting has no effect on 
    streams without either the :attr:`Bass4Py.constants.STREAM.BLOCK` or 
    :attr:`Bass4Py.constants.STREAM.RESTRATE` flags. When streaming in blocks, 
    this option determines the download buffer length. The effective buffer 
    length can actually be a bit more than that specified, including data that 
    has been read from the buffer by the decoder but not yet decoded. This 
    config option also determines the buffering used by "buffered" user file 
    streams created with 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file_obj`. The default 
    buffer length is 5 seconds (5000 milliseconds). The net buffer length 
    should be larger than the length of the playback buffer (
    :attr:`Bass4Py.bass.BASS.buffer`), otherwise the stream is likely to stall 
    soon after starting playback. Using this config option only affects 
    streams created afterwards, not any that have already been created. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_BUFFER)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_BUFFER, value)

  property net_passive:
    """
    :obj:`bool`: Use passive mode in FTP connections? 

    Changes take effect from the next internet stream creation call. By 
    default, passive mode is enabled. 
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_NET_PASSIVE)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_NET_PASSIVE, <DWORD>value)

  property net_playlist:
    """
    :obj:`int`: Process URLs in PLS and M3U playlists? 
    
    When to process URLs in PLS and M3U playlists... 0 = never, 1 = in 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_url` only, 2 = in 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file` and 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file_obj` too. 

    When enabled, BASS will process PLS and M3U playlists, trying each URL 
    until it finds one that it can play. :attr:`Bass4Py.bass.ChannelBase.name` 
    can be used to find out the URL that was successfully opened. Nested 
    playlists are suported, that is a playlist can contain the URL of another 
    playlist. The :attr:`Bass4Py.bass.BASS.net_playlist_depth` option limits 
    the nested playlist depth. By default, playlist processing is disabled. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_PLAYLIST)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_PLAYLIST, value)

  property net_playlist_depth:
    """
    :obj:`int`: Maximum nested playlist processing depth. 0 = do not process nested playlists. 

    When playlist processing is enabled via the 
    :attr:`Bass4Py.bass.BASS.net_playlist` option, this option limits how deep 
    into nested playlists 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_url` will go. The default 
    depth is 1, which means playlists within the root playlist will be 
    processed, but not playlists within those playlists. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_PLAYLIST_DEPTH)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_PLAYLIST_DEPTH, value)

  property net_prebuf:
    """
    :obj:`int`: Amount (percentage) to pre-buffer before playing internet streams. 

    This setting determines what percentage of the buffer length (
    :attr:`Bass4Py.bass.BASS.net_buffer`) should be filled before starting 
    playback. The default is 75%. This setting is just a minimum; BASS will 
    always pre-download a certain amount to detect the stream's format and 
    initialize the decoder. The pre-buffering can be done by 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_url` or asynchronously, 
    depending on the :attr:`Bass4Py.bass.BASS.net_prebuf_wait`  setting. As well 
    as internet streams, this config setting also applies to "buffered" user 
    file streams created with 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file_obj`. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_PREBUF)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_PREBUF, value)

  property net_prebuf_wait:
    """
    :obj:`bool`: Wait for pre-buffering when opening internet streams? 

    This setting determines whether 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_url` will wait for an 
    amount of data to be downloaded before returning the new stream. The 
    amount is determined by the :attr:`Bass4Py.bass.BASS.net_buffer` and :attr:`Bass4Py.bass.BASS.net_prebuf` settings. 
    The default setting is disabled, which means pre-buffering will happen 
    asynchronously and playback will begin in a stalled state while 
    pre-buffering is in progress. The progress can be monitored with 
    :meth:`Bass4Py.bass.Stream.get_file_position` (
    :attr:`Bass4Py.constants.FILE_POSITION.BUFFERING`). As well as internet 
    streams, this config setting also applies to streams created with 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file_obj` and the 
    :attr:`Bass4Py.constants.STREAMFILE.BUFFER` file system. 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file_obj` will never 
    pre-buffer when using the :attr:`Bass4Py.constants.STREAMFILE.BUFFERPUSH` 
    system. 
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_NET_PREBUF_WAIT)
      
    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_NET_PREBUF_WAIT, <DWORD>value)

  property net_timeout:
    """
    :obj:`int`: The time in milliseconds to wait for a server to respond to a connection request. 

    The default timeout is 5 seconds (5000 milliseconds). When playlist 
    processing is enabled via the :attr:`Bass4Py.bass.BASS.net_playlist` option, 
    the timeout applies to each playlist entry rather than the playlist as a whole. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_TIMEOUT)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_TIMEOUT, value)

  property net_read_timeout:
    """
    :obj:`int`: The time in milliseconds to wait for a server to deliver more data for an internet stream. 0 = no timeout. 
    
    When the timeout is hit, the connection with the server will be closed. 
    The default setting is 0, no timeout. Changes only affect subsequently 
    created streams, not any that already exist. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_READTIMEOUT)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_READTIMEOUT, value)

  property ogg_prescan:
    """
    :obj:`bool`: Pre-scan chained OGG files? 

    This option is enabled by default, and is equivalent to including the 
    :attr:`Bass4Py.constants.STREAM.PRESCAN` flag in a 
    :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file` call when opening 
    an OGG file. It can be disabled if seeking and an accurate length reading 
    are not required from chained OGG files, for faster stream creation. 
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_OGG_PRESCAN)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_OGG_PRESCAN, <DWORD>value)

  property pause_noplay:
    """
    :obj:`bool`: Prevent channels being played while the output is paused? 

    When the output is paused using :meth:`Bass4Py.bass.OutputDevice.pause`, 
    and this config option is enabled, channels cannot be played until the 
    output is resumed using :meth:`Bass4Py.bass.OutputDevice.start`. Any 
    attempts to play a channel will result in a 
    :exc:`Bass4Py.exceptions.BassStartError` error. By default, this config 
    option is enabled. 
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_PAUSE_NOPLAY)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_PAUSE_NOPLAY, <DWORD>value)

  property record_buffer:
    """
    :obj:`int`: The buffer length for recording channels. 

    The buffer length in milliseconds... 1000 (min) - 5000 (max). If the 
    length specified is outside this range, it is automatically capped. 

    Unlike a playback buffer, where the aim is to keep the buffer full, a 
    recording buffer is kept as empty as possible and so this setting has no 
    effect on latency. The default recording buffer length is 2000 
    milliseconds. Unless processing of the recorded data could cause 
    significant delays, or you want to use a large recording period with 
    :meth:`Bass4Py.bass.Record.start`, there should be no need to increase 
    this. Using this config option only affects the recording channels that 
    are created afterwards, not any that have already been created. So it is 
    possible to have channels with differing buffer lengths by using this 
    config option each time before creating them. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_REC_BUFFER)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_REC_BUFFER, value)

  property src:
    """
    :obj:`int`: The default sample rate conversion quality. 
    
    * 0 = linear interpolation, 
    * 1 = 8 point sinc interpolation, 
    * 2 = 16 point sinc interpolation, 
    * 3 = 32 point sinc interpolation, 
    * 4 = 64 point sinc interpolation. 
    
    Other values are also accepted. 

    This config option determines what sample rate conversion quality new 
    channels will initially have, except for sample channels (
    :class:`Bass4Py.bass.Channel`), which use the 
    :attr:`Bass4Py.bass.BASS.src_sample` setting. A channel's sample rate 
    conversion quality can subsequently be changed via the 
    :attr:`Bass4Py.bass.ChannelBase.src` attribute. When an SSE supporting CPU 
    is present, the default setting is 2, otherwise it is 1. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_SRC)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_SRC, value)

  property src_sample:
    """
    :obj:`int`: The default sample rate conversion quality for samples. 

    * 0 = linear interpolation, 
    * 1 = 8 point sinc interpolation, 
    * 2 = 16 point sinc interpolation, 
    * 3 = 32 point sinc interpolation, 
    * 4 = 64 point sinc interpolation.
    
    Other values are also accepted. 

    This config option determines what sample rate conversion quality a new 
    sample channel will initially have, retrieved by 
    :meth:`Bass4Py.bass.Sample.get_channel`. The channel's sample rate 
    conversion quality can subsequently be changed via the 
    :attr:`Bass4Py.bass.BASS.src` attribute. The default setting is 0 (linear 
    interpolation). 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_SRC_SAMPLE)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_SRC_SAMPLE, value)

  property update_period:
    """
    :obj:`int`: The update period of :class:`Bass4Py.bass.Stream` and 
    :class:`Bass4Py.bass.Music` channel playback buffers in milliseconds. 

    The update period in milliseconds... 0 = disable automatic updating. The 
    minimum period is 5ms, the maximum is 100ms. If the period specified is 
    outside this range, it is automatically capped. 

    The update period is the amount of time between updates of the playback 
    buffers of :class:`Bass4Py.bass.Stream` / :class:`Bass4Py.bass.Music` 
    channels that are playing; no update cycles occur when nothing is playing. 
    Shorter update periods allow smaller buffers to be set with the 
    :attr:`Bass4Py.bass.BASS.buffer` config option, but as the rate of updates 
    increases, so the overhead of setting up the updates becomes a greater 
    part of the CPU usage. The update period only affects 
    :class:`Bass4Py.bass.Stream` and :class:`Bass4Py.bass.Music` channels; it 
    does not affect samples. Nor does it have any effect on decoding channels, 
    as they are not played. BASS creates one or more threads (determined by 
    :attr:`Bass4Py.bass.BASS.update_threads`) specifically to perform the 
    updating, except when automatic updating is disabled (period = 0), in 
    which case :meth:`Bass4Py.bass.BASS.update`, 
    :meth:`Bass4Py.bass.Stream.update` or :meth:`Bass4Py.bass.Music.update` 
    should be used instead. This allows BASS's CPU usage to be synchronized 
    with your software's. For example, in a game loop you could call 
    :meth:`Bass4Py.bass.BASS.update` once per frame, to keep all the 
    processing in sync so that the frame rate is as smooth as possible. The 
    update period can be altered at any time, including during playback. The 
    default period is 100ms. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_UPDATEPERIOD)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_UPDATEPERIOD, value)

  property update_threads:
    """
    :obj:`int`: The number of threads to use for updating playback buffers. 0 = disable automatic updating. 

    The number of update threads determines how many 
    :class:`Bass4Py.bass.Stream` / :class:`Bass4Py.bass.Music` channel 
    playback buffers can be updated in parallel; each thread can process one 
    channel at a time. The default is to use a single thread, but additional 
    threads can be used to take advantage of multiple CPU cores. There is 
    generally nothing much to be gained by creating more threads than there 
    are CPU cores, but one benefit of using multiple threads even with a 
    single CPU core is that a slowly updating channel need not delay the 
    updating of other channels. When automatic updating is disabled (threads 
    = 0), :meth:`Bass4Py.bass.BASS.update`, :meth:`Bass4Py.bass.Stream.update` 
    or :meth:`Bass4Py.bass.Music.update` should be used instead. The number of 
    update threads can be changed at any time, including during playback. 

    Platform-specific

    The number of update threads is limited to 1 on the Windows CE platform. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_UPDATETHREADS)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_UPDATETHREADS, value)

  property verify:
    """
    :obj:`int`: The amount of data to check in order to verify/detect the file format. 

    The amount of data to check, in bytes... 1000 (min) to 1000000 (max). 
    If the value specified is outside this range, it is automatically capped. 

    Of the file formats supported as standard, this setting only affects the 
    detection of MP3/MP2/MP1 formats, but it may also be used by add-ons (see 
    the documentation). The verification length excludes any tags that may be 
    found at the start of the file. The default length is 16000 bytes. For 
    internet (and "buffered" user file) streams, the 
    :attr:`Bass4Py.bass.BASS.net_verify` setting determines how much data is 
    checked. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_VERIFY)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_VERIFY, value)

  property net_verify:
    """
    :obj:`int`: The amount of data to check in order to verify/detect the file format of internet streams. 

    The amount of data to check, in bytes... 1000 (min) to 1000000 (max), or 
    0 = 25% of the :attr:`Bass4Py.bass.BASS.verify` setting (with a minimum of 
    1000 bytes). If the value specified is outside this range, it is 
    automatically capped. 

    Of the file formats supported as standard, this setting only affects the 
    detection of MP3/MP2/MP1 formats, but it may also be used by add-ons (see 
    the documentation). The verification length excludes any tags that may be 
    found at the start of the file. The default setting is 0, which means 25% 
    of the :attr:`Bass4Py.bass.BASS.verify` setting. As well as internet 
    streams, this config setting also applies to "buffered" user file streams 
    created with :meth:`Bass4Py.bass.OutputDevice.create_stream_from_file_obj`. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_VERIFY_NET)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_VERIFY_NET, value)

  property device_update_period:
    """
    :obj:`int`: The output device update period in milliseconds, or in samples if negative. 

    The device update period determines how often data is generated and placed 
    in an output device's buffer. A shorter period allows a smaller buffer and 
    lower latency but may use more CPU than a longer period. The system may 
    choose to use a different period if the requested one is too short or 
    long, or needs rounding for granularity. The period actually being used 
    can be obtained with :attr:`Bass4Py.bass.OutputDevice.buffer`. The default 
    setting is 10ms. Changes only affect subsequently initialized devices, 
    not any that are already initialized. 

    Platform-specific

    On Windows, this config option only applies to the "No Sound" device; the 
    period with real devices is set by Windows (usually 10ms). 
    On Windows CE, the default setting is 50ms. 
    """
    def __get__(BASS self):
      return <int>BASS_GetConfig(_BASS_CONFIG_DEV_PERIOD)

    def __set__(BASS self, int value):
      BASS_SetConfig(_BASS_CONFIG_DEV_PERIOD, value)

  property handles:
    """
    :obj:`int`: Number of existing :class:`Bass4Py.bass.Music` / :class:`Bass4Py.bass.Record` / :class:`Bass4Py.bass.Sample` / :class:`Bass4Py.bass.Stream` handles. 

    This is a read-only config option that gives the total number of handles 
    that currently exist, which can be useful for detecting leaks, ie. unfreed 
    handles. Some add-ons may create their own handles for internal usage, so 
    a single stream can increase (and decrease when freed) the total number of 
    handles by more than one. 
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_HANDLES)

  property wasapi_persist:
    """
    :obj:`bool`: Retain Windows mixer settings across sessions? 

    When using WASAPI output, this option determines whether the volume and 
    mute settings in Windows mixer will persist across sessions, ie. the next 
    time your application runs. Those settings always persist when using 
    DirectSound output on Windows Vista and above. The default setting is True. 

    Platform-specific

    This config option is only available on Windows. 
    """
    def __get__(BASS self):

      IF UNAME_SYSNAME != "Windows":
        raise exceptions.BassPlatformError()
      ELSE:
        return <bint>BASS_GetConfig(_BASS_CONFIG_WASAPI_PERSIST)
      
    def __set__(BASS self, bint value):

      IF UNAME_SYSNAME != "Windows":
        raise exceptions.BassPlatformError()
      ELSE:
        BASS_SetConfig(_BASS_CONFIG_WASAPI_PERSIST, <DWORD>value)

  property lib_ssl:
    """
    :obj:`str` or :obj:`None`: The OpenSSL (or compatible) library to use for handling HTTPS connections. 

    Raises
    ------
    :exc:`Bass4Py.exceptions.BassPlatformError`
      the feature isn't supported on this platform


    The filename of the OpenSSL library to use... :obj:`None` = use default. This 
    should include the full path if it is not in the system library search path. 

    By default, BASS will try to use the system's OpenSSL library to handle 
    HTTPS connections. It will look for libssl.so, libssl.so.10, or 
    libssl.so.1.0.0. If the target system uses a different filename for it, or 
    you want to use a custom OpenSSL build, this option should be set to that. 
    That should be done before the first HTTPS connection is opened. If the 
    specified library cannot be loaded, BASS will fallback to trying the 
    defaults. 

    Platform-specific

    This option is only available on the Linux platform.
    """
    def __get__(BASS self):

      IF UNAME_SYSNAME != "Linux":
        raise exceptions.BassPlatformError()
      ELSE:
        cdef void *ssl = BASS_GetConfigPtr(_BASS_CONFIG_LIBSSL)

        if ssl == NULL:
          return None
        return (<char*>ssl).decode('utf-8')

    def __set__(BASS self, object value):
      cdef bytes data

      IF UNAME_SYSNAME != "Linux":
        raise exceptions.BassPlatformError()
      ELSE:

        if value is None:
          BASS_SetConfigPtr(_BASS_CONFIG_LIBSSL, NULL)
        else:
          data = to_readonly_bytes(value)
          BASS_SetConfigPtr(_BASS_CONFIG_LIBSSL, <unsigned char *>data)
