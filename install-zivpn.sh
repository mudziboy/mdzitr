#!/bin/bash

# 1. Update dan install dependencies
apt update -y
apt install -y curl wget jq iptables iptables-persistent

# 2. Variabel Konfigurasi
binary_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/zivpn/zivpn"
api_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/zivpn/zivpn-api"
config_dir="/etc/xray/zivpn"
db_file="$config_dir/.zivpn.db"
api_port=8080
zivpn_port=5667

# 3. Persiapan Direktori dan Database
mkdir -p "$config_dir"
[ ! -f "$db_file" ] && touch "$db_file"
chmod 777 "$db_file"

# 4. Unduh Biner ZiVPN
wget -q -O /usr/local/bin/zivpn "$binary_url"
wget -q -O /usr/local/bin/zivpn-api "$api_url"
chmod +x /usr/local/bin/zivpn /usr/local/bin/zivpn-api

# 5. Membuat Service Systemd (Core)
cat > /etc/systemd/system/zivpn.service <<EOF
[Unit]
Description=ZiVPN UDP Custom Server
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/zivpn -port $zivpn_port
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 6. Membuat Service Systemd (API)
cat > /etc/systemd/system/zivpn-api.service <<EOF
[Unit]
Description=ZiVPN API Server
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/zivpn-api -port $api_port -db $db_file
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 7. Pengaturan Iptables (Anti-Bentrok BadVPN 7100-7300)
iface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)

# Hapus rule lama jika ada
iptables -t nat -D PREROUTING -i "$iface" -p udp --dport 6000:19999 -j DNAT --to-destination :$zivpn_port 2>/dev/null

# Tambahkan rule baru dengan mengecualikan port BadVPN
iptables -t nat -A PREROUTING -i "$iface" -p udp --dport 6000:7099 -j DNAT --to-destination :$zivpn_port
iptables -t nat -A PREROUTING -i "$iface" -p udp --dport 7400:19999 -j DNAT --to-destination :$zivpn_port

# Simpan Iptables
iptables-save > /etc/iptables/rules.v4

# 8. Reload dan Aktifkan Layanan
systemctl daemon-reload
systemctl enable zivpn zivpn-api
systemctl start zivpn zivpn-api

# AKHIR SCRIPT: Menghilangkan Perintah Reboot
echo -e "\033[1;32mZiVPN Core and API installed successfully!\033[0m"
echo -e "Returning to Main Setup Script..."
sleep 2