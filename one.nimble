# Package

version       = "0.1.0"
author        = "suzumi"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["one"]

# Dependencies

requires "nim >= 0.18.0",
         "secp256k1",
         "base58",
         "nimsha2"
