__attribute__((noreturn))
static void exit(int status) {
    register long rax __asm__ ("rax") = 60;
    register int rdi __asm__ ("rdi") = status;
    __asm__ __volatile__ (
        "syscall"
        : "+r" (rax)
        : "r" (rdi)
        : "cc", "rcx", "r11", "memory"
    );
  __builtin_unreachable();
}
