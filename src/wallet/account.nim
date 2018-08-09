import privateKey, strformat
import ../core/log

type
  Account* = ref object
    privateKey*: PrivateKey
    publicKey*: PublicKey

proc newAccount*(passPhrase: string): Account =
  let keyPair = privateKey.newKeyPair(passPhrase)

  info fmt"Private key: {keyPair.seckey}"
  info fmt"Public key: {keyPair.pubkey}"
  info fmt"Address: {keyPair.pubkey.encode}"
  
  new(result)
  result.privateKey = keyPair.seckey
  result.publicKey = keyPair.pubkey

