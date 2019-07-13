cdef const unsigned char[:] to_readonly_bytes(object s):
  if isinstance(s, unicode):
    s = (<unicode>s).encode('utf-8')
  return s
