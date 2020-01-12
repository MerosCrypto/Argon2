#Wrapper for the Argon2 C library that won the PHC competition.

#Get the current folder.
const currentFolder: string = currentSourcePath().substr(0, currentSourcePath().len - 11)

#Include the header.
{.passC: "-I" & currentFolder & "phc-winner-argon2/include".}

#Link against Argon2.
{.passL: "-L" & currentFolder & "phc-winner-argon2/".}
{.passL: "-largon2".}

#Define the Hash Type.
type Hash*[bits: static[int]] = object
    data*: array[bits div 8, uint8]

#C proctions.
proc cArgon2d(
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

proc cArgon2i(
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

proc cArgon2id(
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

#Take in data and a salt; return a Hash.
proc Argon2d*(
    dataArg: string,
    saltArg: string,
    iterations: uint32,
    memory: uint32,
    parallelism: uint32
): Hash[256] =
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

    if cArgon2d(
        iterations,
        memory,
        parallelism,
        cast[ptr uint8](addr data[0]),
        uint32(data.len),
        cast[ptr uint8](addr salt[0]),
        uint32(salt.len),
        addr result.data[0],
        uint32(32)
    ) != 0:
        raise newException(Exception, "Argon2 raised an error.")

proc Argon2i*(
    dataArg: string,
    saltArg: string,
    iterations: uint32,
    memory: uint32,
    parallelism: uint32
): Hash[256] =
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

    if cArgon2i(
        iterations,
        memory,
        parallelism,
        cast[ptr uint8](addr data[0]),
        uint32(data.len),
        cast[ptr uint8](addr salt[0]),
        uint32(salt.len),
        addr result.data[0],
        uint32(32)
    ) != 0:
        raise newException(Exception, "Argon2 raised an error.")

proc Argon2id*(
    dataArg: string,
    saltArg: string,
    iterations: uint32,
    memory: uint32,
    parallelism: uint32
): Hash[256] =
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

    if cArgon2id(
        iterations,
        memory,
        parallelism,
        cast[ptr uint8](addr data[0]),
        uint32(data.len),
        cast[ptr uint8](addr salt[0]),
        uint32(salt.len),
        addr result.data[0],
        uint32(32)
    ) != 0:
        raise newException(Exception, "Argon2 raised an error.")
