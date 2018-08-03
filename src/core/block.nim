import times
import transaction

type
  Block* = ref object
    Index*: uint64
    Timestamp*: times.Time
    MerkleRoot*: uint64
    Prevhash*: uint64
    Nonce*: uint64
    Transactions*: seq[Transaction]

# proc newBlock(transactions: seq[Transaction], prevHash: uint64): Block =
#   return Block(

#   )
