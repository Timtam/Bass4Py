from typing import List, Sequence

from ._attribute_base import _AttributeBase

class FloatListAttribute(_AttributeBase):

  def get(self) -> List[float]: ...
  def set(self, values: Sequence[float]) -> bool: ...
  def slide(self, values: Sequence[float], time: int) -> bool: ...
  