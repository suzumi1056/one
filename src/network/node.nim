import os
import asyncnet, asyncdispatch, os, parseOpt, strutils, pegs, unicode, strformat
from ../config/config import loadConfig, Config
from ../core/parseoptions import oneOptions
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

proc newNode*(options: oneOptions): Node =
  let conf = loadConfig()

  result.PeerAddr = options.portTcp.intToStr
  result.SeedNodes = conf.protocolConfiguration.seedList
  result.Addrs = @[]

proc processClient(client: AsyncSocket) {.async.} =
  info "foobar"
  while true:
    let line = await client.recvLine()
    if line.len == 0: break
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
  
  while true:
    let client = await server.accept()
    clients.add client
    
    asyncCheck processClient(client)

proc connectPeers*(node: Node) {.async.} =
  info "connecting to peers..."
  for v in node.SeedNodes:
    # var socket = newAsyncSocket()
    let adr = v.split(':')
    try:
      # while true:
      info fmt"connectig to node: {v}"
      let conn = await asyncnet.dial(adr[0], Port(adr[1].parseInt))
      info fmt"connected to node successfully: {v}"
      asyncCheck conn.send("Hello !!")
    except:
      # 接続失敗したノードへ再接続したい
      info("retry !!")

    # asyncCheck socket.connect(adr[0], Port(adr[1].parseInt))
    # asyncCheck socket.send("I'm node!!")
    # asyncCheck conn.send("Hello !!")
    