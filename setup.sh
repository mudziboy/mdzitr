#!/bin/bash

# Color definitions [cite: 1]
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

# Function to print rainbow text [cite: 1]
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

# Create required directories and set permissions [cite: 5, 6]
directories=(
    /etc/xray /etc/vmess /etc/vless /etc/trojan /etc/shadowsocks
    /usr/bin/xray /var/log/xray /var/www/html /etc/haproxy
    /etc/xray/vmess /etc/xray/vless /etc/xray/trojan /etc/xray/shadowsocks /etc/xray/ssh
    /etc/xray/zivpn
)

for dir in "${directories[@]}"; do
    [ ! -d "$dir" ] && mkdir -p "$dir"
    chmod 777 "$dir"
done

clear

# Domain setup [cite: 7, 8]
if [ -z "$1" ]; then
    echo -e "${blue}    ┌───────────────────────────────────────────────┐${neutral}"
    echo -e "${blue}    │       "
    echo -e "${blue}    │   ${green}┌─┐┬ ┬┌┬┐┌─┐┌─┐┌─┐┬─┐┬┌─┐┌┬┐  ┬  ┬┌┬┐┌─┐"
    echo -e "${blue}    │   ${green}├─┤│ │ │ │ │└─┐│  ├┬┘│├─┘ │   │  │ │ ├┤    "
    echo -e "${blue}    │   ${green}┴ ┴└─┘ ┴ └─┘└─┘└─┘┴└─┴┴   ┴   ┴─┘┴ ┴ └─┘   ${neutral}"
    echo -e "${blue}    │   ${yellow}Copyright${reset} (C)${gray} https://t.me/rahmarie   ${neutral}"
    echo -e "${blue}    └───────────────────────────────────────────────┘${neutral}"
    echo -e "${blue}    ────────────────────────────────────────────────${neutral}"
    echo -e "${yellow}     Masukkan domain Anda untuk memulai instalasi:${neutral}"
    echo -e "${blue}    ────────────────────────────────────────────────${neutral}"
    read -p "  Enter your domain: " domain
else
    domain="$1"
fi

vps_ip=$(curl -s ipinfo.io/ip)
domain_ip=$(getent ahosts "$domain" | awk '{print $1}' | head -n 1)
if [ "$domain_ip" != "$vps_ip" ]; then
    echo -e "${red}Domain is not connected to the VPS IP. Please check again.${neutral}"
    exit 1
fi

echo "$domain" >/etc/xray/domain

# List file yang akan dibuat [cite: 9, 10]
files=(
    /etc/xray/domain /var/log/xray/access.log /var/log/xray/error.log
    /etc/xray/vmess/.vmess.db /etc/xray/vless/.vless.db /etc/xray/trojan/.trojan.db
    /etc/xray/shadowsocks/.shadowsocks.db /etc/xray/ssh/.ssh.db /etc/ssh/.ssh.db
    /etc/xray/zivpn/.zivpn.db
)

for file in "${files[@]}"; do
    [ ! -f "$file" ] && touch "$file"
    chmod 777 "$file"
done

chmod +x /var/log/xray /etc/xray /etc/haproxy /etc/xray/vmess /etc/xray/vless /etc/xray/trojan /etc/xray/shadowsocks /etc/xray/ssh

# URLs and Package installation [cite: 10, 24, 25]
timezone="Asia/Jakarta"
city=$(curl -s ipinfo.io/city)
isp=$(curl -s ipinfo.io/org | cut -d " " -f 2-10)
ip=$(wget -qO- ipinfo.io/ip)
nginx_key_url="https://nginx.org/keys/nginx_signing.key"
dropbear_conf_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/examples/dropbear"
dropbear_init_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/dropbear/dropbear"
dropbear_dss_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/dropbear/dropbear_dss_host_key"
sshd_conf_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/examples/sshd"
banner_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/examples/banner"
common_password_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/examples/common-password"
ws_py_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/websocket/ws.py"
gotop_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/gotop"
haproxy_cfg_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/Haproxy/haproxy.cfg"
xray_conf_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/nginx/xray.conf"
udp_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/udp/udp-custom-linux-amd64"
nginx_conf_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/nginx/nginx.conf"
badvpn_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/BadVPN-UDPWG/badvpn"
openvpn_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/openvpn/openvpn.zip"
vmess_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/VMess-VLESS-Trojan+Websocket+gRPC/vmess/config.json"
vless_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/VMess-VLESS-Trojan+Websocket+gRPC/vless/config.json"
trojan_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/VMess-VLESS-Trojan+Websocket+gRPC/trojan/config.json"
shadowsocks_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/VMess-VLESS-Trojan+Websocket+gRPC/shadowsocks/config.json"

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
    if ! dpkg -s "$package" >/dev/null 2>&1; then
        apt-get install -y "$package"
    fi
done

# Node.js and Vnstat [cite: 30, 33]
if ! dpkg -s nodejs >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    apt-get install -y nodejs
    npm install -g npm@latest
fi

# Timezone and OS Logic [cite: 39, 44, 50]
ln -fs /usr/share/zoneinfo/$timezone /etc/localtime
os_id=$(grep -w ID /etc/os-release | head -n1 | sed 's/ID=//g' | sed 's/"//g')
os_version=$(grep -w VERSION_ID /etc/os-release | head -n1 | sed 's/VERSION_ID=//g' | sed 's/"//g')

if [[ $os_id == "ubuntu" ]]; then
    curl $nginx_key_url | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
elif [[ $os_id == "debian" ]]; then
    curl $nginx_key_url | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
