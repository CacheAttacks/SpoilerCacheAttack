#include "l3.h"

int probetime(void *pp);

int probetime_adv_1(void *pp);
int probetime_adv_2(void *pp);
int probetime_adv_4(void *pp);
int probetime_adv_8(void *pp);
int probetime_adv_16(void *pp);

int probetime_adv_genric(void *pp, int max_it);

int probetime_split_2(void *pp);
int probetime_split_4(void *pp);
int probetime_split_8(void *pp);

p_probetime get_probetime_by_type(int type);
int probecount(void *pp);
int bprobecount(void *pp);
int bprobetime(void *pp, p_probetime func_ptr);

void probe_only(void *pp);
void probe_only_adv_1_fast(void *pp);
void probe_only_adv_1(void *pp);
void probe_only_adv_2(void *pp);
void probe_only_adv_3(void *pp);
void probe_only_adv_4(void *pp);
void probe_only_adv_5(void *pp);
void probe_only_adv_6(void *pp);
void probe_only_adv_7(void *pp);
void probe_only_adv_8(void *pp);
void probe_only_adv_9(void *pp);
void probe_only_adv_10(void *pp);
void probe_only_adv_11(void *pp);
void probe_only_adv_12(void *pp);
void probe_only_adv_13(void *pp);
void probe_only_adv_14(void *pp);
void probe_only_adv_15(void *pp);
void probe_only_adv_16(void *pp);
void probe_only_split_2(void *pp);
void probe_only_split_4(void *pp);
void probe_only_split_8(void *pp);

void probe_only_adv_generic(void *pp, int max_it);

void* get_probe_only_by_type(int type);