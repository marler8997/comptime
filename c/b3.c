#include "exit_syscall.h"
static int djb2(const unsigned char *msg, unsigned len)
{
  int hash = 5381;
  for (unsigned i = 0; i < len; i++) {
    hash = ((hash << 5) + hash) + msg[i];
  }
  return hash;
}
static int modify(int n)
{
  unsigned char msg[2] = {(unsigned char)(0xFF & n)};
  return djb2(msg, 1);
}
__attribute__((noreturn))
void _start()
{
  exit(modify(76));
  __builtin_unreachable();
}
