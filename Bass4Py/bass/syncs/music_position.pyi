from ..sync import Sync

class MusicPosition(Sync): 

  @property
  def order(self) -> int: ...
  
  @order.setter
  def order(self, value: int) -> None: ...
  
  @property
  def row(self) -> int: ...
  
  @row.setter
  def row(self, value: int) -> None: ...
