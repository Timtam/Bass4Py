from ...evaluable import Evaluable

class AttributeBase(Evaluable):

  def __init__(self, channel: int, attribute: int, readonly: bool = ..., not_available: bool = ...) -> None: ...
  
  @property
  def sliding(self) -> bool: ...
