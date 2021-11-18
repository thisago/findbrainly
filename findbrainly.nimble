# Package

version       = "0.2.0"
author        = "Luciano Lorenzo"
description   = "Easy API to find Brainly questions using Duckduckgo"
license       = "GPL-3"
srcDir        = "src"

bin = @["findbrainly"]
binDir = "build"

# Dependencies

requires "nim >= 1.5.1"
requires "prologue"
requires "brainlyextractor", "duckduckgo"

task build_release, "Builds the release version":
  exec "nimble -d:release build"
task build_danger, "Builds the danger version":
  exec "nimble -d:danger build"
