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

cdef class OutputDevice(Evaluable):
  def __cinit__(OutputDevice self, int device):
    self._device=device

  def __richcmp__(OutputDevice self, other, int op):
    if op == 2:
      return (type(self) == type(other)) and (self._device == other._device)

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
    Frees all device-related resources like streams, samples etc.
    
    :rtype: True or False

    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_Free.html>`_
    """
    cdef bint res
    self.set()
    with nogil:
      res = BASS_Free()
    self._evaluate()
    return res

  cpdef init(OutputDevice self, DWORD freq = 44100, DWORD flags = 0):
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
    cdef bint res = BASS_Init(self._device, freq, flags, NULL, NULL)
    self._evaluate()
    return res

  cpdef pause(OutputDevice self):
    """
    Pauses all channels, samples etc. playing on this device.
    
    :rtype: True or False
    
    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_Pause.html>`_
    """
    cdef bint res
    self.set()
    with nogil:
      res = BASS_Pause()
    self._evaluate()
    return res

  cpdef set(OutputDevice self):
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
    self._evaluate()
    return res

  cpdef start(OutputDevice self):
    cdef bint res
    self.set()
    with nogil:
      res = BASS_Start()
    self._evaluate()
    return res

  cpdef stop(OutputDevice self):
    cdef bint res
    self.set()
    with nogil:
      res = BASS_Stop()
    self._evaluate()
    return res

  cpdef create_stream_from_parameters(OutputDevice self, DWORD freq, DWORD chans, DWORD flags = 0, object callback = None):
    return Stream.from_parameters(freq, chans, flags, callback, self)

  cpdef create_stream_from_bytes(OutputDevice self, const unsigned char[:] data, DWORD flags = 0, QWORD length = 0):
    return Stream.from_bytes(data, flags, length, self)

  cpdef create_stream_from_file(OutputDevice self, object filename, DWORD flags = 0, QWORD offset = 0):
    return Stream.from_file(filename, flags, offset, self)

  cpdef create_stream_from_url(OutputDevice self, object url, DWORD flags = 0, QWORD offset = 0, object callback = None):
    return Stream.from_url(url, flags, offset, callback, self)

  cpdef create_stream(OutputDevice self):
    return Stream.from_device(self)

  cpdef create_stream_3d(OutputDevice self):
    return Stream.from_device_3d(self)

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

  cpdef eax_preset(OutputDevice self, int preset):
    cdef int env
    cdef float vol, decay, damp

    IF UNAME_SYSNAME != "Windows":
      raise BassPlatformError()
    ELSE:

      self.set()

      if not preset in __EAXPresets:
        raise BassAPIError
      env = <int>__EAXPresets[preset][0]
      vol = <float>__EAXPresets[preset][1]
      decay = <float>__EAXPresets[preset][2]
      damp = <float>__EAXPresets[preset][3]
      BASS_SetEAXParameters(env, vol, decay, damp)
      self._evaluate()

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

        from ..constants import DEVICE_TYPE

        return DEVICE_TYPE(info.flags&_BASS_DEVICE_TYPE_MASK)
      return None

  property flags:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.flags

  property memory:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.hwsize

  property memory_free:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info= self._get_info()
      self._evaluate()
      return info.hwfree

  property free_samples:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.freesam

  property free_3d:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.free3d

  property minimum_rate:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.minrate

  property maximum_rate:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.maxrate

  property eax:
    def __get__(OutputDevice self):
      cdef BASS_INFO info
      self.set()
      info = self._get_info()
      self._evaluate()
      return info.eax

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

      from ..constants import DEVICE

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

  property eax_environment:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef DWORD env
        self.set()
        BASS_GetEAXParameters(&env, NULL, NULL, NULL)
        self._evaluate()
        return <int>env

    def __set__(OutputDevice self, int value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.set()
        BASS_SetEAXParameters(value, -1.0, -1.0, -1.0)
        self._evaluate()

  property eax_volume:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef float vol
        self.set()
        BASS_GetEAXParameters(NULL, &vol, NULL, NULL)
        self._evaluate()
        return vol

    def __set__(OutputDevice self, float value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.set()
        BASS_SetEAXParameters(-1, value, -1.0, -1.0)
        self._evaluate()

  property eax_decay:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef float decay
        self.set()
        BASS_GetEAXParameters(NULL, NULL, &decay, NULL)
        self._evaluate()
        return decay

    def __set__(OutputDevice self, float value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.set()
        BASS_SetEAXParameters(-1, -1.0, value, -1.0)
        self._evaluate()

  property eax_damping:
    def __get__(OutputDevice self):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        cdef float damp
        self.set()
        BASS_GetEAXParameters(NULL, NULL, NULL, &damp)
        self._evaluate()
        return damp

    def __set__(OutputDevice self, float value):

      IF UNAME_SYSNAME != "Windows":
        raise BassPlatformError()
      ELSE:

        self.set()
        BASS_SetEAXParameters(-1, -1.0, -1.0, value)
        self._evaluate()

  property started:
    def __get__(OutputDevice self):
      cdef bint res
      self.set()
      res = BASS_IsStarted()
      self._evaluate()
      return res
