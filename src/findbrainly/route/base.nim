from std/json import `%*`, `%`, `$`
export json
import std/with
export with

import pkg/prologue

using
  ctx: Context

func setBaseHeaders*(ctx) =
  with ctx.response:
    setHeader "Content-Type", "application/json"
