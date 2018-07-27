import parseopt, strformat, strutils
from log import info

type
  oneOptions* = object
    help*: bool
    portTcp*: int
    portRest*: int

proc parseargs*(args: string): oneOptions =
  var options = oneOptions(help: false, portTcp: 0, portRest: 0)
  var p = initOptParser args
  for kind, key, val in p.getopt():
    case kind
    of cmdLongOption:
      case key
      of "help": options.help = true
      of "port-tcp": options.portTcp = val.parseInt
      of "port-rest": options.portRest = val.parseInt
    of cmdShortOption:
      case key
      of "h": options.help = true
      of "t": options.portTcp = val.parseInt
      of "r": options.portRest = val.parseInt
    else: continue
    info options

    result = options

