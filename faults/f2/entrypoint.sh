#!/bin/sh
node index.js &
/usr/local/bin/stress --vm 1 --vm-bytes 180M