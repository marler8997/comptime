#include "exit_syscall.h"
static int djb2(const unsigned char *msg)
{
  int hash = 5381;
  for (unsigned i = 0; msg[i]; i++) {
    hash = ((hash << 5) + hash) + msg[i];
  }
  return hash;
}
static int modify(int n)
{
  unsigned char msg[2] = {(unsigned char)(0xFF & n), 0};
  return djb2(msg);
}
__attribute__((noreturn))
void _start()
{
  exit(modify(76));
  __builtin_unreachable();
}
