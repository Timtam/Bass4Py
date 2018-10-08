ctypedef unsigned long DWORD
ctypedef void* HWND
ctypedef unsigned long long QWORD
ctypedef short BYTE
ctypedef unsigned int WORD
ctypedef DWORD HMUSIC
ctypedef DWORD HSAMPLE
ctypedef DWORD HCHANNEL
ctypedef DWORD HSTREAM
ctypedef DWORD HRECORD
ctypedef DWORD HSYNC
ctypedef DWORD HDSP
ctypedef DWORD HFX
ctypedef DWORD HPLUGIN

ctypedef fused Numeric:
  DWORD
  QWORD
  BYTE
  WORD
  int
  long
  long long

cpdef enum:
  BASS_OK=0
  BASS_ERROR_MEM=1
  BASS_ERROR_FILEOPEN=2
  BASS_ERROR_DRIVER=3
  BASS_ERROR_BUFLOST=4
  BASS_ERROR_HANDLE=5
  BASS_ERROR_FORMAT=6
  BASS_ERROR_POSITION=7
  BASS_ERROR_INIT=8
  BASS_ERROR_START=9
  BASS_ERROR_SSL=10
  BASS_ERROR_ALREADY=14
  BASS_ERROR_NOCHAN=18
  BASS_ERROR_ILLTYPE=19
  BASS_ERROR_ILLPARAM=20
  BASS_ERROR_NO3D=21
  BASS_ERROR_NOEAX=22
  BASS_ERROR_DEVICE=23
  BASS_ERROR_NOPLAY=24
  BASS_ERROR_FREQ=25
  BASS_ERROR_NOTFILE=27
  BASS_ERROR_NOHW=29
  BASS_ERROR_EMPTY=31
  BASS_ERROR_NONET=32
  BASS_ERROR_CREATE=33
  BASS_ERROR_NOFX=34
  BASS_ERROR_NOTAVAIL=37
  BASS_ERROR_DECODE=38
  BASS_ERROR_DX=39
  BASS_ERROR_TIMEOUT=40
  BASS_ERROR_FILEFORM=41
  BASS_ERROR_SPEAKER=42
  BASS_ERROR_VERSION=43
  BASS_ERROR_CODEC=44
  BASS_ERROR_ENDED=45
  BASS_ERROR_BUSY=46
  BASS_ERROR_UNKNOWN=-1

cpdef enum:
  BASS_CONFIG_BUFFER=0
  BASS_CONFIG_UPDATEPERIOD=1
  BASS_CONFIG_GVOL_SAMPLE=4
  BASS_CONFIG_GVOL_STREAM=5
  BASS_CONFIG_GVOL_MUSIC=6
  BASS_CONFIG_CURVE_VOL=7
  BASS_CONFIG_CURVE_PAN=8
  BASS_CONFIG_FLOATDSP=9
  BASS_CONFIG_3DALGORITHM=10
  BASS_CONFIG_NET_TIMEOUT=11
  BASS_CONFIG_NET_BUFFER=12
  BASS_CONFIG_PAUSE_NOPLAY=13
  BASS_CONFIG_NET_PREBUF=15
  BASS_CONFIG_NET_PASSIVE=18
  BASS_CONFIG_REC_BUFFER=19
  BASS_CONFIG_NET_PLAYLIST=21
  BASS_CONFIG_MUSIC_VIRTUAL=22
  BASS_CONFIG_VERIFY=23
  BASS_CONFIG_UPDATETHREADS=24
  BASS_CONFIG_DEV_BUFFER=27
  BASS_CONFIG_VISTA_TRUEPOS=30
  BASS_CONFIG_IOS_MIXAUDIO=34
  BASS_CONFIG_DEV_DEFAULT=36
  BASS_CONFIG_NET_READTIMEOUT=37
  BASS_CONFIG_VISTA_SPEAKERS=38
  BASS_CONFIG_IOS_SPEAKER=39
  BASS_CONFIG_MF_DISABLE=40
  BASS_CONFIG_HANDLES=41
  BASS_CONFIG_UNICODE=42
  BASS_CONFIG_SRC=43
  BASS_CONFIG_SRC_SAMPLE=44
  BASS_CONFIG_ASYNCFILE_BUFFER=45
  BASS_CONFIG_OGG_PRESCAN=47
  BASS_CONFIG_MF_VIDEO=48
  BASS_CONFIG_AIRPLAY=49
  BASS_CONFIG_DEV_NONSTOP=50
  BASS_CONFIG_IOS_NOCATEGORY=51
  BASS_CONFIG_VERIFY_NET=52

cpdef enum:
  BASS_CONFIG_NET_AGENT=16
  BASS_CONFIG_NET_PROXY=17
  BASS_CONFIG_IOS_NOTIFY=46

