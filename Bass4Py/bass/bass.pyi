from typing import Union

from .._evaluable import _Evaluable
from .plugin import Plugin
from .version import Version

class BASS(_Evaluable):

  def __init__(self) -> None: ...
  def load_plugin(self, filename: Union[str, bytes]) -> Plugin: ...
  def update(self, int length) -> bool: ...
  
  @property
  def version(self) -> Version: ...
  
  @property
  def api_version(self) -> Version: ...
