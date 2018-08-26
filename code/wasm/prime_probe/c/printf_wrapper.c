#include <inttypes.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h> 

#include "config.h"
#include "printf_wrapper.h"

#ifdef WASM
int printf_ex(const char *format, ...)
{
  //pass ... as va_list to vsprintf
  va_list valist;
  va_start(valist, format);
  char *buffer = calloc(512, sizeof(char));
  int ret = vsprintf(buffer, format, valist);

  printf_ex_js((uint32_t)buffer);
  free(buffer);
  return ret;
}
#endif