cpdef enum:
  BASS_DEVICE_8BITS=1
  BASS_DEVICE_MONO=2
  BASS_DEVICE_3D=4
  BASS_DEVICE_LATENCY=0x100
  BASS_DEVICE_CPSPEAKERS=0x400
  BASS_DEVICE_SPEAKERS=0x800
  BASS_DEVICE_NOSPEAKER=0x1000
  BASS_DEVICE_DMIX=0x2000
  BASS_DEVICE_FREQ=0x4000

cpdef enum:
  BASS_OBJECT_DS=1
  BASS_OBJECT_DS3DL=2

cpdef enum:
  BASS_DEVICE_ENABLED=1
  BASS_DEVICE_DEFAULT=2
  BASS_DEVICE_INIT=4
  BASS_DEVICE_TYPE_MASK=0xff000000
  BASS_DEVICE_TYPE_NETWORK=0x01000000
  BASS_DEVICE_TYPE_SPEAKERS=0x02000000
  BASS_DEVICE_TYPE_LINE=0x03000000
  BASS_DEVICE_TYPE_HEADPHONES=0x04000000
  BASS_DEVICE_TYPE_MICROPHONE=0x05000000
  BASS_DEVICE_TYPE_HEADSET=0x06000000
  BASS_DEVICE_TYPE_HANDSET=0x07000000
  BASS_DEVICE_TYPE_DIGITAL=0x08000000
  BASS_DEVICE_TYPE_SPDIF=0x09000000
  BASS_DEVICE_TYPE_HDMI=0x0a000000
  BASS_DEVICE_TYPE_DISPLAYPORT=0x40000000
  BASS_DEVICES_AIRPLAY=0x1000000

cpdef enum:
  DSCAPS_CONTINUOUSRATE=0x00000010
  DSCAPS_EMULDRIVER=0x00000020
  DSCAPS_CERTIFIED=0x00000040
  DSCAPS_SECONDARYMONO=0x00000100
  DSCAPS_SECONDARYSTEREO=0x00000200
  DSCAPS_SECONDARY8BIT=0x00000400
  DSCAPS_SECONDARY16BIT=0x00000800

cpdef enum:
  DSCCAPS_EMULDRIVER=DSCAPS_EMULDRIVER
  DSCCAPS_CERTIFIED=DSCAPS_CERTIFIED

cpdef enum:
  WAVE_FORMAT_1M08=0x00000001
  WAVE_FORMAT_1S08=0x00000002
  WAVE_FORMAT_1M16=0x00000004
  WAVE_FORMAT_1S16=0x00000008
  WAVE_FORMAT_2M08=0x00000010
  WAVE_FORMAT_2S08=0x00000020
  WAVE_FORMAT_2M16=0x00000040
  WAVE_FORMAT_2S16=0x00000080
  WAVE_FORMAT_4M08=0x00000100
  WAVE_FORMAT_4S08=0x00000200
  WAVE_FORMAT_4M16=0x00000400
  WAVE_FORMAT_4S16=0x00000800

cpdef enum:
  BASS_SAMPLE_8BITS=1
  BASS_SAMPLE_FLOAT=256
  BASS_SAMPLE_MONO=2
  BASS_SAMPLE_LOOP=4
  BASS_SAMPLE_3D=8
  BASS_SAMPLE_SOFTWARE=16
  BASS_SAMPLE_MUTEMAX=32
  BASS_SAMPLE_VAM=64
  BASS_SAMPLE_FX=128
  BASS_SAMPLE_OVER_VOL=0x10000
  BASS_SAMPLE_OVER_POS=0x20000
  BASS_SAMPLE_OVER_DIST=0x30000

cpdef enum:
  BASS_STREAM_PRESCAN=0x20000
  BASS_MP3_SETPOS=BASS_STREAM_PRESCAN
  BASS_STREAM_AUTOFREE=0x40000
  BASS_STREAM_RESTRATE=0x80000
  BASS_STREAM_BLOCK=0x100000
  BASS_STREAM_DECODE=0x200000
  BASS_STREAM_STATUS=0x800000

cpdef enum:
  BASS_MUSIC_FLOAT=BASS_SAMPLE_FLOAT
  BASS_MUSIC_MONO=BASS_SAMPLE_MONO
  BASS_MUSIC_LOOP=BASS_SAMPLE_LOOP
  BASS_MUSIC_3D=BASS_SAMPLE_3D
  BASS_MUSIC_FX=BASS_SAMPLE_FX
  BASS_MUSIC_AUTOFREE=BASS_STREAM_AUTOFREE
  BASS_MUSIC_DECODE=BASS_STREAM_DECODE
  BASS_MUSIC_PRESCAN=BASS_STREAM_PRESCAN
  BASS_MUSIC_CALCLEN=BASS_MUSIC_PRESCAN
  BASS_MUSIC_RAMP=0x200
  BASS_MUSIC_RAMPS=0x400
  BASS_MUSIC_SURROUND=0x800
  BASS_MUSIC_SURROUND2=0x1000
  BASS_MUSIC_FT2MOD=0x2000
  BASS_MUSIC_PT1MOD=0x4000
  BASS_MUSIC_NONINTER=0x10000
  BASS_MUSIC_SINCINTER=0x800000
  BASS_MUSIC_POSRESET=0x8000
  BASS_MUSIC_POSRESETEX=0x400000
  BASS_MUSIC_STOPBACK=0x80000
  BASS_MUSIC_NOSAMPLE=0x100000

