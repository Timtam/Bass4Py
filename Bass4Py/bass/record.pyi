from typing import Callable, Optional

from .channel_base import ChannelBase
from .input_device import InputDevice

class Record(ChannelBase):

  def start(self) -> bool: ...

  @staticmethod
  def from_device(device: InputDevice, freq: int = ..., chans: int = ..., flags: int = ..., callback: Optional[Callable[[Record, bytes], bool]] = ..., period: int = ...) -> Record: ...
  
  @property
  def device(self) -> Optional[InputDevice]: ...
  
  @device.setter
  def device(self, value: Optional[InputDevice]) -> None: ...
