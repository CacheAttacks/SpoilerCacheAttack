int checkevict(vlist_t es, void *candidate, int walk_size, int print);
int checkevict_safe(vlist_t es, void *candidate, int walk_size,
                           int print, int proofs);

void *expand(l3pp_t l3, vlist_t es, vlist_t candidates);
void contract(vlist_t es, vlist_t candidates, void *current);
int contract_multiple(vlist_t es, vlist_t candidates, void *current,
                             int del_number);
void contract_advanced(vlist_t es, vlist_t candidates, void *current,
                              int associativity);
int collect(vlist_t es, vlist_t candidates /*, vlist_t set*/);

void expand_test(vlist_t es, void *current);
void *expand_storefor(vlist_t es, vlist_t candidates);