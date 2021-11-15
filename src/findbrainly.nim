## Main module of findbrainly

import pkg/prologue

from findbrainly/config import serverPort
from findbrainly/routes import urlPatterns

when isMainModule:
  var app = newApp(settings = newSettings(
    port = Port serverPort
  ))
  app.addRoute urlPatterns
  run app
