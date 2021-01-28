#!/bin/bash

# intially the plan was to use a free, but macs dont have free.
# echo $(free | awk 'FNR==2{printf "%d * 100 / %d\n",  $3, $2}' | bc)

# both ubuntu and mac have ps though ...
echo $(ps -A -o %mem | awk '{ mem += $1 } END { print mem}')
