# import random
import strformat
import strutils
import base58.bitcoin
import nimSHA2 as sha2
import ../core/log


type
  PublicKey* = object
    data*: string

  PrivateKey* = object
    data*: string

  KeyPair* = object
    seckey*: PrivateKey
    pubkey*: PublicKey

proc newPrivateKey*(passPhrase: string): PrivateKey =
  # Generates new private key.
  let passHex = passPhrase.toHex()

  info fmt"passHex: {passHex}"

  result.data = passHex
  
proc getPublicKey*(seckey: PrivateKey): PublicKey =
  result.data = sha2.computeSHA256(seckey.data).toHex()

proc newKeyPair*(passPhrase: string): KeyPair =
  result.seckey = newPrivateKey(passPhrase)
  result.pubkey = result.seckey.getPublicKey()

proc encode*(pubkey: PublicKey): string =
  result = bitcoin.encode(pubkey.data)  