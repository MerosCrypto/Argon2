import os

version     = "1.1.4"
author      = "Luke Parker"
description = "A Nim Wrapper for the Argon2 algorithm."
license     = "MIT"

installFiles = @[
    "Argon2.nim"
]

installDirs = @[
    "phc-winner-argon2"
]

requires "nim > 0.18.2"

before install:
    let makeExe: string = system.findExe("make")
    if makeExe == "":
        echo "Failed to find executable `make`."
        quit(1)

    withDir thisDir() / "phc-winner-argon2":
        exec makeExe