cpdef enum:
  BASS_SPEAKER_FRONT=0x1000000
  BASS_SPEAKER_REAR=0x2000000
  BASS_SPEAKER_CENLFE=0x3000000
  BASS_SPEAKER_REAR2=0x4000000
  BASS_SPEAKER_LEFT=0x10000000
  BASS_SPEAKER_RIGHT=0x20000000
  BASS_SPEAKER_FRONTLEFT=BASS_SPEAKER_FRONT|BASS_SPEAKER_LEFT
  BASS_SPEAKER_FRONTRIGHT=BASS_SPEAKER_FRONT|BASS_SPEAKER_RIGHT
  BASS_SPEAKER_REARLEFT=BASS_SPEAKER_REAR|BASS_SPEAKER_LEFT
  BASS_SPEAKER_REARRIGHT=BASS_SPEAKER_REAR|BASS_SPEAKER_RIGHT
  BASS_SPEAKER_CENTER=BASS_SPEAKER_CENLFE|BASS_SPEAKER_LEFT
  BASS_SPEAKER_LFE=BASS_SPEAKER_CENLFE|BASS_SPEAKER_RIGHT
  BASS_SPEAKER_REAR2LEFT=BASS_SPEAKER_REAR2|BASS_SPEAKER_LEFT
  BASS_SPEAKER_REAR2RIGHT=BASS_SPEAKER_REAR2|BASS_SPEAKER_RIGHT

cpdef enum:
  BASS_ASYNCFILE=0x40000000
  BASS_UNICODE=0x80000000

cpdef enum:
  BASS_RECORD_PAUSE=0x8000
  BASS_RECORD_ECHOCANCEL=0x2000
  BASS_RECORD_AGC=0x4000

cpdef enum:
  BASS_VAM_HARDWARE=1
  BASS_VAM_SOFTWARE=2
  BASS_VAM_TERM_TIME=4
  BASS_VAM_TERM_DIST=8
  BASS_VAM_TERM_PRIO=16

cpdef enum:
  BASS_CTYPE_SAMPLE=1
  BASS_CTYPE_RECORD=2
  BASS_CTYPE_STREAM=0x10000
  BASS_CTYPE_STREAM_OGG=0x10002
  BASS_CTYPE_STREAM_MP1=0x10003
  BASS_CTYPE_STREAM_MP2=0x10004
  BASS_CTYPE_STREAM_MP3=0x10005
  BASS_CTYPE_STREAM_AIFF=0x10006
  BASS_CTYPE_STREAM_CA=0x10007
  BASS_CTYPE_STREAM_MF=0x10008
  BASS_CTYPE_STREAM_WAV=0x40000
  BASS_CTYPE_STREAM_WAV_PCM=0x50001
  BASS_CTYPE_STREAM_WAV_FLOAT=0x50003
  BASS_CTYPE_MUSIC_MOD=0x20000
  BASS_CTYPE_MUSIC_MTM=0x20001
  BASS_CTYPE_MUSIC_S3M=0x20002
  BASS_CTYPE_MUSIC_XM=0x20003
  BASS_CTYPE_MUSIC_IT=0x20004
  BASS_CTYPE_MUSIC_MO3=0x00100

cpdef enum:
  BASS_3DMODE_NORMAL=0
  BASS_3DMODE_RELATIVE=1
  BASS_3DMODE_OFF=2

cpdef enum:
  BASS_3DALG_DEFAULT=0
  BASS_3DALG_OFF=1
  BASS_3DALG_FULL=2
  BASS_3DALG_LIGHT=3

cpdef enum:
  EAX_ENVIRONMENT_GENERIC
  EAX_ENVIRONMENT_PADDEDCELL
  EAX_ENVIRONMENT_ROOM
  EAX_ENVIRONMENT_BATHROOM
  EAX_ENVIRONMENT_LIVINGROOM
  EAX_ENVIRONMENT_STONEROOM
  EAX_ENVIRONMENT_AUDITORIUM
  EAX_ENVIRONMENT_CONCERTHALL
  EAX_ENVIRONMENT_CAVE
  EAX_ENVIRONMENT_ARENA
  EAX_ENVIRONMENT_HANGAR
  EAX_ENVIRONMENT_CARPETEDHALLWAY
  EAX_ENVIRONMENT_HALLWAY
  EAX_ENVIRONMENT_STONECORRIDOR
  EAX_ENVIRONMENT_ALLEY
  EAX_ENVIRONMENT_FOREST
  EAX_ENVIRONMENT_CITY
  EAX_ENVIRONMENT_MOUNTAINS
  EAX_ENVIRONMENT_QUARRY
  EAX_ENVIRONMENT_PLAIN
  EAX_ENVIRONMENT_PARKINGLOT
  EAX_ENVIRONMENT_SEWERPIPE
  EAX_ENVIRONMENT_UNDERWATER
  EAX_ENVIRONMENT_DRUGGED
  EAX_ENVIRONMENT_DIZZY
  EAX_ENVIRONMENT_PSYCHOTIC
  EAX_ENVIRONMENT_COUNT

