"""
This module holds the class which is the main entry point to all BASS-related functionalities.
"""

from .bassdevice cimport BASSDEVICE
from .bassexceptions import BassError,BassAPIError
from .bassplugin cimport BASSPLUGIN
from .bassversion cimport BASSVERSION

cdef extern from "Python.h":
  void PyEval_InitThreads()

cpdef __Evaluate():
  cdef DWORD error = BASS_ErrorGetCode()

  if error != _BASS_OK:
    raise BassError(error)

cdef class BASS:
  """
  This class offers multiple settings which can be changed to change how BASS works.
  It also provides methods to gain access to audio devices, represented as :class:`Bass4Py.bassdevice.BASSDEVICE` classes which then further allow to create streams, samples etc.
  """

  def __cinit__(BASS self):
    PyEval_InitThreads()

  cpdef GetDevice(BASS self, int device = -1):
    """
    Retrieves any audio device for further usage.
    
    :param device: device number to return, default is -1, which equals the current default device
    :type device: int
    :rtype: :class:`Bass4Py.bassdevice.BASSDEVICE` or None if the device isn't available
    """

    cdef int devicenumber = 1
    cdef BASSDEVICE odevice
    if device >= 0:
      odevice = BASSDEVICE(device)
      try:
        odevice.Status
      except BassError:
        return None
      return odevice
    elif device==-1:
      while True:
        odevice = BASSDEVICE(devicenumber)
        try:
          if odevice.Status & _BASS_DEVICE_DEFAULT == _BASS_DEVICE_DEFAULT:
            break
        except BassError:
          pass
        devicenumber += 1
      if odevice.Status & _BASS_DEVICE_DEFAULT != _BASS_DEVICE_DEFAULT:
        return None
      return odevice
    else:
      return None

  cpdef PluginLoad(BASS self, char *filename, DWORD flags = 0):
    """
    Loads a plugin library (dll or so file) to be used together with BASS

    Visit `un4seen.com <http://www.un4seen.com/>`_ for many plugins which extend the capabilities of this library.
    
    :param filename: path to the plugin file
    :type filename: string
    :param flags: flags which change the load procedure (see corresponding BASS documentation page)
    :type flags: int
    :rtype: :class:`Bass4Py.bassplugin.BASSPLUGIN` object

    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_PluginLoad.html>`_
    """
    cdef HPLUGIN plugin = BASS_PluginLoad(filename, flags)
    __Evaluate()
    return BASSPLUGIN(plugin)

  cpdef Update(BASS self, DWORD length):
    """
    Updates any :class:`Bass4Py.bassmusic.BASSMUSIC` and :class:`Bass4Py.bassstream.BASSSTREAM` playback buffers.
    
    :param length: miliseconds of data to be rendered
    :type length: int
    :rtype: True or False
    
    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_Update.html>`_
    """
    cdef bint res
    res = BASS_Update(length)
    __Evaluate()
    return res

  property CPU:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_GetCPU.html>`_

    .. note:: No setter implemented
    """

    def __get__(BASS self):
      return BASS_GetCPU()

  property Device:
    """
    :rtype: :class:`Bass4Py.bassdevice.BASSDEVICE` object with the currently active device

    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_GetDevice.html>`_

    .. note:: No setter implemented
    """
    def __get__(BASS self):
      cdef DWORD device=BASS_GetDevice()
      __Evaluate()
      return BASSDEVICE(device)

  property Error:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_ErrorGetCode.html>`_

    .. note:: No setter implemented
    """
    def __get__(BASS self):
      return BASS_ErrorGetCode()

  property Version:
    """
    :rtype: :class:`Bass4Py.bassversion.BASSVERSION` object representing the version information of the loaded library (dll or so file)

    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_GetVersion.html>`_

    .. note:: No setter implemented
    """
    def __get__(BASS self):
      return BASSVERSION(BASS_GetVersion())

  property NetAgent:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_NET_AGENT.html>`_
    """
    def __get__(BASS self):
      return <char *>BASS_GetConfigPtr(_BASS_CONFIG_NET_AGENT)

    def __set__(BASS self, char *value):
      BASS_SetConfigPtr(_BASS_CONFIG_NET_AGENT, <void*>value)
      __Evaluate()

  property NetProxy:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_NET_PROXY.html>`_
    """
    def __get__(BASS self):
      return <char*>BASS_GetConfigPtr(_BASS_CONFIG_NET_PROXY)

    def __set__(BASS self, char *value):
      BASS_SetConfigPtr(_BASS_CONFIG_NET_PROXY, <void*>value)
      __Evaluate()

  property Algorithm3D:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_3DALGORITHM.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_3DALGORITHM)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_3DALGORITHM, value)
      __Evaluate()

  property Airplay:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_AIRPLAY.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_AIRPLAY)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_AIRPLAY, value)
      __Evaluate()

  property AsyncBuffer:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_ASYNCFILE_BUFFER.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_ASYNCFILE_BUFFER)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_ASYNCFILE_BUFFER, value)
      __Evaluate()

  property Buffer:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_BUFFER.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_BUFFER)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_BUFFER, value)
      __Evaluate()

  property CurveVolume:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_CURVE_VOL.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_CURVE_VOL)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_CURVE_VOL, <DWORD>value)
      __Evaluate()

  property CurvePan:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_CURVE_PAN.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_CURVE_PAN)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_CURVE_PAN, <DWORD>value)
      __Evaluate()

  property DeviceBuffer:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_DEV_BUFFER.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_DEV_BUFFER)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_DEV_BUFFER, value)
      __Evaluate()

  property DefaultDevice:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_DEV_DEFAULT.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_DEV_DEFAULT)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_DEV_DEFAULT, <DWORD>value)
      __Evaluate()

  property FloatDsp:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_FLOATDSP.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_FLOATDSP)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_FLOATDSP, <DWORD>value)
      __Evaluate()

  property MusicVolume:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_GVOL_MUSIC.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_GVOL_MUSIC)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_GVOL_MUSIC, value)
      __Evaluate()

  property SampleVolume:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_GVOL_SAMPLE.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_GVOL_SAMPLE)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_GVOL_SAMPLE, value)
      __Evaluate()

  property StreamVolume:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_GVOL_STREAM.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_GVOL_STREAM)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_GVOL_STREAM, value)
      __Evaluate()

  property Video:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_MF_VIDEO.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_MF_VIDEO)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_MF_VIDEO, <DWORD>value)
      __Evaluate()

  property VirtualChannels:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_MUSIC_VIRTUAL.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_MUSIC_VIRTUAL)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_MUSIC_VIRTUAL, value)
      __Evaluate()

  property NetBuffer:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_NET_BUFFER.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_BUFFER)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_BUFFER, value)
      __Evaluate()

  property NetPassive:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_NET_PASSIVE.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_NET_PASSIVE)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_NET_PASSIVE, <DWORD>value)
      __Evaluate()

  property NetPlaylist:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_NET_PLAYLIST.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_PLAYLIST)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_PLAYLIST, value)
      __Evaluate()

  property NetPrebuf:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_NET_PREBUF.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_PREBUF)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_PREBUF, value)
      __Evaluate()

  property NetTimeout:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_NET_TIMEOUT.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_TIMEOUT)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_TIMEOUT, value)
      __Evaluate()

  property NetReadTimeout:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_NET_READTIMEOUT.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_NET_READTIMEOUT)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_NET_READTIMEOUT, value)
      __Evaluate()

  property OggPrescan:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_OGG_PRESCAN.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_OGG_PRESCAN)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_OGG_PRESCAN, <DWORD>value)
      __Evaluate()

  property PauseNoplay:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_PAUSE_NOPLAY.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_PAUSE_NOPLAY)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_PAUSE_NOPLAY, <DWORD>value)
      __Evaluate()

  property RecordBuffer:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_REC_BUFFER.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_REC_BUFFER)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_REC_BUFFER, value)
      __Evaluate()

  property SRC:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_SRC.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_SRC)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_SRC, value)
      __Evaluate()

  property SRCSample:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_SRC_SAMPLE.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_SRC_SAMPLE)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_SRC_SAMPLE, value)
      __Evaluate()

  property Unicode:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_UNICODE.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_UNICODE)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_UNICODE, <DWORD>value)
      __Evaluate()

  property UpdatePeriod:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_UPDATEPERIOD.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_UPDATEPERIOD)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_UPDATEPERIOD, value)
      __Evaluate()

  property UpdateThreads:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_UPDATETHREADS.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_UPDATETHREADS)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_UPDATETHREADS, value)
      __Evaluate()

  property Verify:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_VERIFY.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_VERIFY)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_VERIFY, value)
      __Evaluate()

  property NetVerify:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_VERIFY_NET.html>`_
    """
    def __get__(BASS self):
      return BASS_GetConfig(_BASS_CONFIG_VERIFY_NET)

    def __set__(BASS self, DWORD value):
      BASS_SetConfig(_BASS_CONFIG_VERIFY_NET, value)
      __Evaluate()

  property VistaSpeakers:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_VISTA_SPEAKERS.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_VISTA_SPEAKERS)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_VISTA_SPEAKERS, <DWORD>value)
      __Evaluate()

  property VistaTruepos:
    """
    .. seealso:: `<http://www.un4seen.com/doc/bass/_BASS_CONFIG_VISTA_TRUEPOS.html>`_
    """
    def __get__(BASS self):
      return <bint>BASS_GetConfig(_BASS_CONFIG_VISTA_TRUEPOS)

    def __set__(BASS self, bint value):
      BASS_SetConfig(_BASS_CONFIG_VISTA_TRUEPOS, <DWORD>value)
      __Evaluate()

  def __reduce__(BASS self):
    return (expand_reduced_bass,)

def expand_reduced_bass():
  return BASS()