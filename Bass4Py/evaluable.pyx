from .bindings.bass cimport (
  _BASS_ERROR_MEM,
  _BASS_ERROR_FILEOPEN,
  _BASS_ERROR_DRIVER,
  _BASS_ERROR_BUFLOST,
  _BASS_ERROR_HANDLE,
  _BASS_ERROR_FORMAT,
  _BASS_ERROR_POSITION,
  _BASS_ERROR_INIT,
  _BASS_ERROR_START,
  _BASS_ERROR_SSL,
  _BASS_ERROR_ALREADY,
  _BASS_ERROR_NOCHAN,
  _BASS_ERROR_ILLTYPE,
  _BASS_ERROR_ILLPARAM,
  _BASS_ERROR_NO3D,
  _BASS_ERROR_NOEAX,
  _BASS_ERROR_DEVICE,
  _BASS_ERROR_NOPLAY,
  _BASS_ERROR_FREQ,
  _BASS_ERROR_NOTFILE,
  _BASS_ERROR_NOHW,
  _BASS_ERROR_EMPTY,
  _BASS_ERROR_NONET,
  _BASS_ERROR_CREATE,
  _BASS_ERROR_NOFX,
  _BASS_ERROR_NOTAVAIL,
  _BASS_ERROR_DECODE,
  _BASS_ERROR_DX,
  _BASS_ERROR_TIMEOUT,
  _BASS_ERROR_FILEFORM,
  _BASS_ERROR_SPEAKER,
  _BASS_ERROR_VERSION,
  _BASS_ERROR_CODEC,
  _BASS_ERROR_ENDED,
  _BASS_ERROR_BUSY,
  _BASS_ERROR_NOTAUDIO,
  _BASS_ERROR_UNSTREAMABLE,
  _BASS_OK,
  BASS_ErrorGetCode,
  DWORD)

from . import exceptions

cdef class Evaluable:

  @staticmethod
  def _evaluate():
    cdef DWORD error = BASS_ErrorGetCode()

    if error == _BASS_OK:
      return

    if error == _BASS_ERROR_MEM:
      raise exceptions.BassMemoryError()
    elif error == _BASS_ERROR_FILEOPEN:
      raise exceptions.BassFileOpenError()
    elif error == _BASS_ERROR_DRIVER:
      raise exceptions.BassDriverError()
    elif error == _BASS_ERROR_BUFLOST:
      raise exceptions.BassBufferLostError()
    elif error == _BASS_ERROR_HANDLE:
      raise exceptions.BassHandleError()
    elif error == _BASS_ERROR_FORMAT:
      raise exceptions.BassFormatError()
    elif error == _BASS_ERROR_POSITION:
      raise exceptions.BassPositionError()
    elif error == _BASS_ERROR_INIT:
      raise exceptions.BassInitError()
    elif error == _BASS_ERROR_START:
      raise exceptions.BassStartError()
    elif error == _BASS_ERROR_SSL:
      raise exceptions.BassSslError()
    elif error == _BASS_ERROR_ALREADY:
      raise exceptions.BassAlreadyError()
    elif error == _BASS_ERROR_NOCHAN:
      raise exceptions.BassNoChannelError()
    elif error == _BASS_ERROR_ILLTYPE:
      raise exceptions.BassInvalidTypeError()
    elif error == _BASS_ERROR_ILLPARAM:
      raise exceptions.BassInvalidParameterError()
    elif error == _BASS_ERROR_NO3D:
      raise exceptions.BassNo3DError()
    elif error == _BASS_ERROR_NOEAX:
      raise exceptions.BassNoEaxError()
    elif error == _BASS_ERROR_DEVICE:
      raise exceptions.BassDeviceError()
    elif error == _BASS_ERROR_NOPLAY:
      raise exceptions.BassNoPlayError()
    elif error == _BASS_ERROR_FREQ:
      raise exceptions.BassFrequencyError()
    elif error == _BASS_ERROR_NOTFILE:
      raise exceptions.BassNotAFileError()
    elif error == _BASS_ERROR_NOHW:
      raise exceptions.BassNoHardwareError()
    elif error == _BASS_ERROR_EMPTY:
      raise exceptions.BassEmptyError()
    elif error == _BASS_ERROR_NONET:
      raise exceptions.BassNoNetworkError()
    elif error == _BASS_ERROR_CREATE:
      raise exceptions.BassCreateError()
    elif error == _BASS_ERROR_NOFX:
      raise exceptions.BassNoFXError()
    elif error == _BASS_ERROR_NOTAVAIL:
      raise exceptions.BassNotAvailableError()
    elif error == _BASS_ERROR_DECODE:
      raise exceptions.BassDecodeError()
    elif error == _BASS_ERROR_DX:
      raise exceptions.BassDxError()
    elif error == _BASS_ERROR_TIMEOUT:
      raise exceptions.BassTimeoutError()
    elif error == _BASS_ERROR_FILEFORM:
      raise exceptions.BassFileFormatError()
    elif error == _BASS_ERROR_SPEAKER:
      raise exceptions.BassSpeakerError()
    elif error == _BASS_ERROR_VERSION:
      raise exceptions.BassVersionError()
    elif error == _BASS_ERROR_CODEC:
      raise exceptions.BassCodecError()
    elif error == _BASS_ERROR_ENDED:
      raise exceptions.BassEndedError()
    elif error == _BASS_ERROR_BUSY:
      raise exceptions.BassBusyError()
    elif error == _BASS_ERROR_NOTAUDIO:
      raise exceptions.BassNotAudioError()
    elif error == _BASS_ERROR_UNSTREAMABLE:
      raise exceptions.BassUnstreamableError()
    else:
      raise exceptions.BassUnknownError()

