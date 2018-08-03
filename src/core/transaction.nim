type
  Input* = ref object
    amount*: uint64

  Output* = ref object
    amount*: uint64

  Transaction* = ref object
    Inputs*: seq[Input]
    Outputs*: seq[Output]
    Amount*: uint64

proc newTransaction*(): Transaction =
  var tx = Transaction(
    Inputs: @[],
    Outputs: @[],
  )
  result = tx
  
