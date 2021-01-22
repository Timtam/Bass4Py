from ...fx import FX

class I3DL2Reverb(FX):

  @property
  def room(self) -> int: ...

  @room.setter
  def room(self, value: int) -> None: ...

  @property
  def room_hf(self) -> int: ...

  @room_hf.setter
  def room_hf(self, value: int) -> None: ...

  @property
  def room_rolloff_factor(self) -> float: ...

  @room_rolloff_factor.setter
  def room_rolloff_factor(self, value: float) -> None: ...

  @property
  def decay_time(self) -> float: ...

  @decay_time.setter
  def decay_time(self, value: float) -> None: ...

  @property
  def decay_hf_ratio(self) -> float: ...

  @decay_hf_ratio.setter
  def decay_hf_ratio(self, value: float) -> None: ...

  @property
  def reflections(self) -> int: ...

  @reflections.setter
  def reflections(self, value: int) -> None: ...

  @property
  def reflections_delay(self) -> float: ...

  @reflections_delay.setter
  def reflections_delay(self, value: float) -> None: ...

  @property
  def reverb(self) -> int: ...

  @reverb.setter
  def reverb(self, value: int) -> None: ...

  @property
  def reverb_delay(self) -> float: ...

  @reverb_delay.setter
  def reverb_delay(self, value: float) -> None: ...

  @property
  def diffusion(self) -> float: ...

  @diffusion.setter
  def diffusion(self, value: float) -> None: ...

  @property
  def density(self) -> float: ...

  @density.setter
  def density(self, value: float) -> None: ...

  @property
  def hf_reference(self) -> float: ...

  @hf_reference.setter
  def hf_reference(self, value: float) -> None: ...
