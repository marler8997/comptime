module syscall;

extern (C) size_t write(size_t fd, const(void)* buf, size_t n)
{
    asm
    {
        naked;
        mov EAX, 1;
        syscall;
        ret;
    }
}
extern (C) void exit(ptrdiff_t status)
{
    asm
    {
        naked;
        mov EAX, 60;
        syscall;
        ret;
    }
}
