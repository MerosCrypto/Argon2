#Wrapper for the Argon2 C library that won the PHC competition.

#Define the Hash Type.
type Hash*[bits: static[int]] = object
    data*: array[bits div 8, uint8]

#Get the current folder.
const currentFolder = currentSourcePath().substr(0, currentSourcePath().len - 11)
#Include the headers.
{.passC: "-I" & currentFolder & "Argon2/include".}
{.passC: "-I" & currentFolder & "Argon2/src".}
{.passC: "-I" & currentFolder & "Argon2/src/blake2".}
#Compile the relevant C files.
{.compile: currentFolder & "Argon2/src/core.c".}
{.compile: currentFolder & "Argon2/src/thread.c".}
{.compile: currentFolder & "Argon2/src/encoding.c".}
{.compile: currentFolder & "Argon2/src/blake2/blake2b.c".}
{.compile: currentFolder & "Argon2/src/ref.c".}
{.compile: currentFolder & "Argon2/src/argon2.c".}

#C functions.
func cArgon2d(
    iterations: uint32,
    memory: uint32,
    parallelism: uint32,
    data: ptr uint8,
    dataLen: uint32,
    salt: ptr uint8,
    saltLen: uint32,
    res: ptr uint8,
    resLen: uint32
): cint {.
    header: "argon2.h",
    importc: "argon2id_hash_raw"
.}

func cArgon2i(
    iterations: uint32,
    memory: uint32,
    parallelism: uint32,
    data: ptr uint8,
    dataLen: uint32,
    salt: ptr uint8,
    saltLen: uint32,
    res: ptr uint8,
    resLen: uint32
): cint {.
    header: "argon2.h",
    importc: "argon2i_hash_raw"
.}

func cArgon2id(
    iterations: uint32,
    memory: uint32,
    parallelism: uint32,
    data: ptr uint8,
    dataLen: uint32,
    salt: ptr uint8,
    saltLen: uint32,
    res: ptr uint8,
    resLen: uint32
): cint {.
    header: "argon2.h",
    importc: "argon2d_hash_raw"
.}

#Take in data and a salt; return a Hash.
func Argon2d*(
    dataArg: string,
    saltArg: string,
    iterations: uint32,
    memory: uint32,
    parallelism: uint32
): Hash[384] =
    #Extract the args.
    var
        data: string = dataArg
        salt: string = saltArg

    #Make sure the data exists.
    if data == "":
        data = $char(0)
    #Make sure the salt is at least 8 characters long.
    while salt.len < 8:
        salt = char(0) & salt

    #The iteration quantity and memory usage values are for testing only.
    #They are not final and will be changed.
    if cArgon2d(
        iterations,
        memory,
        uint32(1),
        cast[ptr uint8](addr data[0]),
        uint32(data.len),
        cast[ptr uint8](addr salt[0]),
        uint32(salt.len),
        addr result.data[0],
        uint32(48)
    ) != 0:
        raise newException(Exception, "Argon2 raised an error.")

func Argon2i*(
    dataArg: string,
    saltArg: string,
    iterations: uint32,
    memory: uint32,
    parallelism: uint32
): Hash[384] =
    #Extract the args.
    var
        data: string = dataArg
        salt: string = saltArg

    #Make sure the data exists.
    if data == "":
        data = $char(0)
    #Make sure the salt is at least 8 characters long.
    while salt.len < 8:
        salt = char(0) & salt

    #The iteration quantity and memory usage values are for testing only.
    #They are not final and will be changed.
    if cArgon2i(
        iterations,
        memory,
        uint32(1),
        cast[ptr uint8](addr data[0]),
        uint32(data.len),
        cast[ptr uint8](addr salt[0]),
        uint32(salt.len),
        addr result.data[0],
        uint32(48)
    ) != 0:
        raise newException(Exception, "Argon2 raised an error.")

func Argon2id*(
    dataArg: string,
    saltArg: string,
    iterations: uint32,
    memory: uint32,
    parallelism: uint32
): Hash[384] =
    #Extract the args.
    var
        data: string = dataArg
        salt: string = saltArg

    #Make sure the data exists.
    if data == "":
        data = $char(0)
    #Make sure the salt is at least 8 characters long.
    while salt.len < 8:
        salt = char(0) & salt

    #The iteration quantity and memory usage values are for testing only.
    #They are not final and will be changed.
    if cArgon2id(
        iterations,
        memory,
        uint32(1),
        cast[ptr uint8](addr data[0]),
        uint32(data.len),
        cast[ptr uint8](addr salt[0]),
        uint32(salt.len),
        addr result.data[0],
        uint32(48)
    ) != 0:
        raise newException(Exception, "Argon2 raised an error.")
