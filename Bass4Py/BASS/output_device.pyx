from . cimport bass
from .music cimport Music
from .sample cimport Sample
from .stream cimport Stream
from .vector cimport Vector, CreateVector
from ..exceptions import BassAPIError, BassPlatformError

__EAXPresets={
  bass.EAX_PRESET_GENERIC: (bass.EAX_ENVIRONMENT_GENERIC, 0.5, 1.493, 0.5,),
  bass.EAX_PRESET_PADDEDCELL: (bass.EAX_ENVIRONMENT_PADDEDCELL, 0.25, 0.1, 0.0,),
  bass.EAX_PRESET_ROOM: (bass.EAX_ENVIRONMENT_ROOM, 0.417, 0.4, 0.666,),
  bass.EAX_PRESET_BATHROOM: (bass.EAX_ENVIRONMENT_BATHROOM, 0.653, 1.499, 0.166,),
  bass.EAX_PRESET_LIVINGROOM: (bass.EAX_ENVIRONMENT_LIVINGROOM, 0.208, 0.478, 0.0,),
  bass.EAX_PRESET_STONEROOM: (bass.EAX_ENVIRONMENT_STONEROOM, 0.5, 2.309, 0.888,),
  bass.EAX_PRESET_AUDITORIUM: (bass.EAX_ENVIRONMENT_AUDITORIUM, 0.403, 4.279, 0.5,),
  bass.EAX_PRESET_CONCERTHALL: (bass.EAX_ENVIRONMENT_CONCERTHALL, 0.5, 3.961, 0.5,),
  bass.EAX_PRESET_CAVE: (bass.EAX_ENVIRONMENT_CAVE, 0.5, 2.886, 1.304,),
  bass.EAX_PRESET_ARENA: (bass.EAX_ENVIRONMENT_ARENA, 0.361, 7.284, 0.332,),
  bass.EAX_PRESET_HANGAR: (bass.EAX_ENVIRONMENT_HANGAR, 0.5, 10.0, 0.3,),
  bass.EAX_PRESET_CARPETEDHALLWAY: (bass.EAX_ENVIRONMENT_CARPETEDHALLWAY, 0.153, 0.259, 2.0,),
  bass.EAX_PRESET_HALLWAY: (bass.EAX_ENVIRONMENT_HALLWAY, 0.361, 1.493, 0.0,),
  bass.EAX_PRESET_STONECORRIDOR: (bass.EAX_ENVIRONMENT_STONECORRIDOR, 0.444, 2.697, 0.638,),
  bass.EAX_PRESET_ALLEY: (bass.EAX_ENVIRONMENT_ALLEY, 0.25, 1.752, 0.776,),
  bass.EAX_PRESET_FOREST: (bass.EAX_ENVIRONMENT_FOREST, 0.111, 3.145, 0.472,),
  bass.EAX_PRESET_CITY: (bass.EAX_ENVIRONMENT_CITY, 0.111, 2.767, 0.224,),
  bass.EAX_PRESET_MOUNTAINS: (bass.EAX_ENVIRONMENT_MOUNTAINS, 0.194, 7.841, 0.472,),
  bass.EAX_PRESET_QUARRY: (bass.EAX_ENVIRONMENT_QUARRY, 1.0, 1.499, 0.5,),
  bass.EAX_PRESET_PLAIN: (bass.EAX_ENVIRONMENT_PLAIN, 0.097, 2.767, 0.224,),
  bass.EAX_PRESET_PARKINGLOT: (bass.EAX_ENVIRONMENT_PARKINGLOT, 0.208, 1.652, 1.5,),
  bass.EAX_PRESET_SEWERPIPE: (bass.EAX_ENVIRONMENT_SEWERPIPE, 0.652, 2.886, 0.25,),
  bass.EAX_PRESET_UNDERWATER: (bass.EAX_ENVIRONMENT_UNDERWATER, 1.0, 1.499, 0.0,),
  bass.EAX_PRESET_DRUGGED: (bass.EAX_ENVIRONMENT_DRUGGED, 0.875, 8.392, 1.388,),
  bass.EAX_PRESET_DIZZY: (bass.EAX_ENVIRONMENT_DIZZY, 0.139, 17.234, 0.666,),
  bass.EAX_PRESET_PSYCHOTIC: (bass.EAX_ENVIRONMENT_PSYCHOTIC, 0.486, 7.563, 0.806,)
}

