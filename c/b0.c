#include "exit_syscall.h"
static int modify(int n)
{
  return n;
}
__attribute__((noreturn))
void _start()
{
  exit(modify(76));
  __builtin_unreachable();
}