cpdef enum:
  EAX_PRESET_GENERIC
  EAX_PRESET_PADDEDCELL
  EAX_PRESET_ROOM
  EAX_PRESET_BATHROOM
  EAX_PRESET_LIVINGROOM
  EAX_PRESET_STONEROOM
  EAX_PRESET_AUDITORIUM
  EAX_PRESET_CONCERTHALL
  EAX_PRESET_CAVE
  EAX_PRESET_ARENA
  EAX_PRESET_HANGAR
  EAX_PRESET_CARPETEDHALLWAY
  EAX_PRESET_HALLWAY
  EAX_PRESET_STONECORRIDOR
  EAX_PRESET_ALLEY
  EAX_PRESET_FOREST
  EAX_PRESET_CITY
  EAX_PRESET_MOUNTAINS
  EAX_PRESET_QUARRY
  EAX_PRESET_PLAIN
  EAX_PRESET_PARKINGLOT
  EAX_PRESET_SEWERPIPE
  EAX_PRESET_UNDERWATER
  EAX_PRESET_DRUGGED
  EAX_PRESET_DIZZY
  EAX_PRESET_PSYCHOTIC

cpdef enum:
  STREAMPROC_DUMMY=0
  STREAMPROC_PUSH=-1

cpdef enum:
  STREAMFILE_NOBUFFER=0
  STREAMFILE_BUFFER=1
  STREAMFILE_BUFFERPUSH=2

cpdef enum:
  BASS_FILEDATA_END=0

cpdef enum:
  BASS_FILEPOS_CURRENT=0
  BASS_FILEPOS_DECODE=BASS_FILEPOS_CURRENT
  BASS_FILEPOS_DOWNLOAD=1
  BASS_FILEPOS_END=2
  BASS_FILEPOS_START=3
  BASS_FILEPOS_CONNECTED=4
  BASS_FILEPOS_BUFFER=5
  BASS_FILEPOS_SOCKET=6
  BASS_FILEPOS_ASYNCBUF=7
  BASS_FILEPOS_SIZE=8

cpdef enum:
  BASS_SYNC_POS=0
  BASS_SYNC_END=2
  BASS_SYNC_META=4
  BASS_SYNC_SLIDE=5
  BASS_SYNC_STALL=6
  BASS_SYNC_DOWNLOAD=7
  BASS_SYNC_FREE=8
  BASS_SYNC_SETPOS=11
  BASS_SYNC_MUSICPOS=10
  BASS_SYNC_MUSICINST=1
  BASS_SYNC_MUSICFX=3
  BASS_SYNC_OGG_CHANGE=12
  BASS_SYNC_MIXTIME=0x40000000
  BASS_SYNC_ONETIME=0x80000000

cpdef enum:
  BASS_ACTIVE_STOPPED=0
  BASS_ACTIVE_PLAYING=1
  BASS_ACTIVE_STALLED=2
  BASS_ACTIVE_PAUSED=3

cpdef enum:
  BASS_ATTRIB_FREQ=1
  BASS_ATTRIB_VOL=2
  BASS_ATTRIB_PAN=3
  BASS_ATTRIB_EAXMIX=4
  BASS_ATTRIB_NOBUFFER=5
  BASS_ATTRIB_VBR=6
  BASS_ATTRIB_CPU=7
  BASS_ATTRIB_SRC=8
  BASS_ATTRIB_NET_RESUME=9
  BASS_ATTRIB_SCANINFO=10
  BASS_ATTRIB_MUSIC_AMPLIFY=0x100
  BASS_ATTRIB_MUSIC_PANSEP=0x101
  BASS_ATTRIB_MUSIC_PSCALER=0x102
  BASS_ATTRIB_MUSIC_BPM=0x103
  BASS_ATTRIB_MUSIC_SPEED=0x104
  BASS_ATTRIB_MUSIC_VOL_GLOBAL=0x105
  BASS_ATTRIB_MUSIC_ACTIVE=0x106
  BASS_ATTRIB_MUSIC_VOL_CHAN=0x200
  BASS_ATTRIB_MUSIC_VOL_INST=0x300

