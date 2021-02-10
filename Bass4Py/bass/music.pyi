from typing import Any, Optional, Union

from .attributes.float_attribute import FloatAttribute
from .attributes.float_list_attribute import FloatListAttribute
from .channel import Channel
from .output_device import OutputDevice

class Music(Channel):

  active_channels: FloatAttribute
  amplification: FloatAttribute
  bpm: FloatAttribute
  channel_volumes: FloatListAttribute
  global_volume: FloatAttribute
  instrument_volumes: FloatListAttribute
  pan_separation: FloatAttribute
  position_scaler: FloatAttribute
  speed: FloatAttribute
  tags: Any
  
  def free(self) -> bool: ...
  def update(self, length: int) -> bool: ...
  
  @staticmethod
  def from_bytes(data: bytes, flags: int = ..., length: int = ..., device_frequency: bool = ..., device: Optional[OutputDevice] = ...) -> Music: ...
  
  @staticmethod
  def from_file(file: Union[str, bytes], flags: int = ..., offset: int = ..., device_frequency: bool = ..., device: Optional[OutputDevice] = ...) -> Music: ...
  
  @property
  def interpolation_none(self) -> bool: ...
  
  @interpolation_none.setter
  def interpolation_none(self, value: bool) -> None: ...
  
  @property
  def interpolation_sinc(self) -> bool: ...
  
  @interpolation_sinc.setter
  def interpolation_sinc(self, value: bool) -> None: ...
  
  @property
  def ramp_normal(self) -> bool: ...
  
  @ramp_normal.setter
  def ramp_normal(self, value: bool) -> None: ...
  
  @property
  def ramp_sensitive(self) -> bool: ...
  
  @ramp_sensitive.setter
  def ramp_sensitive(self, value: bool) -> None: ...
  
  @property
  def surround(self) -> bool: ...
  
  @surround.setter
  def surround(self, value: bool) -> None: ...
  
  @property
  def surround2(self) -> bool: ...
  
  @surround2.setter
  def surround2(self, value: bool) -> None: ...
  
  @property
  def mod_ft2(self) -> bool: ...
  
  @mod_ft2.setter
  def mod_ft2(self, value: bool) -> None: ...
  
  @property
  def mod_pt1(self) -> bool: ...
  
  @mod_pt1.setter
  def mod_pt1(self, value: bool) -> None: ...
  
  @property
  def stop_seeking(self) -> bool: ...
  
  @stop_seeking.setter
  def stop_seeking(self, value: bool) -> None: ...
  
  @property
  def stop_all_seeking(self) -> bool: ...
  
  @stop_all_seeking.setter
  def stop_all_seeking(self, value: bool) -> None: ...
  
  @property
  def stop_backward(self) -> bool: ...
  
  @stop_backward.setter
  def stop_backward(self, value: bool) -> None: ...
