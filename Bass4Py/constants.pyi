from enum import IntFlag, IntEnum

class STARTED(IntFlag):
  NOT_STARTED: int
  ACTIVE: int
  INACTIVE: int

class DEVICE(IntFlag):
  NONE: int
  EIGHT_BITS: int
  MONO: int
  STEREO: int
  LATENCY: int
  CPSPEAKERS: int
  SPEAKERS: int
  NOSPEAKER: int
  DMIX: int
  FREQ: int
  DSOUND: int
  REINIT: int

class DEVICE_TYPE(IntFlag):
  NETWORK: int
  SPEAKERS: int
  LINE: int
  HEADPHONES: int
  MICROPHONE: int
  HEADSET: int
  HANDSET: int
  DIGITAL: int
  SPDIF: int
  HDMI: int
  DISPLAYPORT: int

class SAMPLE(IntFlag):
  EIGHT_BITS: int
  FLOAT: int
  MONO: int
  LOOP: int
  THREE_D: int
  SOFTWARE: int
  MUTEMAX: int
  VAM: int
  FX: int
  OVER_VOL: int
  OVER_POS: int
  OVER_DIST: int

class MP3(IntFlag):
  MP3_IGNOREDELAY: int
  MP3_SETPOS: int

class STREAM(IntFlag):
  EIGHT_BITS: int
  FLOAT: int
  MONO: int
  LOOP: int
  THREE_D: int
  SOFTWARE: int
  MUTEMAX: int
  VAM: int
  FX: int
  PRESCAN: int
  AUTOFREE: int
  RESTRATE: int
  BLOCK: int
  DECODE: int
  STATUS: int
  ASYNCFILE: int

class MUSIC(IntFlag):
  FLOAT: int
  MONO: int
  LOOP: int
  THREE_D: int
  FX: int
  AUTOFREE: int
  DECODE: int
  PRESCAN: int
  RAMP: int
  RAMPS: int
  SURROUND: int
  SURROUND2: int
  FT2MOD: int
  PT1MOD: int
  NONINTER: int
  SINCINTER: int
  POSRESET: int
  POSRESETEX: int
  STOPBACK: int
  NOSAMPLE: int

class CHANNEL_TYPE(IntFlag):
  SAMPLE: int
  RECORD: int
  STREAM: int
  STREAM_VORBIS: int
  STREAM_MP1: int
  STREAM_MP2: int
  STREAM_MP3: int
  STREAM_AIFF: int
  STREAM_CA: int
  STREAM_MF: int
  STREAM_WAV: int
  STREAM_WAV_PCM: int
  STREAM_WAV_FLOAT: int
  STREAM_SAMPLE: int
  MUSIC_MOD: int
  MUSIC_MTM: int
  MUSIC_S3M: int
  MUSIC_XM: int
  MUSIC_IT: int
  MUSIC_MO3: int

class ALGORITHM_3D(IntEnum):
  DEFAULT: int
  OFF: int

class STREAMFILE(IntFlag):
  NOBUFFER: int
  BUFFER: int
  BUFFERPUSH: int

class FILE_POSITION(IntFlag):
  CURRENT: int
  DECODE: int
  DOWNLOAD: int
  END: int
  START: int
  CONNECTED: int
  BUFFER: int
  SOCKET: int
  ASYNCBUF: int
  SIZE: int
  BUFFERING: int

class ACTIVE(IntEnum):
  STOPPED: int
  PLAYING: int
  STALLED: int
  PAUSED: int
  PAUSED_DEVICE: int

class INPUT_TYPE(IntFlag):
  UNDEF: int
  DIGITAL: int
  LINE: int
  MIC: int
  SYNTH: int
  CD: int
  PHONE: int
  SPEAKER: int
  WAVE: int
  AUX: int
  ANALOG: int

class POSITION(IntEnum):
  BYTE: int
  LOOP: int
  MUSIC_ORDER: int
  OGG: int
  END: int

class DATA(IntEnum):
  SRC: int
  FIXED: int
  FLOAT: int
