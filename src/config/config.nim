import marshal, os

type
  Base* = object of RootObj

  Config* = object of Base
    protocolConfiguration*: ProtocolConfiguration

  ProtocolConfiguration* = object of Base
    seedList*: seq[string]

proc loadConfig*(): Config =
  let
    jsonStr = joinPath("src","config", "mainnet.json").readFile()
    config = to[Config] jsonStr
  
  result = config
