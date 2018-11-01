version     = "1.0.0"
author      = "Luke Parker"
description = "A Nim Wrapper for the Argon2 algorithm."
license     = "MIT"

installFiles = @[
    "Argon2.nim"
]

installDirs = @[
    "Argon2"
]

requires "nim > 0.18.2"
