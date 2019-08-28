from .constants import ERROR

class BassError(Exception):
  def __init__(self, error):
    self.Error = ERROR(error)

  def __str__(self):
    return 'A library error occured. Please consult the documentation for more information. The error is: ' + str(self.Error)

class BassAPIError(Exception):
  def __str__(self):
    return 'An error occured while executing your last command. Please consult the documentation to get more information.'

class BassLinkError(Exception):
  def __init__(self,error):
    self.error=error
  def __str__(self):
    return "A link error occured: %s"%self.error
    
class BassOutOfRangeError(Exception):
  pass
  
class BassRecordError(Exception):
  pass

class BassSampleError(Exception):
  pass

class BassStreamError(Exception):
  pass

class BassSyncError(Exception):
  pass
  
class BassPlatformError(Exception):
  def __init__(self):
    super(BassPlatformError, self).__init__("This feature is not available for this operating system.")
