#ifdef WASM
extern void printf_ex_js(uint32_t);
int printf_ex(const char *format, ...);
#endif