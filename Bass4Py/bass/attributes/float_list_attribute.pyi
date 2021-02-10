from typing import List, Sequence

from .attribute_base import AttributeBase

class FloatListAttribute(AttributeBase):

  def get(self) -> List[float]: ...
  def set(self, values: Sequence[float]) -> bool: ...
  def slide(self, values: Sequence[float], time: int) -> bool: ...
  