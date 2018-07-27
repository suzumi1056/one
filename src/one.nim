import parseOpt, os, strutils, asyncnet, asyncdispatch
from core/parseoptions import parseargs
from network/node import serve
from config/config import loadConfig

const HELP = """
One - Simple Blockchain written by Nim lang

Usage:
  one [options]

Options:
  ---help, -h                   Show help
  --port-tcp=[PORT] , -t=[PORT] Specify TCP port
  --port-rest=[PORT], -r=[PORT] Specify REST port

Example:
  one -h
  one --port-tcp=10300 --port-rest=10301
"""

proc main() =
  let config = loadConfig()
  let argsObj = commandLineParams().join(" ").parseargs
  if argsObj.help:
    echo HELP
    return

  if argsObj.portTcp == 0:
    echo "TCP port doesn't specified"
    return

  if argsObj.portRest == 0:
    echo "REST port doesn't specified"
    return

  asyncCheck serve(argsObj.portTcp)
  runForever()

main()
