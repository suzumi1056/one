import transaction

var currentTransaction = @[]

proc createTx(vin: uint64, vout: uint64) =
  var tx = transaction.newTransaction()

