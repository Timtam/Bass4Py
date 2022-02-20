from ..bindings.bass cimport (
  HCHANNEL,
  BASS_CHANNELINFO,
  DWORD,
  QWORD,
  WORD,
  LOWORD,
  HIWORD,
  BASS_3DVECTOR)

from .attributes.bool_attribute cimport BoolAttribute
from .attributes.float_attribute cimport FloatAttribute
from .channel_base cimport ChannelBase
from .dsp cimport DSP
from .fx cimport FX
from .output_device cimport OutputDevice
from .sync cimport Sync

cdef class Channel(ChannelBase):
  cdef OutputDevice _device

  # attributes
  cdef readonly FloatAttribute buffer
  cdef readonly FloatAttribute cpu
  cdef readonly BoolAttribute no_ramping
  cdef readonly FloatAttribute tail

  cdef DWORD _get_flags(Channel self)
  cpdef _set_flags(Channel self, DWORD flag, bint switch)
  cpdef get_tags(Channel self, DWORD tagtype)
  cpdef link(Channel self, Channel obj)
  cpdef play(Channel self, bint restart)
  cpdef reset_fx(Channel self)
  cpdef set_dsp(Channel self, DSP dsp)
  cpdef set_fx(Channel self, FX fx)
  cpdef set_position(Channel self, object pos, DWORD mode=?, bint decodeto=?, bint flush=?, bint inexact=?, bint relative=?, bint reset=?, bint scan=?, bint posreset=?, bint posresetex=?)
  cpdef set_sync(Channel self, Sync sync)
  cpdef unlink(Channel self, Channel obj)
