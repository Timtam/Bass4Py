from ..sync import Sync

class Position(Sync): 

  @property
  def position(self) -> int: ...
  
  @position.setter
  def position(self, value: int) -> None: ...
