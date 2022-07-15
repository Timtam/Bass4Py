from typing import Optional

from ..evaluable import Evaluable
from .channel import Channel

class FX(Evaluable):

  channel: Optional[Channel]
  
  def remove(self) -> bool: ...
  def reset(self) -> bool: ...
  def set(self, channel: Channel) -> None: ...
  def update(self) -> None: ...
  
  @property
  def priority(self) -> int: ...
  
  @priority.setter
  def priority(self, value: int) -> None: ...