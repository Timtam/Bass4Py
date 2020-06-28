from .bass cimport __Evaluate
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

IF UNAME_SYSNAME=="Windows":
  from ..bindings.bass cimport (
    BASS_GetEAXParameters,
    BASS_SetEAXParameters,
    EAX_PRESET_GENERIC,
    EAX_ENVIRONMENT_GENERIC,
    EAX_PRESET_PADDEDCELL,
    EAX_ENVIRONMENT_PADDEDCELL,
    EAX_PRESET_ROOM,
    EAX_ENVIRONMENT_ROOM,
    EAX_PRESET_BATHROOM,
    EAX_ENVIRONMENT_BATHROOM,
    EAX_PRESET_LIVINGROOM,
    EAX_ENVIRONMENT_LIVINGROOM,
    EAX_PRESET_STONEROOM,
    EAX_ENVIRONMENT_STONEROOM,
    EAX_PRESET_AUDITORIUM,
    EAX_ENVIRONMENT_AUDITORIUM,
    EAX_PRESET_CONCERTHALL,
    EAX_ENVIRONMENT_CONCERTHALL,
    EAX_PRESET_CAVE,
    EAX_ENVIRONMENT_CAVE,
    EAX_PRESET_ARENA,
    EAX_ENVIRONMENT_ARENA,
    EAX_PRESET_HANGAR,
    EAX_ENVIRONMENT_HANGAR,
    EAX_PRESET_CARPETEDHALLWAY,
    EAX_ENVIRONMENT_CARPETEDHALLWAY,
    EAX_PRESET_HALLWAY,
    EAX_ENVIRONMENT_HALLWAY,
    EAX_PRESET_STONECORRIDOR,
    EAX_ENVIRONMENT_STONECORRIDOR,
    EAX_PRESET_ALLEY,
    EAX_ENVIRONMENT_ALLEY,
    EAX_PRESET_FOREST,
    EAX_ENVIRONMENT_FOREST,
    EAX_PRESET_CITY,
    EAX_ENVIRONMENT_CITY,
    EAX_PRESET_MOUNTAINS,
    EAX_ENVIRONMENT_MOUNTAINS,
    EAX_PRESET_QUARRY,
    EAX_ENVIRONMENT_QUARRY,
    EAX_PRESET_PLAIN,
    EAX_ENVIRONMENT_PLAIN,
    EAX_PRESET_PARKINGLOT,
    EAX_ENVIRONMENT_PARKINGLOT,
    EAX_PRESET_SEWERPIPE,
    EAX_ENVIRONMENT_SEWERPIPE,
    EAX_PRESET_UNDERWATER,
    EAX_ENVIRONMENT_UNDERWATER,
    EAX_PRESET_DRUGGED,
    EAX_ENVIRONMENT_DRUGGED,
    EAX_PRESET_DIZZY,
    EAX_ENVIRONMENT_DIZZY,
    EAX_PRESET_PSYCHOTIC,
    EAX_ENVIRONMENT_PSYCHOTIC)

  __EAXPresets={
    EAX_PRESET_GENERIC: (EAX_ENVIRONMENT_GENERIC, 0.5, 1.493, 0.5,),
    EAX_PRESET_PADDEDCELL: (EAX_ENVIRONMENT_PADDEDCELL, 0.25, 0.1, 0.0,),
    EAX_PRESET_ROOM: (EAX_ENVIRONMENT_ROOM, 0.417, 0.4, 0.666,),
    EAX_PRESET_BATHROOM: (EAX_ENVIRONMENT_BATHROOM, 0.653, 1.499, 0.166,),
    EAX_PRESET_LIVINGROOM: (EAX_ENVIRONMENT_LIVINGROOM, 0.208, 0.478, 0.0,),
    EAX_PRESET_STONEROOM: (EAX_ENVIRONMENT_STONEROOM, 0.5, 2.309, 0.888,),
    EAX_PRESET_AUDITORIUM: (EAX_ENVIRONMENT_AUDITORIUM, 0.403, 4.279, 0.5,),
    EAX_PRESET_CONCERTHALL: (EAX_ENVIRONMENT_CONCERTHALL, 0.5, 3.961, 0.5,),
    EAX_PRESET_CAVE: (EAX_ENVIRONMENT_CAVE, 0.5, 2.886, 1.304,),
    EAX_PRESET_ARENA: (EAX_ENVIRONMENT_ARENA, 0.361, 7.284, 0.332,),
    EAX_PRESET_HANGAR: (EAX_ENVIRONMENT_HANGAR, 0.5, 10.0, 0.3,),
    EAX_PRESET_CARPETEDHALLWAY: (EAX_ENVIRONMENT_CARPETEDHALLWAY, 0.153, 0.259, 2.0,),
    EAX_PRESET_HALLWAY: (EAX_ENVIRONMENT_HALLWAY, 0.361, 1.493, 0.0,),
    EAX_PRESET_STONECORRIDOR: (EAX_ENVIRONMENT_STONECORRIDOR, 0.444, 2.697, 0.638,),
    EAX_PRESET_ALLEY: (EAX_ENVIRONMENT_ALLEY, 0.25, 1.752, 0.776,),
    EAX_PRESET_FOREST: (EAX_ENVIRONMENT_FOREST, 0.111, 3.145, 0.472,),
    EAX_PRESET_CITY: (EAX_ENVIRONMENT_CITY, 0.111, 2.767, 0.224,),
    EAX_PRESET_MOUNTAINS: (EAX_ENVIRONMENT_MOUNTAINS, 0.194, 7.841, 0.472,),
    EAX_PRESET_QUARRY: (EAX_ENVIRONMENT_QUARRY, 1.0, 1.499, 0.5,),
    EAX_PRESET_PLAIN: (EAX_ENVIRONMENT_PLAIN, 0.097, 2.767, 0.224,),
    EAX_PRESET_PARKINGLOT: (EAX_ENVIRONMENT_PARKINGLOT, 0.208, 1.652, 1.5,),
    EAX_PRESET_SEWERPIPE: (EAX_ENVIRONMENT_SEWERPIPE, 0.652, 2.886, 0.25,),
    EAX_PRESET_UNDERWATER: (EAX_ENVIRONMENT_UNDERWATER, 1.0, 1.499, 0.0,),
    EAX_PRESET_DRUGGED: (EAX_ENVIRONMENT_DRUGGED, 0.875, 8.392, 1.388,),
    EAX_PRESET_DIZZY: (EAX_ENVIRONMENT_DIZZY, 0.139, 17.234, 0.666,),
    EAX_PRESET_PSYCHOTIC: (EAX_ENVIRONMENT_PSYCHOTIC, 0.486, 7.563, 0.806,)
  }



