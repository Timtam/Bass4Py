class BassError(Exception):
  def __init__(self,error):
    self.error=error
  def __str__(self):
    return 'A library error occured. Please consult the documentation for more information. The error-code is: %d'%self.error

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
  
class BassStreamError(Exception):
  pass

class BassSyncError(Exception):
  pass