cdef class OutputDevice:
  def __cinit__(OutputDevice self, int device):
    self._device=device

  def __richcmp__(OutputDevice self, other, int op):
    if op == 2:
      return (type(self) == type(other)) and (self._device == other._device)

  cdef BASS_DEVICEINFO _getdeviceinfo(OutputDevice self):
    cdef BASS_DEVICEINFO info
    bass.BASS_GetDeviceInfo(self._device, &info)
    return info

  cdef BASS_INFO _getinfo(OutputDevice self):
    cdef BASS_INFO info
    cdef bint res = bass.BASS_GetInfo(&info)
    return info

  cpdef Free(OutputDevice self):
    """
    Frees all device-related resources like streams, samples etc.
    
    :rtype: True or False

    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_Free.html>`_
    """
    cdef bint res
    self.Set()
    with nogil:
      res = bass.BASS_Free()
    bass.__Evaluate()
    return res

  cpdef Init(OutputDevice self, DWORD freq, DWORD flags, int win):
    """
    Initializes this device to be used by BASS. This needs to be done at least once before using any other playback-related functionalities.

    :param freq: frequency which the device gets initialized to
    :type freq: int
    :param flags: A set of flags which change the way the device operates. See the BASS documentation for more information.
    :type flags: int
    :param win: A handle to a window the device will be bound to, or 0 if no window should be attached.
    :type win: int
    :rtype: True or False

    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_Init.html>`_
    """
    IF UNAME_SYSNAME == "Windows":
      cdef HWND cwin = &win
    ELSE:
      cdef void * cwin = &win

    if win == 0:
      cwin = NULL
    cdef bint res = bass.BASS_Init(self._device, freq, flags, cwin, NULL)
    bass.__Evaluate()
    return res

  cpdef Pause(OutputDevice self):
    """
    Pauses all channels, samples etc. playing on this device.
    
    :rtype: True or False
    
    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_Pause.html>`_
    """
    cdef bint res
    self.Set()
    with nogil:
      res = bass.BASS_Pause()
    bass.__Evaluate()
    return res

  cpdef Set(OutputDevice self):
    """
    Sets this device to be used by any subsequent device-related function calls.
    
    This will be done by Bass4Py automatically whenever a method of a device gets executed.

    .. note:: This method still requires :meth:`Bass4Py.DEVICE.DEVICE.Init` to be executed earlier.

    :rtype: True or False
    
    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_SetDevice.html>`_
    """
    cdef bint res
    with nogil:
      res = bass.BASS_SetDevice(self._device)
    bass.__Evaluate()
    return res

  cpdef Start(OutputDevice self):
    cdef bint res
    self.Set()
    with nogil:
      res = bass.BASS_Start()
    bass.__Evaluate()
    return res

  cpdef Stop(OutputDevice self):
    cdef bint res
    self.Set()
    with nogil:
      res = bass.BASS_Stop()
    bass.__Evaluate()
    return res

  cpdef CreateStreamFromParameters(OutputDevice self, DWORD freq, DWORD chans, DWORD flags = 0, object callback = None):
    return Stream.FromParameters(freq, chans, flags, callback, self)

  cpdef CreateStreamFromBytes(OutputDevice self, const unsigned char[:] data, DWORD flags = 0, QWORD length = 0):
    return Stream.FromBytes(data, flags, length, self)

  cpdef CreateStreamFromFile(OutputDevice self, object filename, DWORD flags = 0, QWORD offset = 0):
    return Stream.FromFile(filename, flags, offset, self)

  cpdef CreateStreamFromURL(OutputDevice self, object url, DWORD flags = 0, QWORD offset = 0, object callback = None):
    return Stream.FromURL(url, flags, offset, callback, self)

  cpdef CreateStream(OutputDevice self):
    return Stream.FromDevice(self)

  cpdef CreateStream3D(OutputDevice self):
    return Stream.FromDevice3D(self)

  cpdef CreateStreamFromFileObj(OutputDevice self, object obj, DWORD system = bass._STREAMFILE_BUFFER, DWORD flags = 0):
    return Stream.FromFileObj(obj, system, flags, self)

  cpdef CreateSampleFromBytes(OutputDevice self, const unsigned char[:] data, DWORD max = 65535, DWORD flags = 0, DWORD length = 0):
    return Sample.FromBytes(data, max, flags, length, self)

  cpdef CreateSampleFromFile(OutputDevice self, object filename, DWORD max = 65535, DWORD flags = 0, QWORD offset = 0):
    return Sample.FromFile(filename, max, flags, offset, self)

  cpdef CreateSampleFromParameters(OutputDevice self, DWORD length, DWORD freq, DWORD chans, DWORD max = 65535, DWORD flags = 0):
    return Sample.FromParameters(length, freq, chans, max, flags, self)

  cpdef CreateMusicFromBytes(OutputDevice self, const unsigned char[:] data, DWORD flags = 0, QWORD length = 0, bint device_frequency = True):
    return Music.FromBytes(data, flags, length, device_frequency, self)

  cpdef CreateMusicFromFile(OutputDevice self, object filename, DWORD flags = 0, QWORD offset = 0, bint device_frequency = True):
    return Music.FromFile(filename, flags, offset, device_frequency, self)

  cpdef EAXPreset(OutputDevice self, int preset):
    cdef int env
    cdef float vol, decay, damp

    IF UNAME_SYSNAME != "Windows":
      raise BassPlatformError()
    ELSE:

      self.Set()

      if not preset in __EAXPresets:
        raise BassAPIError
      env = <int>__EAXPresets[preset][0]
      vol = <float>__EAXPresets[preset][1]
      decay = <float>__EAXPresets[preset][2]
      damp = <float>__EAXPresets[preset][3]
      bass.BASS_SetEAXParameters(env, vol, decay, damp)
      bass.__Evaluate()

  property Name:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      bass.__Evaluate()
      return info.name.decode('utf-8')

  property Driver:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      bass.__Evaluate()
      if info.driver == NULL:
        return u''
      return info.driver.decode('utf-8')

  property Enabled:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      bass.__Evaluate()
      return <bint>(info.flags&bass._BASS_DEVICE_ENABLED)

  property Default:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      bass.__Evaluate()
      return <bint>(info.flags&bass._BASS_DEVICE_DEFAULT)

  property Initialized:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      bass.__Evaluate()
      return <bint>(info.flags&bass._BASS_DEVICE_INIT)

  property Type:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      bass.__Evaluate()

      if info.flags&bass._BASS_DEVICE_TYPE_MASK:

        from ..constants import DEVICE_TYPE

        return DEVICE_TYPE(info.flags&bass._BASS_DEVICE_TYPE_MASK)
      return None

  property Flags:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.flags

  property Memory:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.hwsize

  property MemoryFree:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info= self._getinfo()
      bass.__Evaluate()
      return info.hwfree

  property FreeSamples:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.freesam

  property Free3D:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.free3d

  property MinimumRate:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.minrate

  property MaximumRate:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.maxrate

  property EAX:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.eax

  property DirectX:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.dsver

  property Buffer:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.minbuf

  property Latency:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.latency

  property InitFlags:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()

      from ..constants import DEVICE

      return DEVICE(info.initflags)

  property Speakers:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.speakers

  property Frequency:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      bass.__Evaluate()
      return info.freq

  property Volume:
    def __get__(OutputDevice self):
      cdef float volume
      self.Set()
      volume = bass.BASS_GetVolume()
      bass.__Evaluate()
      return volume

    def __set__(OutputDevice self, float value):
      cdef bint res
      self.Set()
      with nogil:
        res = bass.BASS_SetVolume(value)
      bass.__Evaluate()

  property Position3D:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR pos
      self.Set()
      bass.BASS_Get3DPosition(&pos, NULL, NULL, NULL)
      bass.__Evaluate()
      return CreateVector(&pos)

    def __set__(OutputDevice self, Vector value):
      cdef BASS_3DVECTOR pos
      cdef bint res
      self.Set()
      value.Resolve(&pos)
      res = bass.BASS_Set3DPosition(&pos, NULL, NULL, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Velocity3D:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR vel
      self.Set()
      bass.BASS_Get3DPosition(NULL, &vel, NULL, NULL)
      bass.__Evaluate()
      return CreateVector(&vel)
    def __set__(OutputDevice self,Vector value):
      cdef BASS_3DVECTOR vel
      cdef bint res
      self.Set()
      value.Resolve(&vel)
      res = bass.BASS_Set3DPosition(NULL, &vel, NULL, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Front3D:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR front, top
      self.Set()
      bass.BASS_Get3DPosition(NULL, NULL, &front, &top)
      bass.__Evaluate()
      return CreateVector(&front)
    def __set__(OutputDevice self, Vector value):
      cdef BASS_3DVECTOR front, top
      cdef bint res
      self.Set()
      bass.BASS_Get3DPosition(NULL, NULL, &front, &top)
      value.Resolve(&front)
      res = bass.BASS_Set3DPosition(NULL, NULL, &front, &top)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Top3D:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR front, top
      self.Set()
      bass.BASS_Get3DPosition(NULL, NULL, &front, &top)
      bass.__Evaluate()
      return CreateVector(&top)

    def __set__(OutputDevice self,Vector value):
      cdef BASS_3DVECTOR front, top
      cdef bint res
      self.Set()
      bass.BASS_Get3DPosition(NULL, NULL, &front, &top)
      value.Resolve(&top)
      res = bass.BASS_Set3DPosition(NULL, NULL, &front, &top)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Distance:
    def __get__(OutputDevice self):
      cdef float distf
      self.Set()
      bass.BASS_Get3DFactors(&distf, NULL, NULL)
      bass.__Evaluate()
      return distf

    def __set__(OutputDevice self, float value):
      self.Set()
      bass.BASS_Set3DFactors(value,-1.0,-1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Rolloff:
    def __get__(OutputDevice self):
      cdef float rollf
      self.Set()
      bass.BASS_Get3DFactors(NULL, &rollf, NULL)
      bass.__Evaluate()
      return rollf

    def __set__(OutputDevice self,float value):
      self.Set()
      bass.BASS_Set3DFactors(-1.0, value, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Doppler:
    def __get__(OutputDevice self):
      cdef float doppf
      self.Set()
      bass.BASS_Get3DFactors(NULL, NULL, &doppf)
      bass.__Evaluate()
      return doppf

    def __set__(OutputDevice self,float value):
      self.Set()
      bass.BASS_Set3DFactors(-1.0, -1.0, value)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property EAXEnvironment:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef DWORD env
        self.Set()
        bass.BASS_GetEAXParameters(&env, NULL, NULL, NULL)
        bass.__Evaluate()
        return <int>env

    def __set__(OutputDevice self, int value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        bass.BASS_SetEAXParameters(value, -1.0, -1.0, -1.0)
        bass.__Evaluate()

  property EAXVolume:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef float vol
        self.Set()
        bass.BASS_GetEAXParameters(NULL, &vol, NULL, NULL)
        bass.__Evaluate()
        return vol

    def __set__(OutputDevice self, float value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        bass.BASS_SetEAXParameters(-1, value, -1.0, -1.0)
        bass.__Evaluate()

  property EAXDecay:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef float decay
        self.Set()
        bass.BASS_GetEAXParameters(NULL, NULL, &decay, NULL)
        bass.__Evaluate()
        return decay

    def __set__(OutputDevice self, float value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        bass.BASS_SetEAXParameters(-1, -1.0, value, -1.0)
        bass.__Evaluate()

  property EAXDamping:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef float damp
        self.Set()
        bass.BASS_GetEAXParameters(NULL, NULL, NULL, &damp)
        bass.__Evaluate()
        return damp

    def __set__(OutputDevice self, float value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        bass.BASS_SetEAXParameters(-1, -1.0, -1.0, value)
        bass.__Evaluate()

  property Started:
    def __get__(OutputDevice self):
      cdef bint res
      self.Set()
      res = bass.BASS_IsStarted()
      bass.__Evaluate()
      return res