cpdef enum:
  BASS_DATA_AVAILABLE=0
  BASS_DATA_FIXED=0x20000000
  BASS_DATA_FLOAT=0x40000000
  BASS_DATA_FFT256=0x80000000
  BASS_DATA_FFT512=0x80000001
  BASS_DATA_FFT1024=0x80000002
  BASS_DATA_FFT2048=0x80000003
  BASS_DATA_FFT4096=0x80000004
  BASS_DATA_FFT8192=0x80000005
  BASS_DATA_FFT16384=0x80000006
  BASS_DATA_FFT_INDIVIDUAL=0x10
  BASS_DATA_FFT_NOWINDOW=0x20
  BASS_DATA_FFT_REMOVEDC=0x40
  BASS_DATA_FFT_COMPLEX=0x80

cpdef enum:
  BASS_LEVEL_MONO=1
  BASS_LEVEL_STEREO=2
  BASS_LEVEL_RMS=4

cpdef enum:
  BASS_TAG_ID3=0
  BASS_TAG_ID3V2=1
  BASS_TAG_OGG=2
  BASS_TAG_HTTP=3
  BASS_TAG_ICY=4
  BASS_TAG_META=5
  BASS_TAG_APE=6
  BASS_TAG_MP4=7
  BASS_TAG_VENDOR=9
  BASS_TAG_LYRICS3=10
  BASS_TAG_CA_CODEC=11
  BASS_TAG_MF=13
  BASS_TAG_WAVEFORMAT=14
  BASS_TAG_RIFF_INFO=0x100
  BASS_TAG_RIFF_BEXT=0x101
  BASS_TAG_RIFF_CART=0x102
  BASS_TAG_RIFF_DISP=0x103
  BASS_TAG_APE_BINARY=0x1000
  BASS_TAG_MUSIC_NAME=0x10000
  BASS_TAG_MUSIC_MESSAGE=0x10001
  BASS_TAG_MUSIC_ORDERS=0x10002
  BASS_TAG_MUSIC_INST=0x10100
  BASS_TAG_MUSIC_SAMPLE=0x10300

cpdef enum:
  BASS_POS_BYTE=0
  BASS_POS_MUSIC_ORDER=1
  BASS_POS_OGG=3
  BASS_POS_INEXACT=0x8000000
  BASS_POS_DECODE=0x10000000
  BASS_POS_DECODETO=0x20000000
  BASS_POS_SCAN=0x40000000

cpdef enum:
  BASS_INPUT_OFF=0x10000
  BASS_INPUT_ON=0x20000

cpdef enum:
  BASS_INPUT_TYPE_MASK=0xff000000
  BASS_INPUT_TYPE_UNDEF=0x00000000
  BASS_INPUT_TYPE_DIGITAL=0x01000000
  BASS_INPUT_TYPE_LINE=0x02000000
  BASS_INPUT_TYPE_MIC=0x03000000
  BASS_INPUT_TYPE_SYNTH=0x04000000
  BASS_INPUT_TYPE_CD=0x05000000
  BASS_INPUT_TYPE_PHONE=0x06000000
  BASS_INPUT_TYPE_SPEAKER=0x07000000
  BASS_INPUT_TYPE_WAVE=0x08000000
  BASS_INPUT_TYPE_AUX=0x09000000
  BASS_INPUT_TYPE_ANALOG=0x0a000000

cpdef enum:
  BASS_FX_DX8_CHORUS
  BASS_FX_DX8_COMPRESSOR
  BASS_FX_DX8_DISTORTION
  BASS_FX_DX8_ECHO
  BASS_FX_DX8_FLANGER
  BASS_FX_DX8_GARGLE
  BASS_FX_DX8_I3DL2REVERB
  BASS_FX_DX8_PARAMEQ
  BASS_FX_DX8_REVERB

cpdef enum:
  BASS_DX8_PHASE_NEG_180=0
  BASS_DX8_PHASE_NEG_90=1
  BASS_DX8_PHASE_ZERO=2
  BASS_DX8_PHASE_90=3
  BASS_DX8_PHASE_180=4

cpdef enum:
  BASS_IOSNOTIFY_INTERRUPT=1
  BASS_IOSNOTIFY_INTERRUPT_END=2

