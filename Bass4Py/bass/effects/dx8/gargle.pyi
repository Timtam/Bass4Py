from ...fx import FX

class Gargle(FX):

  @property
  def rate_hz(self) -> int: ...

  @rate_hz.setter
  def rate_hz(self, value: int) -> None: ...

  @property
  def wave_shape(self) -> int: ...

  @wave_shape.setter
  def wave_shape(self, value: int) -> None: ...
