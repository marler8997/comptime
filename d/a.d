extern (C) void exit(ptrdiff_t status)
{
    asm { naked;mov EAX, 60;syscall; }
}
extern (C) void _start()
{
    // this only works on DMD
    version (DigitalMars)
    {
        asm { naked; }
    }
    exit(76);
}
