alias size_t = ulong;
alias ptrdiff_t = long;
void __assert(const(char)* msg, const(char)* file, uint line)
{
    asm { naked; }
}
