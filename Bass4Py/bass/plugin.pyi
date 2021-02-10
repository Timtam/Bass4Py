from .version import Version
from ..evaluable import Evaluable

class Plugin(Evaluable):

  def __init__(self) -> None: ...
  def free(self) -> None: ...
  
  @property
  def version(self) -> Version: ...