cdef extern from "bass.h":
  ctypedef void (*FILECLOSEPROC)(void *user)
  ctypedef QWORD (*FILELENPROC)(void *user)
  ctypedef DWORD (*FILEREADPROC)(void *buffer, DWORD length, void *user)
  ctypedef bint (*FILESEEKPROC)(QWORD offset, void *user)
  ctypedef DWORD (*STREAMPROC)(HSTREAM handle, void *buffer, DWORD length, void *user)
  ctypedef void (*DOWNLOADPROC)(const void *buffer, DWORD length, void *user)
  ctypedef void (*SYNCPROC)(HSYNC handle, DWORD channel, DWORD data, void *user)
  ctypedef void (*DSPPROC)(HDSP handle, DWORD channel, void *buffer, DWORD length, void *user)
  ctypedef bint (*RECORDPROC)(HRECORD handle, const void *buffer, DWORD length, void *user)
  ctypedef void (*IOSNOTIFYPROC)(DWORD status)

  ctypedef struct BASS_DEVICEINFO:
    const char *name
    const char *driver
    DWORD flags

  ctypedef struct BASS_INFO:
    DWORD flags
    DWORD hwsize
    DWORD hwfree
    DWORD freesam
    DWORD free3d
    DWORD minrate
    DWORD maxrate
    bint eax
    DWORD minbuf
    DWORD dsver
    DWORD latency
    DWORD initflags
    DWORD speakers
    DWORD freq

  ctypedef struct BASS_SAMPLE:
    DWORD freq
    float volume
    float pan
    DWORD flags
    DWORD length
    DWORD max
    DWORD origres
    DWORD chans
    DWORD mingap
    DWORD mode3d
    float mindist
    float maxdist
    DWORD iangle
    DWORD oangle
    float outvol
    DWORD vam
    DWORD priority

  ctypedef struct BASS_CHANNELINFO:
    DWORD freq
    DWORD chans
    DWORD flags
    DWORD ctype
    DWORD origres
    HPLUGIN plugin
    HSAMPLE sample
    const char *filename


  ctypedef struct BASS_RECORDINFO:
    DWORD flags
    DWORD formats
    DWORD inputs
    bint singlein
    DWORD freq

  ctypedef struct BASS_PLUGINFORM:
    DWORD ctype
    const char *name
    const char *exts

  ctypedef struct BASS_PLUGININFO:
    DWORD version
    DWORD formatc
    const BASS_PLUGINFORM *formats

  ctypedef struct BASS_3DVECTOR:
    float x
    float y
    float z

  ctypedef struct BASS_FILEPROCS:
    FILECLOSEPROC *close
    FILELENPROC *length
    FILEREADPROC *read
    FILESEEKPROC *seek

  ctypedef struct TAG_ID3:
    char id[3]
    char title[30]
    char artist[30]
    char album[30]
    char year[4]
    char comment[30]
    BYTE genre

  ctypedef struct TAG_APE_BINARY:
    const char *key
    const void *data
    DWORD length

  ctypedef struct TAG_BEXT:
    char Description[256]
    char Originator[32]
    char OriginatorReference[32]
    char OriginationDate[10]
    char OriginationTime[8]
    QWORD TimeReference
    WORD Version
    BYTE UMID[64]
    BYTE Reserved[190]
    char CodingHistory[1]

  ctypedef struct TAG_CART_TIMER:
    DWORD dwUsage
    DWORD dwValue

  ctypedef struct TAG_CART:
    char Version[4]
    char Title[64]
    char Artist[64]
    char CutID[64]
    char ClientID[64]
    char Category[64]
    char Classification[64]
    char OutCue[64]
    char StartDate[10]
    char StartTime[8]
    char EndDate[10]
    char EndTime[8]
    char ProducerAppID[64]
    char ProducerAppVersion[64]
    char UserDef[64]
    DWORD dwLevelReference
    TAG_CART_TIMER PostTimer[8]
    char Reserved[276]
    char URL[1024]
    char TagText[1]

  ctypedef struct TAG_CA_CODEC:
    DWORD ftype
    DWORD atype
    const char *name

  ctypedef struct BASS_DX8_CHORUS:
    float fWetDryMix
    float fDepth
    float fFeedback
    float fFrequency
    DWORD lWaveform
    float fDelay
    DWORD lPhase

  ctypedef struct BASS_DX8_COMPRESSOR:
    float fGain
    float fAttack
    float fRelease
    float fThreshold
    float fRatio
    float fPredelay

  ctypedef struct BASS_DX8_DISTORTION:
    float fGain
    float fEdge
    float fPostEQCenterFrequency
    float fPostEQBandwidth
    float fPreLowpassCutoff

  ctypedef struct BASS_DX8_ECHO:
    float fWetDryMix
    float fFeedback
    float fLeftDelay
    float fRightDelay
    bint lPanDelay

  ctypedef struct BASS_DX8_FLANGER:
    float fWetDryMix
    float fDepth
    float fFeedback
    float fFrequency
    DWORD lWaveform
    float fDelay
    DWORD lPhase

  ctypedef struct BASS_DX8_GARGLE:
    DWORD dwRateHz
    DWORD dwWaveShape

  ctypedef struct BASS_DX8_I3DL2REVERB:
    int lRoom
    int lRoomHF
    float flRoomRolloffFactor
    float flDecayTime
    float flDecayHFRatio
    int lReflections
    float flReflectionsDelay
    int lReverb
    float flReverbDelay
    float flDiffusion
    float flDensity
    float flHFReference

  ctypedef struct BASS_DX8_PARAMEQ:
    float fCenter
    float fBandwidth
    float fGain

  ctypedef struct BASS_DX8_REVERB:
    float fInGain
    float fReverbMix
    float fReverbTime
    float fHighFreqRTRatio

  cdef DWORD BASS_GetVersion()
  cdef bint BASS_SetConfig(DWORD option, DWORD value)
  cdef DWORD BASS_GetConfig(DWORD option)
  cdef bint BASS_SetConfigPtr(DWORD option, const void *value)
  cdef void *BASS_GetConfigPtr(DWORD option)
  cdef int BASS_ErrorGetCode()
  cdef bint BASS_GetDeviceInfo(DWORD device, BASS_DEVICEINFO *info)
  cdef bint BASS_Init(int device, DWORD freq, DWORD flags, void *win, const void *dsguid)
  cdef bint BASS_SetDevice(DWORD device)
  cdef DWORD BASS_GetDevice()
  cdef bint BASS_Free()
  IF UNAME_SYSNAME=='Windows':
   cdef void *BASS_GetDSoundObject(DWORD object)
   cdef bint BASS_SetEAXParameters(int env, float vol, float decay, float damp)
   cdef bint BASS_GetEAXParameters(DWORD *env, float *vol, float *decay, float *damp)
  cdef bint BASS_GetInfo(BASS_INFO *info)
  cdef bint BASS_Update(DWORD length)
  cdef float BASS_GetCPU()
  cdef bint BASS_Start()
  cdef bint BASS_Stop()
  cdef bint BASS_Pause()
  cdef bint BASS_SetVolume(float volume)
  cdef float BASS_GetVolume()
  cdef HPLUGIN BASS_PluginLoad(const char *file, DWORD flags)
  cdef bint BASS_PluginFree(HPLUGIN handle)
  cdef const BASS_PLUGININFO *BASS_PluginGetInfo(HPLUGIN handle)
  cdef bint BASS_Set3DFactors(float distf, float rollf, float doppf)
  cdef bint BASS_Get3DFactors(float *distf, float *rollf, float *doppf)
  cdef bint BASS_Set3DPosition(const BASS_3DVECTOR *pos, const BASS_3DVECTOR *vel, const BASS_3DVECTOR *front, const BASS_3DVECTOR *top)
  cdef bint BASS_Get3DPosition(BASS_3DVECTOR *pos, BASS_3DVECTOR *vel, BASS_3DVECTOR *front, BASS_3DVECTOR *top)
  cdef void BASS_Apply3D()
  cdef HMUSIC BASS_MusicLoad(bint mem, const void *file, QWORD offset, DWORD length, DWORD flags, DWORD freq)
  cdef bint BASS_MusicFree(HMUSIC handle)
  cdef HSAMPLE BASS_SampleLoad(bint mem, const void *file, QWORD offset, DWORD length, DWORD max, DWORD flags)
  cdef HSAMPLE BASS_SampleCreate(DWORD length, DWORD freq, DWORD chans, DWORD max, DWORD flags)
  cdef bint BASS_SampleFree(HSAMPLE handle)
  cdef bint BASS_SampleSetData(HSAMPLE handle, const void *buffer)
  cdef bint BASS_SampleGetData(HSAMPLE handle, void *buffer)
  cdef bint BASS_SampleGetInfo(HSAMPLE handle, BASS_SAMPLE *info)
  cdef bint BASS_SampleSetInfo(HSAMPLE handle, const BASS_SAMPLE *info)
  cdef HCHANNEL BASS_SampleGetChannel(HSAMPLE handle, bint onlynew)
  cdef DWORD BASS_SampleGetChannels(HSAMPLE handle, HCHANNEL *channels)
  cdef bint BASS_SampleStop(HSAMPLE handle)
  cdef HSTREAM BASS_StreamCreate(DWORD freq, DWORD chans, DWORD flags, STREAMPROC *proc, void *user)
  cdef HSTREAM BASS_StreamCreateFile(bint mem, const void *file, QWORD offset, QWORD length, DWORD flags)
  cdef HSTREAM BASS_StreamCreateURL(const char *url, DWORD offset, DWORD flags, DOWNLOADPROC *proc, void *user)
  cdef HSTREAM BASS_StreamCreateFileUser(DWORD system, DWORD flags, const BASS_FILEPROCS *proc, void *user)
  cdef bint BASS_StreamFree(HSTREAM handle)
  cdef QWORD BASS_StreamGetFilePosition(HSTREAM handle, DWORD mode)
  cdef DWORD BASS_StreamPutData(HSTREAM handle, const void *buffer, DWORD length)
  cdef DWORD BASS_StreamPutFileData(HSTREAM handle, const void *buffer, DWORD length)
  cdef bint BASS_RecordGetDeviceInfo(DWORD device, BASS_DEVICEINFO *info)
  cdef bint BASS_RecordInit(int device)
  cdef bint BASS_RecordSetDevice(DWORD device)
  cdef DWORD BASS_RecordGetDevice()
  cdef bint BASS_RecordFree()
  cdef bint BASS_RecordGetInfo(BASS_RECORDINFO *info)
  cdef const char *BASS_RecordGetInputName(int input)
  cdef bint BASS_RecordSetInput(int input, DWORD flags, float volume)
  cdef DWORD BASS_RecordGetInput(int input, float *volume)
  cdef HRECORD BASS_RecordStart(DWORD freq, DWORD chans, DWORD flags, RECORDPROC *proc, void *user)
  cdef double BASS_ChannelBytes2Seconds(DWORD handle, QWORD pos)
  cdef QWORD BASS_ChannelSeconds2Bytes(DWORD handle, double pos)
  cdef DWORD BASS_ChannelGetDevice(DWORD handle)
  cdef bint BASS_ChannelSetDevice(DWORD handle, DWORD device)
  cdef DWORD BASS_ChannelIsActive(DWORD handle)
  cdef bint BASS_ChannelGetInfo(DWORD handle, BASS_CHANNELINFO *info)
  cdef const char *BASS_ChannelGetTags(DWORD handle, DWORD tags)
  cdef DWORD BASS_ChannelFlags(DWORD handle, DWORD flags, DWORD mask)
  cdef bint BASS_ChannelUpdate(DWORD handle, DWORD length)
  cdef bint BASS_ChannelLock(DWORD handle, bint lock)
  cdef bint BASS_ChannelPlay(DWORD handle, bint restart)
  cdef bint BASS_ChannelStop(DWORD handle)
  cdef bint BASS_ChannelPause(DWORD handle)
  cdef bint BASS_ChannelSetAttribute(DWORD handle, DWORD attrib, float value)
  cdef bint BASS_ChannelGetAttribute(DWORD handle, DWORD attrib, float *value)
  cdef bint BASS_ChannelSlideAttribute(DWORD handle, DWORD attrib, float value, DWORD time)
  cdef bint BASS_ChannelIsSliding(DWORD handle, DWORD attrib)
  cdef bint BASS_ChannelSetAttributeEx(DWORD handle, DWORD attrib, void *value, DWORD size)
  cdef DWORD BASS_ChannelGetAttributeEx(DWORD handle, DWORD attrib, void *value, DWORD size)
  cdef bint BASS_ChannelSet3DAttributes(DWORD handle, int mode, float min, float max, int iangle, int oangle, float outvol)
  cdef bint BASS_ChannelGet3DAttributes(DWORD handle, DWORD *mode, float *min, float *max, DWORD *iangle, DWORD *oangle, float *outvol)
  cdef bint BASS_ChannelSet3DPosition(DWORD handle, const BASS_3DVECTOR *pos, const BASS_3DVECTOR *orient, const BASS_3DVECTOR *vel)
  cdef bint BASS_ChannelGet3DPosition(DWORD handle, BASS_3DVECTOR *pos, BASS_3DVECTOR *orient, BASS_3DVECTOR *vel)
  cdef QWORD BASS_ChannelGetLength(DWORD handle, DWORD mode)
  cdef bint BASS_ChannelSetPosition(DWORD handle, QWORD pos, DWORD mode)
  cdef QWORD BASS_ChannelGetPosition(DWORD handle, DWORD mode)
  cdef DWORD BASS_ChannelGetLevel(DWORD handle)
  cdef bint BASS_ChannelGetLevelEx(DWORD handle, float *levels, float length, DWORD flags)
  cdef DWORD BASS_ChannelGetData(DWORD handle, void *buffer, DWORD length)
  cdef HSYNC BASS_ChannelSetSync(DWORD handle, DWORD type, QWORD param, SYNCPROC *proc, void *user)
  cdef bint BASS_ChannelRemoveSync(DWORD handle, HSYNC sync)
  cdef HDSP BASS_ChannelSetDSP(DWORD handle, DSPPROC *proc, void *user, int priority)
  cdef bint BASS_ChannelRemoveDSP(DWORD handle, HDSP dsp)
  cdef bint BASS_ChannelSetLink(DWORD handle, DWORD chan)
  cdef bint BASS_ChannelRemoveLink(DWORD handle, DWORD chan)
  cdef HFX BASS_ChannelSetFX(DWORD handle, DWORD type, int priority)
  cdef bint BASS_ChannelRemoveFX(DWORD handle, HFX fx)
  cdef bint BASS_FXSetParameters(HFX handle, const void *params)
  cdef bint BASS_FXGetParameters(HFX handle, void *params)
  cdef bint BASS_FXReset(HFX handle)

  cdef BYTE LOBYTE(QWORD a)
  cdef BYTE HIBYTE(QWORD a)
  cdef WORD LOWORD(QWORD a)
  cdef WORD HIWORD(QWORD a)
  cdef WORD MAKEWORD(QWORD a, QWORD b)
  cdef DWORD MAKELONG(QWORD a, QWORD b)

cpdef __Evaluate()
cdef class BASS:
  cpdef __GetConfig(BASS self, DWORD key)
  cpdef __SetConfig(BASS self, DWORD key, object value)
  cpdef GetDevice(BASS self, int device=?)

  IF UNAME_SYSNAME == "Windows":
    cpdef GetDSoundObject(BASS self, int object)

  cpdef PluginLoad(BASS self, char *filename, DWORD flags=?)
