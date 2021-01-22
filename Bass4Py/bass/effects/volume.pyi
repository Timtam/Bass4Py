from ..fx import FX

class Volume(FX):

  @property
  def target(self) -> float: ...

  @target.setter
  def target(self, value: float) -> None: ...

  @property
  def current(self) -> float: ...

  @current.setter
  def current(self, value: float) -> None: ...

  @property
  def time(self) -> float: ...

  @time.setter
  def time(self, value: float) -> None: ...

  @property
  def curve(self) -> int: ...

  @curve.setter
  def curve(self, value: int) -> None: ...
