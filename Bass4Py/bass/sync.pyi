from typing import Callable, Optional

from .._evaluable import _Evaluable
from .channel import Channel

class Sync(_Evaluable):

  channel: Channel
  
  def remove(self) -> bool: ...
  def set(self, channel: Channel) -> None: ...
  def set_mix_time(self, enable: bool, threaded: bool = ...) -> bool: ...
  
  @property
  def one_time(self) -> bool: ...
  
  @one_time.setter
  def one_time(self, value: bool) -> None: ...
  
  @property
  def callback(self) -> Optional[Callable[[Sync], None]]: ...
  
  @callback.setter
  def callback(self, value: Callable[[Sync], None]) -> None: ...
