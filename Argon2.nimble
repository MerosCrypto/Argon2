import os

version     = "1.1.2"
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
    let gitExe: string = system.findExe("git")
    if gitExe == "":
        echo "Failed to find executable `git`."
        quit(1)

    let makeExe: string = system.findExe("make")
    if makeExe == "":
        echo "Failed to find executable `make`."
        quit(1)

    withDir projectDir():
        exec gitExe & " submodule update --init --recursive"

    withDir projectDir() / "phc-winner-argon2":
        exec makeExe & " OPTTARGET=x86-64"