from .music cimport Music
from .sample cimport Sample
from .stream cimport Stream
from .vector cimport Vector, CreateVector
from ..exceptions import BassAPIError, BassPlatformError

cdef class OutputDevice:
  def __cinit__(OutputDevice self, int device):
    self._device=device

  def __richcmp__(OutputDevice self, other, int op):
    if op == 2:
      return (type(self) == type(other)) and (self._device == other._device)

  cdef BASS_DEVICEINFO _getdeviceinfo(OutputDevice self):
    cdef BASS_DEVICEINFO info
    BASS_GetDeviceInfo(self._device, &info)
    return info

  cdef BASS_INFO _getinfo(OutputDevice self):
    cdef BASS_INFO info
    cdef bint res = BASS_GetInfo(&info)
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
      res = BASS_Free()
    __Evaluate()
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
    cdef bint res = BASS_Init(self._device, freq, flags, cwin, NULL)
    __Evaluate()
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
      res = BASS_Pause()
    __Evaluate()
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
      res = BASS_SetDevice(self._device)
    __Evaluate()
    return res

  cpdef Start(OutputDevice self):
    cdef bint res
    self.Set()
    with nogil:
      res = BASS_Start()
    __Evaluate()
    return res

  cpdef Stop(OutputDevice self):
    cdef bint res
    self.Set()
    with nogil:
      res = BASS_Stop()
    __Evaluate()
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

  cpdef CreateStreamFromFileObj(OutputDevice self, object obj, DWORD system = _STREAMFILE_BUFFER, DWORD flags = 0):
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
      BASS_SetEAXParameters(env, vol, decay, damp)
      __Evaluate()

  property Name:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      return info.name.decode('utf-8')

  property Driver:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      if info.driver == NULL:
        return u''
      return info.driver.decode('utf-8')

  property Enabled:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      return <bint>(info.flags&_BASS_DEVICE_ENABLED)

  property Default:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      return <bint>(info.flags&_BASS_DEVICE_DEFAULT)

  property Initialized:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()
      return <bint>(info.flags&_BASS_DEVICE_INIT)

  property Type:
    def __get__(OutputDevice self):
      cdef BASS_DEVICEINFO info
      info = self._getdeviceinfo()
      __Evaluate()

      if info.flags&_BASS_DEVICE_TYPE_MASK:

        from ..constants import DEVICE_TYPE

        return DEVICE_TYPE(info.flags&_BASS_DEVICE_TYPE_MASK)
      return None

  property Flags:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.flags

  property Memory:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.hwsize

  property MemoryFree:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info= self._getinfo()
      __Evaluate()
      return info.hwfree

  property FreeSamples:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.freesam

  property Free3D:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.free3d

  property MinimumRate:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.minrate

  property MaximumRate:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.maxrate

  property EAX:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.eax

  property DirectX:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.dsver

  property Buffer:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.minbuf

  property Latency:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.latency

  property InitFlags:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()

      from ..constants import DEVICE

      return DEVICE(info.initflags)

  property Speakers:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.speakers

  property Frequency:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.Set()
      info = self._getinfo()
      __Evaluate()
      return info.freq

  property Volume:
    def __get__(OutputDevice self):
      cdef float volume
      self.Set()
      volume = BASS_GetVolume()
      __Evaluate()
      return volume

    def __set__(OutputDevice self, float value):
      cdef bint res
      self.Set()
      with nogil:
        res = BASS_SetVolume(value)
      __Evaluate()

  property Position3D:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR pos
      self.Set()
      BASS_Get3DPosition(&pos, NULL, NULL, NULL)
      __Evaluate()
      return CreateVector(&pos)

    def __set__(OutputDevice self, Vector value):
      cdef BASS_3DVECTOR pos
      cdef bint res
      self.Set()
      value.Resolve(&pos)
      res = BASS_Set3DPosition(&pos, NULL, NULL, NULL)
      __Evaluate()
      BASS_Apply3D()

  property Velocity3D:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR vel
      self.Set()
      BASS_Get3DPosition(NULL, &vel, NULL, NULL)
      __Evaluate()
      return CreateVector(&vel)
    def __set__(OutputDevice self,Vector value):
      cdef BASS_3DVECTOR vel
      cdef bint res
      self.Set()
      value.Resolve(&vel)
      res = BASS_Set3DPosition(NULL, &vel, NULL, NULL)
      __Evaluate()
      BASS_Apply3D()

  property Front3D:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR front, top
      self.Set()
      BASS_Get3DPosition(NULL, NULL, &front, &top)
      __Evaluate()
      return CreateVector(&front)
    def __set__(OutputDevice self, Vector value):
      cdef BASS_3DVECTOR front, top
      cdef bint res
      self.Set()
      BASS_Get3DPosition(NULL, NULL, &front, &top)
      value.Resolve(&front)
      res = BASS_Set3DPosition(NULL, NULL, &front, &top)
      __Evaluate()
      BASS_Apply3D()

  property Top3D:
    def __get__(OutputDevice self):
      cdef BASS_3DVECTOR front, top
      self.Set()
      BASS_Get3DPosition(NULL, NULL, &front, &top)
      __Evaluate()
      return CreateVector(&top)

    def __set__(OutputDevice self,Vector value):
      cdef BASS_3DVECTOR front, top
      cdef bint res
      self.Set()
      BASS_Get3DPosition(NULL, NULL, &front, &top)
      value.Resolve(&top)
      res = BASS_Set3DPosition(NULL, NULL, &front, &top)
      __Evaluate()
      BASS_Apply3D()

  property Distance:
    def __get__(OutputDevice self):
      cdef float distf
      self.Set()
      BASS_Get3DFactors(&distf, NULL, NULL)
      __Evaluate()
      return distf

    def __set__(OutputDevice self, float value):
      self.Set()
      BASS_Set3DFactors(value,-1.0,-1.0)
      __Evaluate()
      BASS_Apply3D()

  property Rolloff:
    def __get__(OutputDevice self):
      cdef float rollf
      self.Set()
      BASS_Get3DFactors(NULL, &rollf, NULL)
      __Evaluate()
      return rollf

    def __set__(OutputDevice self,float value):
      self.Set()
      BASS_Set3DFactors(-1.0, value, -1.0)
      __Evaluate()
      BASS_Apply3D()

  property Doppler:
    def __get__(OutputDevice self):
      cdef float doppf
      self.Set()
      BASS_Get3DFactors(NULL, NULL, &doppf)
      __Evaluate()
      return doppf

    def __set__(OutputDevice self,float value):
      self.Set()
      BASS_Set3DFactors(-1.0, -1.0, value)
      __Evaluate()
      BASS_Apply3D()

  property EAXEnvironment:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef DWORD env
        self.Set()
        BASS_GetEAXParameters(&env, NULL, NULL, NULL)
        __Evaluate()
        return <int>env

    def __set__(OutputDevice self, int value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        BASS_SetEAXParameters(value, -1.0, -1.0, -1.0)
        __Evaluate()

  property EAXVolume:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef float vol
        self.Set()
        BASS_GetEAXParameters(NULL, &vol, NULL, NULL)
        __Evaluate()
        return vol

    def __set__(OutputDevice self, float value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        BASS_SetEAXParameters(-1, value, -1.0, -1.0)
        __Evaluate()

  property EAXDecay:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef float decay
        self.Set()
        BASS_GetEAXParameters(NULL, NULL, &decay, NULL)
        __Evaluate()
        return decay

    def __set__(OutputDevice self, float value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        BASS_SetEAXParameters(-1, -1.0, value, -1.0)
        __Evaluate()

  property EAXDamping:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef float damp
        self.Set()
        BASS_GetEAXParameters(NULL, NULL, NULL, &damp)
        __Evaluate()
        return damp

    def __set__(OutputDevice self, float value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.Set()
        BASS_SetEAXParameters(-1, -1.0, -1.0, value)
        __Evaluate()

  property Started:
    def __get__(OutputDevice self):
      cdef bint res
      self.Set()
      res = BASS_IsStarted()
      __Evaluate()
      return res
