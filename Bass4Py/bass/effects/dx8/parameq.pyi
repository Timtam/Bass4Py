from ...fx import FX

class Parameq(FX):

  @property
  def center(self) -> float: ...

  @center.setter
  def center(self, value: float) -> None: ...

  @property
  def bandwidth(self) -> float: ...

  @bandwidth.setter
  def bandwidth(self, value: float) -> None: ...

  @property
  def gain(self) -> float: ...

  @gain.setter
  def gain(self, value: float) -> None: ...
