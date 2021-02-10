from ..._evaluable import _Evaluable

class _AttributeBase(_Evaluable):

  def __init__(self, channel: int, attribute: int, readonly: bool = ..., not_available: bool = ...) -> None: ...
  
  @property
  def sliding(self) -> bool: ...
