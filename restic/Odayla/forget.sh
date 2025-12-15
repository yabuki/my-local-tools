#!/usr/bin/bash
set -euo pipefail

ARRAY=("13d02bae" "a90d74b2")

for(( i=0; i<${#ARRAY[@]}; i++))
do
  echo ${ARRAY[$i]}
  #sudo /usr/bin/restic -p passwd.txt -r /misc/remoable2/restic forget --prune ${ARRAY[$i]}
done
