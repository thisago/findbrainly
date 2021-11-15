import prologue

from findbrainly/route/search import searchSingle, searchMultiple

const urlPatterns* = @[
  pattern("/single", searchSingle),
  pattern("/multi", searchMultiple),
]
