from ...fx import FX

class Reverb(FX):

  @property
  def in_gain(self) -> float: ...
  
  @in_gain.setter
  def in_gain(self, value: float) -> None: ...

  @property
  def reverb_mix(self) -> float: ...
  
  @reverb_mix.setter
  def reverb_mix(self, value: float) -> None: ...

  @property
  def reverb_time(self) -> float: ...
  
  @reverb_time.setter
  def reverb_time(self, value: float) -> None: ...

  @property
  def high_freq_rt_ratio(self) -> float: ...
  
  @high_freq_rt_ratio.setter
  def high_freq_rt_ratio(self, value: float) -> None: ...
