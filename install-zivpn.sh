#!/bin/bash
# install-zivpn.sh - VERSI FIX UNTUK MENU APICREATE

apt update -y && apt install -y curl wget jq iptables

# Variabel Path yang sesuai dengan file apicreate Anda
config_dir="/etc/zivpn"
db_file="$config_dir/.zivpn.db"
mkdir -p "$config_dir"
touch "$db_file"
chmod 777 "$db_file"

# Instalasi Biner
wget -q -O /usr/local/bin/zivpn "https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/zivpn/zivpn"
wget -q -O /usr/local/bin/zivpn-api "https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/zivpn/zivpn-api"
chmod +x /usr/local/bin/zivpn /usr/local/bin/zivpn-api

# Setup Service
cat > /etc/systemd/system/zivpn.service <<EOF
[Unit]
Description=ZiVPN UDP Custom
After=network.target
[Service]
ExecStart=/usr/local/bin/zivpn -port 5667
Restart=always
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/zivpn-api.service <<EOF
[Unit]
Description=ZiVPN API
After=network.target
[Service]
ExecStart=/usr/local/bin/zivpn-api -port 8080 -db $db_file
Restart=always
[Install]
WantedBy=multi-user.target
EOF

# Setup API Key untuk Menu
echo "Tunnelftdor" > "$config_dir/apikey"
echo "8080" > "$config_dir/api_port"

systemctl daemon-reload
systemctl enable zivpn zivpn-api
systemctl start zivpn zivpn-api

echo "ZiVPN Core Installed Successfully! (No Reboot)"