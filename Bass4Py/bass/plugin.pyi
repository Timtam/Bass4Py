from .version import Version
from .._evaluable import _Evaluable

class Plugin(_Evaluable):

  def __init__(self) -> None: ...
  def free(self) -> None: ...
  
  @property
  def version(self) -> Version: ...