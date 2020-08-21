# comptime

An analysis of the comptime/optimization abilities of languages.  "The Programs" section contains a description for a set of programs that test a language's capabilities.

# Results

The following are the current results of each language/compiler.  Every langauge/compiler is a separate column, and each row is a program, and the language/compiler letter grade, with A being the highest.  See the program description for more information about the letter grade.

|Program| c/gcc | c/clang | zig | d/dmd | d/ldc |
|-------|-------|---------|-----|-------|-------|
|a      |   A   |    A    |  A  |   B   |   C   |
|b0     |   A   |    A    |  A  |   NA  |   NA  |
|b1     |   A   |    A    |  A  |   NA  |   NA  |
|b2     |   A   |    A    |  A  |   NA  |   NA  |
|b3     |   A   |    A    |  A  |   NA  |   NA  |
|b3     |   A   |    C    |  C  |   NA  |   NA  |


# How to run

Find all test combinations with `find . -name test`.  Run any of these `test` scripts to test that language/compiler/flag combination.  The test will build and run each program.  You can inspect the assembly for each program with `objdump -d $TEST_DIR/out/$PROGRAM` where `$TEST_DIR` is the containing directory of the `test` script you ran, and `$PROGRAM` is the program you want to insepect.

# The Programs

These programs are x86-64 ELF executables meant to run on linux using the linux system call interface.

### Program a

Calls the exit system call with the number 76.  exit should be a function separate from the `_start` entry point function.

* Grade A: resulting program is 3 instructions: set syscall number, set exit code, syscall interrupt.
* Grade B: 4 instructions, unable to inline the exit function
* Grade C: worse than B

## The b programs

These programs start from the `a` program and add a function called "modify" that changes the exit code in various ways.  Program `a` is modified to pass the comptime known value 76 to the new `modify` function whose return value will be passed directly to the `exit` function.

These programs test if the language can detect that the `modify` function argument is comptime known and is able to interpret the function at comptime to avoid the need to generate it at all.  In each program, check to see if the `modify` function is being generated in the final executable.  Also, if the function is inlined, check to see if code was generated to modify the number at runtime, or if it interpreted the code at compile time and just emitted the result.  In the optimial case, all of these programs will be just 3 instructions like program `a` but with different values passed to the exit code register.

* Grade A: resulting program is 3 instructions

### Program b0

Do nothing to the exit code, just return it "as-is".  Ideally, this program will be the binary equivalent of program "a".

```
function modify(n) return n
```

* Grade A: resulting program is 3 instructions

### Program b1

Add one to the exit code.

```
function modify(n) return n + 1
```

* Grade A: resulting program is 3 instructions

### Program b2

Add one to the exit code in a loop that runs 10 times.

```
function modify(n)
    loop (10 times)
        n++
    return n
```

* Grade A: resulting program is 3 instructions

### Program b3

Create an additional function called "djb2" that takes a pointer to an array of bytes and a size and performs a djb2 hash.  Have the modify function call the djb2 function with a 1-byte message whose value is its input integer "anded" with 0xFF.  Note that this same function needs to work as a general implementation of the djb2 hash, this should be tested as well.  The resulting hash should be 177649 (0x2b5f1) but linux only reports the least-significat byte as the exit code, which in this case is 241 (0xf1).

```
function modify(n)
    msg = [0xFF & n]
    return djb2(msg)
function djb2(msg)
    hash = 5381
    for c in msg
        hash = ((hash << 5) + hash) + c
        // should be equivalent to: hash = hash * 33 + c
    return hash
```

* Grade A: resulting program is 3 instructions
* Grade B: both `modify` and `djb2` were inlined, but the djb2 hash is done at runtime
* Grade C: only one of `modify` or `djb2` were inlined, and the djb2 hash is being done at runtime
* Grade D: neither `modify` or `djb2` were inlined, and the djb2 hash is being done at runtime

### Program b4

Same as b3 except instead of taking a pointer to an array of bytes and a size, it takes a null-terminated array of bytes.

# Notes on more programs for later

* compile an x86_64 program for linux that prints "Hello" and exits using the write/exit system calls.  This should be a very small program, less than 100 byte of x86 assembly. We limit the program so much so that we can really test what the compiler can optimize out of the program.
* Then write a function that can capitalize the "Hello" message to "HELLO".  The program should perform the capatilization at compile-time and generate the same program but with a capitalized "HELLO".
* The function that performs the capitalization, should also work at runtime, use the same function to capitalize a string at runtime, such as the first argv string.
