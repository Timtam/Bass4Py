from ..evaluable import Evaluable
from ..constants import INPUT_TYPE

class Input(Evaluable):

  @property
  def name(self) -> str: ...
  
  @property
  def volume(self) -> float: ...
  
  @volume.setter
  def volume(self, value: float) -> None: ...
  
  @property
  def enabled(self) -> bool: ...
  
  @enabled.setter
  def enabled(self, value: bool) -> None: ...
  
  @property
  def type(self) -> INPUT_TYPE: ...
