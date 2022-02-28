class BassAlreadyError(Exception):
  pass

class BassAPIError(Exception):
  def __str__(self):
    return 'An error occured while executing your last command. Please consult the documentation to get more information.'

class BassAttributeError(Exception):
  pass

class BassBufferLostError(Exception):
  pass

class BassBusyError(Exception):
  pass

class BassCodecError(Exception):
  pass

class BassCreateError(Exception):
  pass

class BassDecodeError(Exception):
  pass

class BassDeviceError(Exception):
  pass

class BassDriverError(Exception):
  pass

class BassDxError(Exception):
  pass

class BassEmptyError(Exception):
  pass

class BassEndedError(Exception):
  pass

class BassFileFormatError(Exception):
  pass

class BassFileOpenError(Exception):
  pass

class BassFormatError(Exception):
  pass

class BassFrequencyError(Exception):
  pass

class BassHandleError(Exception):
  pass

class BassInitError(Exception):
  pass

class BassInvalidParameterError(Exception):
  pass

class BassInvalidTypeError(Exception):
  pass

class BassLinkError(Exception):
  def __init__(self,error):
    self.error=error
  def __str__(self):
    return "A link error occured: %s"%self.error
    
class BassMemoryError(Exception):
  pass

class BassNo3DError(Exception):
  pass

class BassNoChannelError(Exception):
  pass

class BassNoEaxError(Exception):
  pass

class BassNoFXError(Exception):
  pass

class BassNoHardwareError(Exception):
  pass

class BassNoNetworkError(Exception):
  pass

class BassNoPlayError(Exception):
  pass

class BassNotAFileError(Exception):
  pass

class BassNotAudioError(Exception):
  pass

class BassNotAvailableError(Exception):
  pass

class BassOutOfRangeError(Exception):
  pass
  
class BassPlatformError(Exception):
  def __init__(self):
    super(BassPlatformError, self).__init__("This feature is not available for this operating system.")

class BassPositionError(Exception):
  pass

class BassRecordError(Exception):
  pass

class BassSampleError(Exception):
  pass

class BassSpeakerError(Exception):
  pass

class BassSslError(Exception):
  pass

class BassStartError(Exception):
  pass

class BassStreamError(Exception):
  pass

class BassSyncError(Exception):
  pass
  
class BassTimeoutError(Exception):
  pass

class BassUnknownError(Exception):
  pass

class BassUnstreamableError(Exception):
  pass

class BassVersionError(Exception):
  pass
