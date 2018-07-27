import asyncnet, asyncdispatch, os, parseOpt
from ../core/log import info

type
  Node* = object
    PeerAddr*: string
    SeedNodes*: seq[string]
    Addrs*: seq[string]

  Endpoint* = object
    ip*: string
    port*: uint16
  
  Peer* = object
    endpoint*: Endpoint 

var clients {.threadvar.}: seq[AsyncSocket]

proc processClient(client: AsyncSocket) {.async.} =
  info "foobar"
  while true:
    let line = await client.recvLine()
    if line.len == 0: break
    for c in clients:
      await c.send(line & "\c\L")

proc serve*(port: int) {.async.} =
  clients = @[]
  var server = newAsyncSocket()
  server.setSockOpt(OptReuseAddr, true)
  server.bindAddr(Port(port))
  server.listen()
  
  while true:
    let client = await server.accept()
    info "hogehoge"
    clients.add client
    
    asyncCheck processClient(client)

proc connectPeers*(node: Node) {.async.} =
  info "connecting to peers..."
  for v in node.SeedNodes:
    
    