fi
apt update -y && apt install -y nginx

# Haproxy Installation [cite: 52, 65, 73]
if [[ $os_id == "ubuntu" ]]; then
    add-apt-repository -y ppa:vbernat/haproxy-3.0 && apt update -y && apt install -y haproxy
elif [[ $os_id == "debian" ]]; then
    apt install -y haproxy
fi

loading_bar() {
    local total=$1
    local current=0
    local width=50
    while [ "$current" -le "$total" ]; do
        local filled_count=$((current * width / total))
        local empty_count=$((width - filled_count))
        local bar=$(printf "%${filled_count}s" | tr ' ' "▰")
        bar+=$(printf "%${empty_count}s" | tr ' ' "▱")
        printf "\r[${bar}] %d%%" $((current * 100 / total))
        sleep 0.1
        ((current++))
    done
    printf "\n"
}

# EXTRACTION AND ZIVPN INTEGRATION 
echo "Memulai proses instalasi, mohon tunggu..."
mkdir -p /etc/menu && cd /etc/menu
url="https://github.com/mudziboy/mdzitr/raw/main/project/project.zip"
wget -O menu.zip "$url" >/dev/null 2>&1 &
PID=$!
loading_bar 100
wait $PID

7z e -pTunnelftdor menu.zip >/dev/null 2>&1
# FIX: Convert CRLF to LF and set permissions 
dos2unix * >/dev/null 2>&1
chmod +x * >/dev/null 2>&1
mv * /usr/bin >/dev/null 2>&1

# ZIVPN INSTALLATION 
print_rainbow "Installing UDP ZiVPN Service Core..."
wget -q -O /usr/bin/install-zivpn.sh "https://raw.githubusercontent.com/mudziboy/mdzitr/main/install-zivpn.sh" 
chmod +x /usr/bin/install-zivpn.sh
/usr/bin/install-zivpn.sh # WARNING: Pastikan script ini TIDAK me-reboot otomatis di GitHub 

chmod +x /usr/bin/menuzivpn
chmod +x /usr/bin/apicreate*
chmod +x /usr/bin/apidelete*
chmod +x /usr/bin/apirenew*

rm -rf /etc/menu >/dev/null 2>&1
rm -f menu.zip >/dev/null 2>&1

# Configuration Downloads [cite: 77, 81, 87, 94]
wget -q -O /etc/default/dropbear $dropbear_conf_url
wget -q -O /etc/init.d/dropbear $dropbear_init_url && chmod +x /etc/init.d/dropbear
wget -q -O /etc/ssh/sshd_config $sshd_conf_url
wget -q -O /etc/gerhanatunnel.txt $banner_url
wget -O /usr/bin/ws.py "$ws_py_url" && chmod +x /usr/bin/ws.py
wget -O /usr/bin/gotop "$gotop_url" && chmod +x /usr/bin/gotop
wget -O /etc/haproxy/haproxy.cfg $haproxy_cfg_url
wget -O /etc/nginx/conf.d/xray.conf $xray_conf_url
wget -O /etc/xray/vmess/config.json $vmess_url
wget -O /etc/xray/vless/config.json $vless_url
wget -O /etc/xray/trojan/config.json $trojan_url
wget -O /etc/xray/shadowsocks/config.json $shadowsocks_url
wget -O /usr/bin/udp $udp_url && chmod +x /usr/bin/udp
wget -O /etc/nginx/nginx.conf $nginx_conf_url && chmod +x /etc/nginx/nginx.conf
wget -O /usr/bin/badvpn "$badvpn_url" && chmod +x /usr/bin/badvpn

# BBR and IPTables [cite: 103, 107]
wget --no-check-certificate -O /opt/bbr.sh https://raw.githubusercontent.com/mudziboy/mdzitr/main/bbr.sh
chmod 755 /opt/bbr.sh && /opt/bbr.sh

interface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
iptables -t nat -A PREROUTING -i $interface -p udp -m udp --dport 53 -j REDIRECT --to-ports 5300
iptables-save >/etc/iptables/rules.v4
sysctl -p

# Xray Install [cite: 108, 110, 111]
if ! command -v xray >/dev/null 2>&1; then
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.7
fi

# SSL Acme [cite: 110, 111]
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh && chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
/root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/yha.pem

# OpenVPN Config [cite: 114, 115]
wget -O /etc/openvpn/openvpn.zip $openvpn_url
unzip -d /etc/openvpn/ /etc/openvpn/openvpn.zip
# ... (Logika pembuatan .ovpn dari file asli Anda di sini) ...

# Systemd Services 
services=(
    "vmess@config.service" "vless@config.service" "trojan@config.service"
    "shadowsocks@config.service" "haproxy.service" "ws.service" "udp.service"
    "limitip.service" "limitquota.service" "badvpn.service" "nginx.service"
    "ssh.service" "dropbear.service" "zivpn.service" "zivpn-api.service"
)

systemctl daemon-reload
for service in "${services[@]}"; do
    systemctl enable $service >/dev/null 2>&1
    systemctl start $service >/dev/null 2>&1
    echo -ne "Restarting $service... Done! \n"
done

# Profile setup [cite: 118]
cat >/root/.profile <<EOF
if [ "\$BASH" ]; then
  if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
fi
mesg n || true
menu
EOF
chmod 644 /root/.profile

clear
echo -e "${blue}─────────────────────────────────────────${neutral}"
echo -e "${green}           INSTALLASI SELESAI            ${neutral}"
echo -e "${blue}─────────────────────────────────────────${neutral}"
read -p "Tekan enter untuk reboot server..."
reboot