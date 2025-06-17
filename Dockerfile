# docker/Dockerfile
FROM ubuntu:20.04

RUN apt update && apt install -y socat bash openssl curl netcat

WORKDIR /app
COPY scripts/ /app/
COPY cert.pem key.pem /app/

EXPOSE 443

CMD ["bash", "/app/watchdog.sh"]
