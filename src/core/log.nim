import times, terminal

proc info*(msg: any) =
  setForegroundColor(stdout, fgCyan)
  stdout.write "[INFO ", getClockStr(), "] "
  resetAttributes(stdout)
  echo $msg

proc error*(msg: any) =
  setForegroundColor(stdout, fgRed)
  stdout.write "[ERROR ", getClockStr(), "] "
  resetAttributes(stdout)
  echo $msg

proc warn*(msg: any) =
  setForegroundColor(stdout, fgYellow)
  stdout.write "[WARN ", getClockStr(), "] "
  resetAttributes(stdout)
  echo $msg
