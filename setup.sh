#!/bin/bash

# Color definitions
green="\e[38;5;82m"
red="\e[38;5;196m"
neutral="\e[0m"
orange="\e[38;5;130m"
blue="\e[38;5;39m"
yellow="\e[38;5;226m"
purple="\e[38;5;141m"
bold_white="\e[1;37m"
pink="\e[38;5;205m"
reset="\e[0m"
gray="\e[38;5;245m"

# Function to print rainbow text
print_rainbow() {
    local text="$1"
    local length=${#text}
    local start_color=(0 5 0)
    local mid_color=(0 200 0)
    local end_color=(0 5 0)
    for ((i = 0; i < length; i++)); do
        local progress=$((i * 100 / (length - 1)))
        if [ $progress -lt 50 ]; then
            local factor=$((progress * 2))
            r=$(((start_color[0] * (100 - factor) + mid_color[0] * factor) / 100))
            g=$(((start_color[1] * (100 - factor) + mid_color[1] * factor) / 100))
            b=$(((start_color[2] * (100 - factor) + mid_color[2] * factor) / 100))
        else
            local factor=$(((progress - 50) * 2))
            r=$(((mid_color[0] * (100 - factor) + end_color[0] * factor) / 100))
            g=$(((mid_color[1] * (100 - factor) + end_color[1] * factor) / 100))
            b=$(((mid_color[2] * (100 - factor) + end_color[2] * factor) / 100))
        fi
        printf "\e[38;2;%d;%d;%dm%s" "$r" "$g" "$b" "${text:$i:1}"
    done
    echo -e "$reset"
}

# Create required directories and set permissions
directories=(
    /etc/xray /etc/vmess /etc/vless /etc/trojan /etc/shadowsocks
    /usr/bin/xray /var/log/xray /var/www/html /etc/haproxy
    /etc/xray/vmess /etc/xray/vless /etc/xray/trojan /etc/xray/shadowsocks /etc/xray/ssh
    /etc/zivpn # Folder modifikasi ZiVPN
)

for dir in "${directories[@]}"; do
    [ ! -d "$dir" ] && mkdir -p "$dir"
    chmod 777 "$dir"
done

clear

# Domain setup
if [ -z "$1" ]; then
    echo -e "${blue}    ┌───────────────────────────────────────────────┐${neutral}"
    echo -e "${blue}    │   ${green}┌─┐┬ ┬┌┬┐┌─┐┌─┐┌─┐┬─┐┬┌─┐┌┬┐  ┬  ┬┌┬┐┌─┐"
    echo -e "${blue}    │   ${green}├─┤│ │ │ │ │└─┐│  ├┬┘│├─┘ │   │  │ │ ├┤    "
    echo -e "${blue}    │   ${green}┴ ┴└─┘ ┴ └─┘└─┘└─┘┴└─┴┴   ┴   ┴─┘┴ ┴ └─┘   ${neutral}"
    echo -e "${blue}    │   ${yellow}Copyright${reset} (C)${gray} https://t.me/thefatkay   ${neutral}"
    echo -e "${blue}    └───────────────────────────────────────────────┘${neutral}"
    read -p "  Enter your domain: " domain
else
    domain="$1"
fi

vps_ip=$(curl -s ipinfo.io/ip)
domain_ip=$(getent ahosts "$domain" | awk '{print $1}' | head -n 1)
if [ "$domain_ip" != "$vps_ip" ]; then
    echo -e "${red}Domain is not connected to the VPS IP.${neutral}"
    exit 1
fi
echo "$domain" >/etc/xray/domain

# List database files
files=(
    /etc/xray/domain /var/log/xray/access.log /var/log/xray/error.log
    /etc/xray/vmess/.vmess.db /etc/xray/vless/.vless.db /etc/xray/trojan/.trojan.db
    /etc/xray/shadowsocks/.shadowsocks.db /etc/xray/ssh/.ssh.db /etc/ssh/.ssh.db
    /etc/zivpn/.zivpn.db # Modifikasi database ZiVPN
)
for file in "${files[@]}"; do
    [ ! -f "$file" ] && touch "$file"
    chmod 777 "$file"
done

# Package installation
apt update -y
packages=(
    libnss3-dev liblzo2-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev
    libcap-ng-utils libselinux1-dev flex bison make libnss3-tools libevent-dev bc
    rsyslog dos2unix zlib1g-dev libssl-dev libsqlite3-dev sed dirmngr libxml-parser-perl build-essential
    gcc g++ htop lsof tar wget curl ruby zip unzip p7zip-full libc6 util-linux
    ca-certificates iptables iptables-persistent netfilter-persistent
    net-tools openssl gnupg gnupg2 lsb-release shc cmake git whois
    screen socat xz-utils apt-transport-https gnupg1 dnsutils cron bash-completion ntpdate chrony jq
    tmux python3 python3-pip lsb-release gawk openvpn easy-rsa dropbear
)
for package in "${packages[@]}"; do
    dpkg -s "$package" >/dev/null 2>&1 || apt-get install -y "$package"
done

# Nginx setup
os_id=$(grep -w ID /etc/os-release | head -n1 | sed 's/ID=//g' | sed 's/"//g')
if [[ $os_id == "ubuntu" ]]; then
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
    apt update -y && apt install -y nginx
    add-apt-repository -y ppa:vbernat/haproxy-3.0 && apt update -y && apt install -y haproxy
elif [[ $os_id == "debian" ]]; then
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
    apt update -y && apt install -y nginx haproxy
fi

# Extraksi Menu & Modifikasi ZiVPN
mkdir -p /etc/menu && cd /etc/menu
wget -q -O menu.zip "https://github.com/mudziboy/mdzitr/raw/main/project/project.zip"
7z e -pTunnelftdor menu.zip >/dev/null 2>&1

# PERBAIKAN: Jalankan dos2unix sebelum file dipindah ke /usr/bin
dos2unix * >/dev/null 2>&1
chmod +x * >/dev/null 2>&1
mv * /usr/bin >/dev/null 2>&1

# MODIFIKASI: Instalasi ZiVPN Core
print_rainbow "Installing UDP ZiVPN Service Core..."
wget -q -O /usr/bin/install-zivpn.sh "https://raw.githubusercontent.com/mudziboy/mdzitr/main/install-zivpn.sh"
chmod +x /usr/bin/install-zivpn.sh
/usr/bin/install-zivpn.sh

# PERBAIKAN: Sinkronisasi API Key ZiVPN agar apicreate tidak error
mkdir -p /etc/zivpn
echo "Tunnelftdor" > /etc/zivpn/apikey
echo "8080" > /etc/zivpn/api_port
chmod +x /usr/bin/menuzivpn /usr/bin/apicreate* /usr/bin/apirenew* /usr/bin/apidelete*

# Konfigurasi Xray Service
create_service() {
    cat >/etc/systemd/system/${1}@config.service <<EOF
[Unit]
Description=GerhanaTunnel Server Xray Instance %i
After=network.target nss-lookup.target
[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=yes
ExecStart=/usr/local/bin/xray run -config /etc/xray/${1}/%i.json
Restart=on-failure
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF
}
for s in vmess vless trojan shadowsocks; do create_service "$s"; done

# Sisa kode asli (Downloads & BBR)
wget -O /usr/bin/ws.py "https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/websocket/ws.py" && chmod +x /usr/bin/ws.py
wget -O /etc/nginx/conf.d/xray.conf "https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/nginx/xray.conf"
wget -O /usr/bin/udp "https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/udp/udp-custom-linux-amd64" && chmod +x /usr/bin/udp
wget -O /usr/bin/badvpn "https://raw.githubusercontent.com/mudziboy/mdzitr/main/BadVPN-UDPWG/badvpn" && chmod +x /usr/bin/badvpn
wget --no-check-certificate -O /opt/bbr.sh https://raw.githubusercontent.com/mudziboy/mdzitr/main/bbr.sh
chmod 755 /opt/bbr.sh && /opt/bbr.sh

# Xray Install
if ! command -v xray >/dev/null 2>&1; then
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.7
fi

# Aktivasi Services
services=(
    "vmess@config.service" "vless@config.service" "trojan@config.service" 
    "shadowsocks@config.service" "haproxy.service" "nginx.service" 
    "zivpn.service" "zivpn-api.service" "ssh.service" "dropbear.service"
    "ws.service" "udp.service" "badvpn.service"
)
systemctl daemon-reload
for service in "${services[@]}"; do
    systemctl enable $service >/dev/null 2>&1
    systemctl start $service >/dev/null 2>&1
done

# Profile login
cat >/root/.profile <<EOF
if [ "\$BASH" ]; then
  if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
fi
mesg n || true
menu
EOF
chmod 644 /root/.profile

rm -rf /etc/menu
clear
print_rainbow "INSTALLASI SELESAI"
read -p "Tekan enter untuk reboot server..."
reboot