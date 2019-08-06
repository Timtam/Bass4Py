from . cimport bass
from .bassmusic cimport BASSMUSIC
from .basssample cimport BASSSAMPLE
from .bassstream cimport BASSSTREAM
from .bassvector cimport BASSVECTOR, BASSVECTOR_Create
from .exceptions import BassAPIError
from types import FunctionType

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

cdef class BASSDEVICE:
  def __cinit__(BASSDEVICE self, int device):
    self.__device=device

  def __richcmp__(BASSDEVICE self, other, int op):
    if op == 2:
      return (type(self) == type(other)) and (self.__device == other.__device)

  cdef BASS_DEVICEINFO __getdeviceinfo(BASSDEVICE self):
    cdef BASS_DEVICEINFO info
    bass.BASS_GetDeviceInfo(self.__device, &info)
    return info

  cdef BASS_INFO __getinfo(BASSDEVICE self):
    cdef BASS_INFO info
    cdef bint res = bass.BASS_GetInfo(&info)
    return info

  cpdef Free(BASSDEVICE self):
    """
    Frees all device-related resources like streams, samples etc.
    
    :rtype: True or False

    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_Free.html>`_
    """
    cdef bint res
    self.Set()
    res = bass.BASS_Free()
    bass.__Evaluate()
    return res

  cpdef Init(BASSDEVICE self, DWORD freq, DWORD flags, int win):
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
    cdef HWND cwin = &win
    if win == 0:
      cwin = NULL
    cdef bint res = bass.BASS_Init(self.__device, freq, flags, cwin, NULL)
    bass.__Evaluate()
    return res

  cpdef Pause(BASSDEVICE self):
    """
    Pauses all channels, samples etc. playing on this device.
    
    :rtype: True or False
    
    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_Pause.html>`_
    """
    cdef bint res
    self.Set()
    res = bass.BASS_Pause()
    bass.__Evaluate()
    return res

  cpdef Set(BASSDEVICE self):
    """
    Sets this device to be used by any subsequent device-related function calls.
    
    This will be done by Bass4Py automatically whenever a method of a device gets executed.

    .. note:: This method still requires :meth:`Bass4Py.bassdevice.BASSDEVICE.Init` to be executed earlier.

    :rtype: True or False
    
    .. seealso:: `<http://www.un4seen.com/doc/bass/BASS_SetDevice.html>`_
    """
    cdef bint res = bass.BASS_SetDevice(self.__device)
    bass.__Evaluate()
    return res

  cpdef Start(BASSDEVICE self):
    cdef bint res
    self.Set()
    res = bass.BASS_Start()
    bass.__Evaluate()
    return res

  cpdef Stop(BASSDEVICE self):
    cdef bint res
    self.Set()
    res = bass.BASS_Stop()
    bass.__Evaluate()
    return res

  cpdef CreateStreamFromParameters(BASSDEVICE self, DWORD freq, DWORD chans, DWORD flags = 0, object callback = None):
    return BASSSTREAM.FromParameters(freq, chans, flags, callback, self)

  cpdef CreateStreamFromBytes(BASSDEVICE self, const unsigned char[:] data, DWORD flags = 0, QWORD length = 0):
    return BASSSTREAM.FromBytes(data, flags, length, self)

  cpdef CreateStreamFromFile(BASSDEVICE self, object filename, DWORD flags = 0, QWORD offset = 0):
    return BASSSTREAM.FromFile(filename, flags, offset, self)

  cpdef CreateStreamFromURL(BASSDEVICE self, object url, DWORD flags = 0, QWORD offset = 0, object callback = None):
    return BASSSTREAM.FromURL(url, flags, offset, callback, self)

  cpdef CreateStream(BASSDEVICE self):
    return BASSSTREAM.FromDevice(self)

  cpdef CreateStreamFromFileObj(BASSDEVICE self, object obj, DWORD system = bass._STREAMFILE_BUFFER, DWORD flags = 0):
    return BASSSTREAM.FromFileObj(obj, system, flags, self)

  cpdef SampleLoad(BASSDEVICE self, bint mem, char *file, QWORD offset=0, DWORD length=0, DWORD max=65535, DWORD flags=0):
    cdef void *ptr = <void*>file
    cdef HSAMPLE res
    self.Set()
    if mem and length == 0:
      length = len(file)
    res = bass.BASS_SampleLoad(mem, ptr, offset, length, max, flags)
    bass.__Evaluate()
    return BASSSAMPLE(res)

  cpdef SampleCreate(BASSDEVICE self, DWORD length, DWORD freq, DWORD chans, DWORD max, DWORD flags):
    cdef HSAMPLE res
    self.Set()
    res = bass.BASS_SampleCreate(length, freq, chans, max, flags)
    bass.__Evaluate()
    return BASSSAMPLE(res)

  cpdef CreateMusicFromBytes(BASSDEVICE self, const unsigned char[:] data, DWORD flags = 0, QWORD length = 0, bint device_frequency = True):
    return BASSMUSIC.FromBytes(data, flags, length, device_frequency, self)

  cpdef CreateMusicFromFile(BASSDEVICE self, object filename, DWORD flags = 0, QWORD offset = 0, bint device_frequency = True):
    return BASSMUSIC.FromFile(filename, flags, offset, device_frequency, self)

  IF UNAME_SYSNAME == "Windows":
    cpdef EAXPreset(BASSDEVICE self, int preset):
      cdef int env
      cdef float vol, decay, damp
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
    def __get__(BASSDEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      return info.name.decode('utf-8')

  property Driver:
    def __get__(BASSDEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      return info.driver

  property Status:
    def __get__(BASSDEVICE self):
      cdef BASS_DEVICEINFO info
      info = self.__getdeviceinfo()
      bass.__Evaluate()
      return info.flags

  property Flags:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.flags

  property Memory:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.hwsize

  property MemoryFree:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info= self.__getinfo()
      self.__EvaluateSelected()
      return info.hwfree

  property FreeSamples:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.freesam

  property Free3D:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.free3d

  property MinimumRate:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.minrate

  property MaximumRate:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.maxrate

  property EAX:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.eax

  property DirectX:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.dsver

  property Buffer:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.minbuf

  property Latency:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.latency

  property InitFlags:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.initflags

  property Speakers:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.speakers

  property Frequency:
    def __get__(BASSDEVICE self):
      cdef BASS_INFO info
      self.Set()
      info = self.__getinfo()
      self.__EvaluateSelected()
      return info.freq

  property Volume:
    def __get__(BASSDEVICE self):
      cdef float volume
      self.Set()
      volume = bass.BASS_GetVolume()
      bass.__Evaluate()
      return volume

    def __set__(BASSDEVICE self, float value):
      cdef bint res
      self.Set()
      res = bass.BASS_SetVolume(value)
      bass.__Evaluate()

  property Position3D:
    def __get__(BASSDEVICE self):
      cdef BASS_3DVECTOR pos
      self.Set()
      bass.BASS_Get3DPosition(&pos, NULL, NULL, NULL)
      bass.__Evaluate()
      return BASSVECTOR_Create(&pos)

    def __set__(BASSDEVICE self, BASSVECTOR value):
      cdef BASS_3DVECTOR pos
      cdef bint res
      self.Set()
      value.Resolve(&pos)
      res = bass.BASS_Set3DPosition(&pos, NULL, NULL, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Velocity3D:
    def __get__(BASSDEVICE self):
      cdef BASS_3DVECTOR vel
      self.Set()
      bass.BASS_Get3DPosition(NULL, &vel, NULL, NULL)
      bass.__Evaluate()
      return BASSVECTOR_Create(&vel)
    def __set__(BASSDEVICE self,BASSVECTOR value):
      cdef BASS_3DVECTOR vel
      cdef bint res
      self.Set()
      value.Resolve(&vel)
      res = bass.BASS_Set3DPosition(NULL, &vel, NULL, NULL)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Front3D:
    def __get__(BASSDEVICE self):
      cdef BASS_3DVECTOR front, top
      self.Set()
      bass.BASS_Get3DPosition(NULL, NULL, &front, &top)
      bass.__Evaluate()
      return BASSVECTOR_Create(&front)
    def __set__(BASSDEVICE self, BASSVECTOR value):
      cdef BASS_3DVECTOR front, top
      cdef bint res
      self.Set()
      bass.BASS_Get3DPosition(NULL, NULL, &front, &top)
      value.Resolve(&front)
      res = bass.BASS_Set3DPosition(NULL, NULL, &front, &top)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Top3D:
    def __get__(BASSDEVICE self):
      cdef BASS_3DVECTOR front, top
      self.Set()
      bass.BASS_Get3DPosition(NULL, NULL, &front, &top)
      bass.__Evaluate()
      return BASSVECTOR_Create(&top)

    def __set__(BASSDEVICE self,BASSVECTOR value):
      cdef BASS_3DVECTOR front, top
      cdef bint res
      self.Set()
      bass.BASS_Get3DPosition(NULL, NULL, &front, &top)
      value.Resolve(&top)
      res = bass.BASS_Set3DPosition(NULL, NULL, &front, &top)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Distance:
    def __get__(BASSDEVICE self):
      cdef float distf
      self.Set()
      bass.BASS_Get3DFactors(&distf, NULL, NULL)
      bass.__Evaluate()
      return distf

    def __set__(BASSDEVICE self, float value):
      self.Set()
      bass.BASS_Set3DFactors(value,-1.0,-1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Rolloff:
    def __get__(BASSDEVICE self):
      cdef float rollf
      self.Set()
      bass.BASS_Get3DFactors(NULL, &rollf, NULL)
      bass.__Evaluate()
      return rollf

    def __set__(BASSDEVICE self,float value):
      self.Set()
      bass.BASS_Set3DFactors(-1.0, value, -1.0)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  property Doppler:
    def __get__(BASSDEVICE self):
      cdef float doppf
      self.Set()
      bass.BASS_Get3DFactors(NULL, NULL, &doppf)
      bass.__Evaluate()
      return doppf

    def __set__(BASSDEVICE self,float value):
      self.Set()
      bass.BASS_Set3DFactors(-1.0, -1.0, value)
      bass.__Evaluate()
      bass.BASS_Apply3D()

  IF UNAME_SYSNAME == "Windows":
    property EAXEnvironment:
      def __get__(BASSDEVICE self):
        cdef DWORD env
        self.Set()
        bass.BASS_GetEAXParameters(&env, NULL, NULL, NULL)
        bass.__Evaluate()
        return <int>env

      def __set__(BASSDEVICE self, int value):
        self.Set()
        bass.BASS_SetEAXParameters(value, -1.0, -1.0, -1.0)
        bass.__Evaluate()

    property EAXVolume:
      def __get__(BASSDEVICE self):
        cdef float vol
        self.Set()
        bass.BASS_GetEAXParameters(NULL, &vol, NULL, NULL)
        bass.__Evaluate()
        return vol

      def __set__(BASSDEVICE self, float value):
        self.Set()
        bass.BASS_SetEAXParameters(-1, value, -1.0, -1.0)
        bass.__Evaluate()

    property EAXDecay:
      def __get__(BASSDEVICE self):
        cdef float decay
        self.Set()
        bass.BASS_GetEAXParameters(NULL, NULL, &decay, NULL)
        bass.__Evaluate()
        return decay

      def __set__(BASSDEVICE self, float value):
        self.Set()
        bass.BASS_SetEAXParameters(-1, -1.0, value, -1.0)
        bass.__Evaluate()

    property EAXDamping:
      def __get__(BASSDEVICE self):
        cdef float damp
        self.Set()
        bass.BASS_GetEAXParameters(NULL, NULL, NULL, &damp)
        bass.__Evaluate()
        return damp

      def __set__(BASSDEVICE self, float value):
        self.Set()
        bass.BASS_SetEAXParameters(-1, -1.0, -1.0, value)
        bass.__Evaluate()
