gcc -O3 -g victim.c l3.c es_management.c vlist.c probe.c timestats.c -o bin/victim_$(date +"%g%m%d.%H%M%S") -DVERSION=$(date +"%g%m%d.%H%M%S")
