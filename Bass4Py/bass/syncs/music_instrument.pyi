from ..sync import Sync

class MusicInstrument(Sync): 

  @property
  def instrument(self) -> int: ...
  
  @instrument.setter
  def instrument(self, value: int) -> None: ...
  
  @property
  def note(self) -> int: ...
  
  @note.setter
  def note(self, value: int) -> None: ...
