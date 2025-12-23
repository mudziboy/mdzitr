#!/bin/bash

# Colors (Sesuai gaya project kamu)
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
RESET="\033[0m"
BOLD="\033[1m"
GRAY="\033[1;30m"

print_task() {
  echo -ne "${GRAY}•${RESET} $1..."
}

print_done() {
  echo -e "\r${GREEN}✓${RESET} $1      "
}

# 1. Persiapan Folder
mkdir -p /etc/zivpn
mkdir -p /etc/zivpn/api
mkdir -p /etc/xray/zivpn
touch /etc/xray/zivpn/.zivpn.db

# 2. Unduh Biner Core ZiVPN
print_task "Downloading ZiVPN Core"
wget -q https://github.com/zahidbd2/udp-zivpn/releases/download/udp-zivpn_1.4.9/udp-zivpn-linux-amd64 -O /usr/local/bin/zivpn && chmod +x /usr/local/bin/zivpn
print_done "ZiVPN Core Ready"

# 3. Setup Konfigurasi & API Key
domain=$(cat /etc/xray/domain 2>/dev/null || echo "localhost")
api_key=$(openssl rand -hex 16)
echo "$domain" > /etc/zivpn/domain
echo "$api_key" > /etc/zivpn/apikey
echo "8080" > /etc/zivpn/api_port

# 4. Buat file config.json standar ZiVPN
cat <<EOF > /etc/zivpn/config.json
{
  "listen": ":5667",
  "cert": "/etc/zivpn/zivpn.crt",
  "key": "/etc/zivpn/zivpn.key",
  "obfs": "zivpn",
  "auth": {
    "mode": "passwords",
    "config": ["autoftbot"]
  }
}
EOF

# 5. Generate SSL Internal
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/CN=$domain" -keyout /etc/zivpn/zivpn.key -out /etc/zivpn/zivpn.crt &>/dev/null

# 6. Pasang Service Systemd ZiVPN
cat <<EOF > /etc/systemd/system/zivpn.service
[Unit]
Description=ZIVPN UDP VPN Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/etc/zivpn
ExecStart=/usr/local/bin/zivpn server -c /etc/zivpn/config.json
Restart=always
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# 7. Pengaturan Iptables (Port Redirect - Anti Bentrok BadVPN)
iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)

# Hapus rule lama jika ada untuk menghindari duplikasi
iptables -t nat -D PREROUTING -i "$iface" -p udp --dport 6000:19999 -j DNAT --to-destination :5667 2>/dev/null

# Tambahkan rule baru yang melewati port 7100-7300 (BadVPN)
# Bagian 1: Port 6000 sampai 7099
iptables -t nat -A PREROUTING -i "$iface" -p udp --dport 6000:7099 -j DNAT --to-destination :5667

# Bagian 2: Port 7400 sampai 19999
iptables -t nat -A PREROUTING -i "$iface" -p udp --dport 7400:19999 -j DNAT --to-destination :5667

# Simpan agar permanen
iptables-save > /etc/iptables/rules.v4