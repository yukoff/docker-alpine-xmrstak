#!/bin/sh

# : ${POOL:=$1}
# : ${WALLET:=$2}
# : ${PASSWORD:=$3}
# : ${WORKERS:=${4:=$(grep -c '^processor' /proc/cpuinfo)}}

if [ -z "${POOL}" -a -n "$1" ]; then
  POOL=$1
fi

if [ -z "${WALLET}" -a -n "$2" ]; then
  WALLET=$2
fi

if [ -z "${PASSWORD}" -a -n "$3" ]; then
  PASSWORD=$3
fi

if [ -z "${WORKERS}" ]; then
  if [ -n "$4" ]; then
    WORKERS=$4
  else
    WORKERS=`grep -c ^processor /proc/cpuinfo`
  fi
fi

sed -re "s/\\$\\{?POOL\\}?/${POOL}/" \
    -re "s/\\$\\{?WALLET\\}?/${WALLET}/" \
    -re "s/\\$\\{?PASSWORD\\}?/${PASSWORD}/" \
    /xmr-stak/config.txt.tpl > /tmp/config.txt

echo '"cpu_threads_conf" :
[' > /tmp/cpu.txt
COUNTER=0
while [  ${COUNTER} -lt ${WORKERS} ]; do
  echo '  { "low_power_mode" : false, "no_prefetch" : true, "affine_to_cpu" : '${COUNTER}' },' >> /tmp/cpu.txt
  let COUNTER=COUNTER+1 
done
echo '],' >> /tmp/cpu.txt

/xmr-stak/bin/xmr-stak --config /tmp/config.txt --cpu /tmp/cpu.txt
