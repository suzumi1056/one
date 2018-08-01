import os
import asyncnet, asyncdispatch, os, parseOpt, strutils, pegs, unicode, strformat, sequtils
from ../config/config import loadConfig, Config
from ../core/parseoptions import oneOptions
from ../core/log import info

type
  Node* = ref object
    Listener*: AsyncSocket
    PeerAddr*: string
    SeedNodes*: seq[string]
    Addrs*: seq[string]
    Connecting*: bool

  Endpoint* = ref object
    ip*: string
    port*: uint16
  
  Peer* = ref object
    endpoint*: Endpoint 

var clients {.threadvar.}: seq[AsyncSocket]

proc newNode*(options: oneOptions): Node =
  let conf = loadConfig()

  new(result)
  result.Listener = nil
  result.PeerAddr = options.portTcp.intToStr
  result.SeedNodes = conf.protocolConfiguration.seedList
  result.Addrs = @[]
  result.Connecting = false

proc processClient(client: AsyncSocket) {.async.} =
  info "listen to new node"
  while true:
    let line = await client.recvLine()
    if line.len == 0: break
    info fmt"message: {line}"
    # send to other nodes
    for c in clients:
      await c.send(line & "\c\L")

proc serve*(node: Node) {.async.} =
  info "listen to socket..."
  clients = @[]
  var server = newAsyncSocket()
  server.setSockOpt(OptReuseAddr, true)
  server.bindAddr(Port(node.PeerAddr.parseInt))
  server.listen()

  node.Listener = server
  
  while true:
    let client = await server.accept()
    clients.add client
    
    asyncCheck processClient(client)

proc connectPeers*(node: Node) {.async.} =
  info "connecting to peers..."
  for v in node.SeedNodes:
    # var socket = newAsyncSocket()
    let adr = v.split(':')
    var connectionSuccess = true
    try:
      # while true:
      info fmt"connecting to node: {v}"
      let conn = await asyncnet.dial(adr[0], Port(adr[1].parseInt))
      node.Addrs.add v
      info fmt"connected to node successfully: {v}"
      asyncCheck conn.send("Hello !!")
    except:
      connectionSuccess = false
      # 接続失敗したノードへ再接続したい
      info fmt"cannot connection to {v}"

    
proc close*(node: Node) =
  node.Listener.close()
