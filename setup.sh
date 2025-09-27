#!/bin/bash

# ===============================================
# SCRIPT REVISI SAGI MARKET VVIP & RAHMARIE
# Ditargetkan untuk Ubuntu 20.04
# ===============================================

# Color definitions
neutral="\e[0m"
orange="\e[38;5;130m"
purple="\e[38;5;141m"
bold_white="\e[1;37m"
pink="\e[38;5;205m"
green="\e[32;1m"
cyan="\e[36;1m"
magenta="\e[35;1m"
yellow="\e[33;1m"
red="\e[31;1m"
blue="\e[34;1m"
gray="\e[37;1m"
reset="\e[0m"

# Function to print rainbow text (dibiarkan seperti aslinya)
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
    echo -e "$reset" # Reset color at the end
}

# Membuat direktori yang diperlukan dan MENGATUR IZIN YANG AMAN
directories=(
    /etc/xray
    /etc/vmess
    /etc/vless
    /etc/trojan
    /etc/shadowsocks
    /usr/bin/xray
    /var/log/xray
    /var/www/html
    /etc/haproxy
    /etc/xray/vmess
    /etc/xray/vless
    /etc/xray/trojan
    /etc/xray/shadowsocks
    /etc/xray/ssh
)

for dir in "${directories[@]}"; do
    [ ! -d "$dir" ] && mkdir -p "$dir"
    # Menggunakan 755: rwxr-xr-x (Pemilik bisa baca/tulis/eksekusi, Grup & Lainnya hanya baca/eksekusi)
    chmod 755 "$dir"
done

clear

# Warna (didefinisikan ulang di sini, biarkan sesuai script asli)
cyan="\e[36;1m"
green="\e[32;1m"
magenta="\e[35;1m"
yellow="\e[33;1m"
blue="\e[34;1m"
neutral="\e[0m"

# Domain setup
if [ -z "$1" ]; then
    echo -e "${cyan}╔════════════════════════════════════════════════════════════════╗${neutral}"
    echo -e "${cyan}║                                                                ║${neutral}"
    
    # SAGIVPN (keren & simetris)
    echo -e "${cyan}║   ${green}███████╗ █████╗  ██████╗ ██╗ ██████╗ ██╗   ██╗███╗   ██╗${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}██╔════╝██╔══██╗██╔═══██╗██║██╔═══██╗██║   ██║████╗  ██║${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}█████╗  ███████║██║   ██║██║██║   ██║██║   ██║██╔██╗ ██║${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}██╔══╝  ██╔══██║██║   ██║██║██║   ██║██║   ██║██║╚██╗██║${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}███████╗██║  ██║╚██████╔╝██║╚██████╔╝╚██████╔╝██║ ╚████║${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝${cyan}║${neutral}"
    
    # Spacer
    echo -e "${cyan}║                                                                ║${neutral}"
    
    # RAHMARIE (lebih artistik & simetris)
    echo -e "${cyan}║   ${green}██████╗  █████╗ ██╗  ██╗███╗   ███╗ █████╗ ██████╗ ██╗███████╗${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}██╔══██╗██╔══██╗██║ ██╔╝████╗ ████║██╔══██╗██╔══██╗██║██╔════╝${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}██████╔╝███████║█████╔╝ ██╔████╔██║███████║██████╔╝██║█████╗  ${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}██╔═══╝ ██╔══██║██╔═██╗ ██║╚██╔╝██║██╔══██║██╔═══╝ ██║██╔══╝  ${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}██║     ██║  ██║██║  ██╗██║ ╚═╝ ██║██║  ██║██║     ██║███████╗${cyan}║${neutral}"
    echo -e "${cyan}║   ${green}╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝${cyan}║${neutral}"

    echo -e "${cyan}║                                                                ║${neutral}"
    echo -e "${cyan}║   ${magenta}Copyright (C) ${yellow}https://t.me/rahmarie${cyan}                         ║${neutral}"
    echo -e "${cyan}╚════════════════════════════════════════════════════════════════╝${neutral}"
    echo -e "${blue}────────────────────────────────────────────────────────────────${neutral}"
    echo -e "${yellow} Masukkan domain Anda untuk memulai instalasi:${neutral}"
    echo -e "${blue}────────────────────────────────────────────────────────────────${neutral}"
    read -p "  Enter your domain: " domain
else
    domain="$1"
fi
# Simpan domain ke file
echo "$domain" >/etc/xray/domain

# List file yang akan dibuat dan diatur permission-nya
files=(
    /etc/xray/domain
    /var/log/xray/access.log
    /var/log/xray/error.log
    /etc/xray/vmess/.vmess.db
    /etc/xray/vless/.vless.db
    /etc/xray/trojan/.trojan.db
    /etc/xray/shadowsocks/.shadowsocks.db
    /etc/xray/ssh/.ssh.db
    /etc/ssh/.ssh.db
)

for file in "${files[@]}"; do
    [ ! -f "$file" ] && touch "$file"
    # Menggunakan 644: rw-r--r-- (Izin yang lebih aman untuk file konfigurasi/database)
    chmod 644 "$file"
done

# Hapus akses eksekusi yang tidak perlu pada direktori. Direktori sudah 755.
# chmod +x /var/log/xray /etc/xray /etc/haproxy /etc/xray/vmess /etc/xray/vless /etc/xray/trojan /etc/xray/shadowsocks /etc/xray/ssh

# Informasi sistem
timezone="Asia/Jakarta"
city=$(curl -s ipinfo.io/city)
isp=$(curl -s ipinfo.io/org | cut -d " " -f 2-10)
domain=$(cat /etc/xray/domain)
ip=$(wget -qO- ipinfo.io/ip)
data=$(curl -s https://raw.githubusercontent.com/mudziboy/mdzitr/main/izin)
key=$(echo "$data" | grep "$ip" | awk '{print $2}')
nginx_key_url="https://nginx.org/keys/nginx_signing.key"
dropbear_init_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/dropbear/dropbear"
dropbear_conf_url="https://raw.githubusercontent.com/mudziboy/mdzitr/main/fodder/examples/dropbear"
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

os_id=$(grep -w ID /etc/os-release | head -n1 | sed 's/ID=//g' | sed 's/"//g')
os_version=$(grep -w VERSION_ID /etc/os-release | head -n1 | sed 's/VERSION_ID=//g' | sed 's/"//g')
echo "OS: $os_id, Version: $os_version"
if [ "$EUID" -ne 0 ]; then
echo -e "${red}This script must be run as root${neutral}"
exit 1
fi

if ! apt update -y; then
echo -e "${red}Failed to update${neutral}"
fi
if ! dpkg -s sudo >/dev/null 2>&1; then
if ! apt install sudo -y; then
echo -e "${red}Failed to install sudo${neutral}"
fi
else
echo -e "${green}sudo is already installed, skipping...${neutral}"
fi
if ! dpkg -s software-properties-common debconf-utils >/dev/null 2>&1; then
if ! apt install -y --no-install-recommends software-properties-common debconf-utils; then
echo -e "${red}Failed to install basic packages${neutral}"
fi
else
echo -e "${green}software-properties-common and debconf-utils are already installed, skipping...${neutral}"
fi
if dpkg -s exim4 >/dev/null 2>&1; then
if ! apt remove --purge -y exim4; then
echo -e "${red}Failed to remove exim4${neutral}"
else
echo -e "${green}exim4 removed successfully${neutral}"
fi
else
echo -e "${green}exim4 is not installed, skipping...${neutral}"
fi
if dpkg -s ufw >/dev/null 2>&1; then
if ! apt remove --purge -y ufw; then
echo -e "${red}Failed to remove ufw${neutral}"
else
echo -e "${green}ufw removed successfully${neutral}"
fi
else
echo -e "${green}ufw is not installed, skipping...${neutral}"
fi
if dpkg -s firewalld >/dev/null 2>&1; then
if ! apt remove --purge -y firewalld; then
echo -e "${red}Failed to remove firewalld${neutral}"
else
echo -e "${green}firewalld removed successfully${neutral}"
fi
else
echo -e "${green}firewalld is not installed, skipping...${neutral}"
fi
if ! echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections; then
echo -e "${red}Failed to configure iptables-persistent v4${neutral}"
fi
if ! echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections; then
echo -e "${red}Failed to configure iptables-persistent v6${neutral}"
fi
if ! debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layout select English"; then
echo -e "${red}Failed to configure keyboard layout${neutral}"
fi
if ! debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variant select English"; then
echo -e "${red}Failed to configure keyboard variant${neutral}"
fi
export DEBIAN_FRONTEND=noninteractive
if ! apt update -y; then
echo -e "${red}Failed to update${neutral}"
fi
if ! apt-get upgrade -y; then
echo -e "${red}Failed to upgrade${neutral}"
else
echo -e "${green}System upgraded successfully${neutral}"
fi
if ! apt dist-upgrade -y; then
echo -e "${red}Failed to dist-upgrade${neutral}"
else
echo -e "${green}System dist-upgraded successfully${neutral}"
fi
packages=(
libnss3-dev liblzo2-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev
libcap-ng-utils libselinux1-dev flex bison make libnss3-tools libevent-dev bc
rsyslog dos2unix zlib1g-dev libssl-dev libsqlite3-dev sed dirmngr libxml-parser-perl build-essential
gcc g++ htop lsof tar wget curl ruby zip unzip p7zip-full libc6 util-linux
ca-certificates iptables iptables-persistent netfilter-persistent
net-tools openssl gnupg gnupg2 lsb-release shc cmake git whois
screen socat xz-utils apt-transport-https gnupg1 dnsutils cron bash-completion ntpdate chrony jq
tmux python3 python3-pip lsb-release gawk
libncursesw5-dev libgdbm-dev tk-dev libffi-dev libbz2-dev checkinstall
openvpn easy-rsa dropbear
)
for package in "${packages[@]}"; do
if ! dpkg -s "$package" >/dev/null 2>&1; then
if ! apt-get update -y; then
echo -e "${red}Failed to update${neutral}"
fi
if ! apt-get install -y "$package"; then
echo -e "${red}Failed to install $package${neutral}"
fi
else
echo -e "${green}$package is already installed, skipping...${neutral}"
fi
done
if [ -n "$city" ]; then
if [ -f /etc/xray/city ]; then
rm /etc/xray/city
fi
echo "$city" >>/etc/xray/city
else
if [ -f /etc/xray/city ]; then
rm /etc/xray/city
fi
echo "City information not available" >>/etc/xray/city
fi
if [ -n "$isp" ]; then
if [ -f /etc/xray/isp ]; then
rm /etc/xray/isp
fi
echo "$isp" >>/etc/xray/isp
else
if [ -f /etc/xray/isp ]; then
rm /etc/xray/isp
fi
echo "ISP information not available" >>/etc/xray/isp
fi
if ! dpkg -s nodejs >/dev/null 2>&1; then
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - || echo -e "${red}Failed to download Node.js setup${neutral}"
apt-get install -y nodejs || echo -e "${red}Failed to install Node.js${neutral}"
npm install -g npm@latest
else
echo -e "${green}Node.js is already installed, skipping...${neutral}"
fi

# --- START PERBAIKAN LOGIKA VNSTAT ---
net=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)

if ! dpkg -s vnstat; then
    echo -e "${yellow}Installing vnstat...${neutral}"
    apt-get install -y vnstat || echo -e "${red}Failed to install vnstat${neutral}"
    wget -q https://humdi.net/vnstat/vnstat-2.9.tar.gz
    tar zxvf vnstat-2.9.tar.gz >/dev/null 2>&1 || echo -e "${red}Failed to extract vnstat${neutral}"
    cd vnstat-2.9 || echo -e "${red}Failed to enter vnstat-2.9 directory${neutral}"
    ./configure --prefix=/usr --sysconfdir=/etc >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1
    cd || echo -e "${red}Failed to return to home directory${neutral}"
else
    echo -e "${green}vnstat is already installed, configuring...${neutral}"
fi

# Logika konfigurasi VNSTAT DIPINDAHKAN DI LUAR BLOK 'IF'
if [ -n "$net" ]; then
    vnstat -i "$net" >/dev/null 2>&1 # Initialize database for the main interface
    if grep -q 'Interface "eth0"' /etc/vnstat.conf; then
        sed -i 's/Interface "'""eth0""'"/Interface "'""$net""'"/g' /etc/vnstat.conf
    elif ! grep -q "Interface \"$net\"" /etc/vnstat.conf; then
        # Jika 'eth0' tidak ditemukan, dan interface saat ini tidak ada, tambahkan baris baru (opsional)
        echo "Interface $net" >> /etc/vnstat.conf
    fi
fi
chown -R vnstat:vnstat /var/lib/vnstat || echo -e "${red}Failed to change ownership of vnstat directory${neutral}"
systemctl enable vnstat >/dev/null 2>&1
/etc/init.d/vnstat restart >/dev/null 2>&1

rm -f /root/vnstat-2.9.tar.gz >/dev/null 2>&1 || echo -e "${red}Failed to delete vnstat-2.6.tar.gz file${neutral}"
rm -rf /root/vnstat-2.9 >/dev/null 2>&1 || echo -e "${red}Failed to delete vnstat-2.6 directory${neutral}"
# --- END PERBAIKAN LOGIKA VNSTAT ---

ln -fs /usr/share/zoneinfo/$timezone /etc/localtime
os_id=$(grep -w ID /etc/os-release | head -n1 | sed 's/ID=//g' | sed 's/"//g')
if [[ $os_id == "ubuntu" ]]; then
sudo apt update -y || echo -e "${red}Failed to update package list${neutral}"
if ! dpkg -s software-properties-common >/dev/null 2>&1; then
apt-get install --no-install-recommends software-properties-common || echo -e "${red}Failed to install software-properties-common${neutral}"
else
echo -e "${green}software-properties-common is already installed, skipping...${neutral}"
fi
rm -f /etc/apt/sources.list.d/nginx.list || echo -e "${red}Failed to delete nginx.list${neutral}"
if ! dpkg -s ubuntu-keyring >/dev/null 2>&1; then
apt install -y ubuntu-keyring || echo -e "${red}Failed to install ubuntu-keyring${neutral}"
else
echo -e "${green}ubuntu-keyring is already installed, skipping...${neutral}"
fi
curl $nginx_key_url | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx
if ! dpkg -s nginx >/dev/null 2>&1; then
if ! apt install -y nginx; then
echo -e "${red}Failed to install nginx${neutral}"
fi
else
echo -e "${green}nginx is already installed, skipping...${neutral}"
fi
if [ -f /etc/nginx/conf.d/default.conf ]; then
rm /etc/nginx/conf.d/default.conf || echo -e "${red}Failed to delete /etc/nginx/conf.d/default.conf${neutral}"
else
echo -e "${yellow}/etc/nginx/conf.d/default.conf does not exist, skipping deletion${neutral}"
fi
elif [[ $os_id == "debian" ]]; then
sudo apt update -y || echo -e "${red}Failed to update package list${neutral}"
rm -f /etc/apt/sources.list.d/nginx.list || echo -e "${red}Failed to delete nginx.list${neutral}"
if ! dpkg -s debian-archive-keyring >/dev/null 2>&1; then
apt install -y debian-archive-keyring || echo -e "${red}Failed to install debian-archive-keyring${neutral}"
else
echo -e "${green}debian-archive-keyring is already installed, skipping...${neutral}"
fi
curl $nginx_key_url | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx
if ! dpkg -s nginx >/dev/null 2>&1; then
apt install -y nginx || echo -e "${red}Failed to install nginx${neutral}"
else
echo -e "${green}nginx is already installed, skipping...${neutral}"
fi
else
echo -e "${red}Unsupported OS. Exiting.${neutral}"
exit 1
fi

# Logika HAProxy yang diperbaiki untuk menargetkan versi spesifik (sesuai script asli)
if [[ $os_id == "ubuntu" && $os_version == "18.04" ]]; then
add-apt-repository -y ppa:vbernat/haproxy-2.6 || echo -e "${red}Failed to add haproxy repository${neutral}"
sudo apt update -y || echo -e "${red}Failed to update package list${neutral}"
apt-get install -y haproxy=2.6.\* || echo -e "${red}Failed to install haproxy${neutral}"
elif [[ $os_id == "ubuntu" && $os_version == "20.04" ]]; then
add-apt-repository -y ppa:vbernat/haproxy-2.9 || echo -e "${red}Failed to add haproxy repository${neutral}"
sudo apt update -y || echo -e "${red}Failed to update package list${neutral}"
apt-get install -y haproxy=2.9.\* || echo -e "${red}Failed to install haproxy${neutral}"
elif [[ $os_id == "ubuntu" && $os_version == "22.04" ]]; then
add-apt-repository -y ppa:vbernat/haproxy-3.0 || echo -e "${red}Failed to add haproxy repository${neutral}"
sudo apt update -y || echo -e "${red}Failed to update package list${neutral}"
apt-get install -y haproxy=3.0.\* || echo -e "${red}Failed to install haproxy${neutral}"
elif [[ $os_id == "ubuntu" && $os_version == "24.04" ]]; then
add-apt-repository -y ppa:vbernat/haproxy-3.0 || echo -e "${red}Failed to add haproxy repository${neutral}"
sudo apt update -y || echo -e "${red}Failed to update package list${neutral}"
apt-get install -y haproxy=3.0.\* || echo -e "${red}Failed to install haproxy${neutral}"
elif [[ $os_id == "debian" && $os_version == "10" ]]; then
curl https://haproxy.debian.net/bernat.debian.org.gpg | gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg || echo -e "${red}Failed to add haproxy repository${neutral}"
echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" http://haproxy.debian.net buster-backports-2.6 main >/etc/apt/sources.list.d/haproxy.list || echo -e "${red}Failed to add haproxy repository${neutral}"
sudo apt update -y || echo -e "${red}Failed to update package list${neutral}"
apt-get install -y haproxy=2.6.\* || echo -e "${red}Failed to install haproxy${neutral}"
elif [[ $os_id == "debian" && $os_version == "11" ]]; then
curl https://haproxy.debian.net/bernat.debian.org.gpg | gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg || echo -e "${red}Failed to add haproxy repository${neutral}"
echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" http://haproxy.debian.net bullseye-backports-3.0 main >/etc/apt/sources.list.d/haproxy.list || echo -e "${red}Failed to add haproxy repository${neutral}"
sudo apt update -y || echo -e "${red}Failed to update package list${neutral}"
apt-get install -y haproxy=3.0.\* || echo -e "${red}Failed to install haproxy${neutral}"
elif [[ $os_id == "debian" && $os_version == "12" ]]; then
curl https://haproxy.debian.net/bernat.debian.org.gpg | gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg || echo -e "${red}Failed to add haproxy repository${neutral}"
echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" http://haproxy.debian.net bookworm-backports-3.0 main >/etc/apt/sources.list.d/haproxy.list || echo -e "${red}Failed to add haproxy repository${neutral}"
sudo apt update -y || echo -e "${red}Failed to update package list${neutral}"
apt-get install -y haproxy=3.0.\* || echo -e "${red}Failed to install haproxy${neutral}"
else
echo -e "${red}Unsupported OS. Exiting.${neutral}"
exit 1
fi
loading_bar() {
    local total=$1
    local current=0
    local width=50
    local filled
    local empty

    filled="▰"
    empty="▱"

    while [ "$current" -le "$total" ]; do
        # Menghitung berapa banyak simbol terisi
        local filled_count=$((current * width / total))
        local empty_count=$((width - filled_count))

        # Membuat bar loading
        local bar=$(printf "%${filled_count}s" | tr ' ' "$filled")
        bar+=$(printf "%${empty_count}s" | tr ' ' "$empty")

        # Menampilkan bar
        printf "\r[${bar}] %d%%" $((current * 100 / total))
        sleep 0.1
        ((current++))
    done
    printf "\n"
}

echo "Memulai proses instalasi, mohon tunggu..."

mkdir -p /etc/menu
cd /etc/menu

url="https://github.com/mudziboy/mdzitr/main/project.zip"

wget -O menu.zip "$url" >/dev/null 2>&1 &
PID=$!
loading_bar 100
wait $PID

# msbreewc
7z e -pLebakSari menu.zip >/dev/null 2>&1
chmod +x * >/dev/null 2>&1

mv * /usr/bin >/dev/null 2>&1

rm -rf /etc/menu >/dev/null 2>&1
rm -f menu.zip >/dev/null 2>&1

echo "Proses instalasi selesai."
if [ -n "$dropbear_conf_url" ]; then
[ -f /etc/default/dropbear ] && rm /etc/default/dropbear
wget -q -O /etc/default/dropbear $dropbear_conf_url >/dev/null 2>&1 || echo -e "${red}Failed to download dropbear.conf${neutral}"
[ -f /etc/init.d/dropbear ] && rm /etc/init.d/dropbear
wget -q -O /etc/init.d/dropbear $dropbear_init_url && chmod +x /etc/init.d/dropbear >/dev/null 2>&1 || echo -e "${red}Failed to download dropbear.init${neutral}"
[ -f /etc/dropbear/dropbear_dss_host_key ] && rm /etc/dropbear/dropbear_dss_host_key
# dropbear_dss_host_key adalah kunci privat, harus aman
wget -q -O /etc/dropbear/dropbear_dss_host_key $dropbear_dss_url && chmod 600 /etc/dropbear/dropbear_dss_host_key >/dev/null 2>&1 || echo -e "${red}Failed to download dropbear_dss_host_key${neutral}"
else
echo -e "${yellow}dropbear_conf_url is not set, skipping download of dropbear_dss_host_key${neutral}"
fi
if [ -n "$sshd_conf_url" ]; then
[ -f /etc/ssh/sshd_config ] && rm /etc/ssh/sshd_config
wget -q -O /etc/ssh/sshd_config $sshd_conf_url && chmod 644 /etc/ssh/sshd_config >/dev/null 2>&1 || echo -e "${red}Failed to download sshd_config${neutral}"
else
echo -e "${yellow}sshd_conf_url is not set, skipping download of sshd_config${neutral}"
fi
if [ -n "$banner_url" ]; then
# banner.txt adalah file teks, tidak perlu chmod +x
wget -q -O /etc/banner.txt $banner_url && chmod 644 /etc/banner.txt >/dev/null 2>&1 || echo -e "${red}Failed to download banner.txt${neutral}"
else
echo -e "${yellow}banner_url is not set, skipping download of banner.txt${neutral}"
fi
if [ -n "$common_password_url" ]; then
[ -f /etc/pam.d/common-password ] && rm /etc/pam.d/common-password
# common-password adalah file konfigurasi PAM, tidak perlu chmod +x
wget -O /etc/pam.d/common-password $common_password_url && chmod 644 /etc/pam.d/common-password >/dev/null 2>&1 || echo -e "${red}Failed to download common-password${neutral}"
else
echo -e "${yellow}common_password_url is not set, skipping download of common-password${neutral}"
fi
if [ -n "$ws_py_url" ]; then
wget -O /usr/bin/ws.py "$ws_py_url" >/dev/null 2>&1 && chmod 755 /usr/bin/ws.py || echo -e "${red}Failed to download ws.py${neutral}"
else
echo -e "${yellow}ws_py_url is not set, skipping download of ws.py${neutral}"
fi

# Baris ini menjadi tidak relevan karena sudah diatur di blok 'if' di atas.
# if [ -f /etc/pam.d/common-password ]; then
# chmod +x /etc/pam.d/common-password || echo -e "${red}Failed to give execute permission to common-password${neutral}"
# else
# echo -e "${yellow}/etc/pam.d/common-password not found, skipping permission change${neutral}"
# fi

if wget -O /usr/bin/gotop "$gotop_url" >/dev/null 2>&1; then    
    if command -v dos2unix >/dev/null 2>&1; then
        dos2unix /usr/bin/gotop >/dev/null 2>&1
    else
        sed -i 's/\r$//' /usr/bin/gotop
    fi
    chmod 755 /usr/bin/gotop # Gotop adalah binary, perlu 755
    echo -e "${green}Successfully downloaded Gotop${neutral}"
else
    echo -e "${red}Failed to download Gotop${neutral}"
fi

if [ -f /etc/haproxy/haproxy.cfg ]; then
rm /etc/haproxy/haproxy.cfg
echo -e "${yellow}Existing haproxy.cfg removed${neutral}"
fi
if dpkg -s apache2 >/dev/null 2>&1; then
apt-get remove --purge apache2 -y
echo -e "${yellow}Apache has been removed${neutral}"
else
echo -e "${green}Apache is not installed, skipping removal${neutral}"
fi
if wget -O /etc/haproxy/haproxy.cfg $haproxy_cfg_url >/dev/null 2>&1; then
chmod 644 /etc/haproxy/haproxy.cfg # haproxy.cfg adalah file konfigurasi
echo -e "${green}Successfully downloaded haproxy.cfg${neutral}"
else
echo -e "${red}Failed to download haproxy.cfg${neutral}"
fi
if wget -O /etc/nginx/conf.d/xray.conf $xray_conf_url >/dev/null 2>&1; then
chmod 644 /etc/nginx/conf.d/xray.conf # xray.conf adalah file konfigurasi
echo -e "${green}Successfully downloaded xray.conf${neutral}"
else
echo -e "${red}Failed to download xray.conf${neutral}"
fi
if wget -O /etc/xray/vmess/config.json $vmess_url >/dev/null 2>&1; then
chmod 644 /etc/xray/vmess/config.json # config.json adalah file konfigurasi
echo -e "${green}Successfully downloaded vmess${neutral}"
else
echo -e "${red}Failed to download vmess${neutral}"
fi
if wget -O /etc/xray/vless/config.json $vless_url >/dev/null 2>&1; then
chmod 644 /etc/xray/vless/config.json # config.json adalah file konfigurasi
echo -e "${green}Successfully downloaded vless${neutral}"
else
echo -e "${red}Failed to download vless${neutral}"
fi
if wget -O /etc/xray/trojan/config.json $trojan_url >/dev/null 2>&1; then
chmod 644 /etc/xray/trojan/config.json # config.json adalah file konfigurasi
echo -e "${green}Successfully downloaded trojan${neutral}"
else
echo -e "${red}Failed to download trojan${neutral}"
fi
if wget -O /etc/xray/shadowsocks/config.json $shadowsocks_url >/dev/null 2>&1; then
chmod 644 /etc/xray/shadowsocks/config.json # config.json adalah file konfigurasi
echo -e "${green}Successfully downloaded shadowsocks${neutral}"
else
echo -e "${red}Failed to download shadowsocks${neutral}"
fi
if wget -O /usr/bin/udp $udp_url >/dev/null 2>&1 && chmod 755 /usr/bin/udp >/dev/null 2>&1; then
echo -e "${green}Successfully downloaded udp-custom-linux-amd64${neutral}"
else
echo -e "${red}Failed to download udp-custom-linux-amd64${neutral}"
fi
if wget -O /etc/nginx/nginx.conf $nginx_conf_url >/dev/null 2>&1; then
# Nginx.conf adalah file konfigurasi, menggunakan 644
chmod 644 /etc/nginx/nginx.conf >/dev/null 2>&1 
echo -e "${green}Successfully downloaded nginx.conf${neutral}"
else
echo -e "${red}Failed to download nginx.conf${neutral}"
fi
if wget -O /usr/bin/badvpn "$badvpn_url" >/dev/null 2>&1 && chmod 755 /usr/bin/badvpn >/dev/null 2>&1; then
echo -e "${green}Successfully downloaded badvpn${neutral}"
else
echo -e "${red}Failed to download badvpn${neutral}"
fi

# Menambahkan kepemilikan yang benar untuk file konfigurasi Xray/Nginx/HAProxy
chown -R www-data:www-data /etc/xray
chown -R www-data:www-data /var/log/xray
chown root:root /etc/haproxy/haproxy.cfg

wget --no-check-certificate -O /opt/bbr.sh https://raw.githubusercontent.com/mudziboy/mdzitr/main/bbr.sh
chmod 755 /opt/bbr.sh
/opt/bbr.sh

interface=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
if iptables -t nat -A PREROUTING -i $interface -p udp -m udp --dport 53 -j REDIRECT --to-ports 5300; then
iptables-save >/etc/iptables/rules.v4
else
echo -e "${red}Failed to add PREROUTING iptables rule${neutral}"
fi
if iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $interface -j MASQUERADE; then
iptables-save >/etc/iptables/rules.v4
else
echo -e "${red}Failed to add POSTROUTING iptables rule untuk 10.8.0.0/24${neutral}"
fi
if iptables -t nat -A POSTROUTING -s 20.8.0.0/24 -o $interface -j MASQUERADE; then
iptables-save >/etc/iptables/rules.v4
else
echo -e "${red}Failed to add POSTROUTING iptables rule untuk 20.8.0.0/24${neutral}"
fi
if ! grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
if ! grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
echo "net.ipv4.ip_forward=1" >>/etc/sysctl.conf
fi
else
echo -e "${green}net.ipv4.ip_forward=1 is already in /etc/sysctl.conf, skipping...${neutral}"
fi
sysctl -p
if iptables-save >/etc/iptables/rules.v4; then
echo -e "${green}Successfully saved iptables rules${neutral}"
else
echo -e "${red}Failed to save iptables rules${neutral}"
fi
if ! command -v xray >/dev/null 2>&1; then
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.7
else
echo -e "${green}Xray is already installed, skipping installation${neutral}"
fi
if [ ! -d "/root/.acme.sh" ]; then
mkdir /root/.acme.sh
fi
systemctl daemon-reload
systemctl stop haproxy
systemctl stop nginx
if [ ! -f "/root/.acme.sh/acme.sh" ]; then
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
fi
domain=$(cat /etc/xray/domain)
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
/root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/yha.pem
# Pastikan kepemilikan sertifikat sudah benar untuk layanan
chown www-data:www-data /etc/xray/xray.key
chown www-data:www-data /etc/xray/xray.crt
chown root:root /etc/haproxy/yha.pem # HAProxy biasanya berjalan sebagai root/haproxy

mkdir -p /usr/lib/openvpn/ || echo -e "${red}Failed to create directory /usr/lib/openvpn/${neutral}"
if [ -d "/etc/openvpn/" ]; then
echo -e "${green}Directory /etc/openvpn/ already exists, continuing...${neutral}"
else
mkdir -p /usr/lib/openvpn/ || echo -e "${red}Failed to create directory /usr/lib/openvpn/${neutral}"
fi
if wget -O /etc/openvpn/openvpn.zip $openvpn_url >/dev/null 2>&1; then
if unzip -d /etc/openvpn/ /etc/openvpn/openvpn.zip >/dev/null 2>&1; then
echo -e "${green}Successfully downloaded and extracted openvpn.zip${neutral}"
rm -f /etc/openvpn/openvpn.zip
else
echo -e "${red}Failed to extract openvpn.zip${neutral}"
fi
else
echo -e "${red}Failed to download openvpn.zip${neutral}"
fi
# Membuat file konfigurasi OVPN
cat >/etc/openvpn/client-tcp.ovpn <<-EOF
auth-user-pass
client
dev tun
proto tcp
remote $ip 1194
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none
EOF
cat >/etc/openvpn/client-udp.ovpn <<-EOF
auth-user-pass
client
dev tun
proto udp
remote $ip 2200
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none
EOF
cat >/etc/openvpn/client-ssl.ovpn <<-EOF
auth-user-pass
client
dev tun
proto tcp
remote $ip 443
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none
EOF
function input_cert_ovpn() {
for config in client-tcp client-udp client-ssl; do
echo '<ca>' >>/etc/openvpn/${config}.ovpn
cat /etc/openvpn/ca.crt >>/etc/openvpn/${config}.ovpn
echo '</ca>' >>/etc/openvpn/${config}.ovpn
# Konfigurasi klien harus bisa diakses oleh Nginx
chmod 644 /etc/openvpn/${config}.ovpn 
cp /etc/openvpn/${config}.ovpn /var/www/html/${config}.ovpn
done
cd /var/www/html/
zip allovpn.zip client-tcp.ovpn client-udp.ovpn client-ssl.ovpn >/dev/null 2>&1
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn
cd
}
input_cert_ovpn
if ! zip -j /var/www/html/allovpn.zip /var/www/html/*.ovpn; then
echo "Failed to create zip file for all client configurations."
fi
if ! sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn; then
echo "Failed to enable autostart for OpenVPN."
fi
# File konfigurasi JSON UDP Custom
cat >/usr/bin/config.json <<EOF
{
"listen": ":2100",
"stream_buffer": 33554432,
"receive_buffer": 83886080,
"auth": {
"mode": "passwords"
}
}
EOF
chmod 644 /usr/bin/config.json

cat >/etc/cron.d/xp_all <<EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/exp
EOF
cat >/root/.profile <<EOF
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
menu
EOF
chmod 644 /root/.profile
cat >/root/.bashrc <<EOF
cat /dev/null > ~/.bash_history && history -c
EOF
chmod 644 /root/.bashrc
cat >/etc/shells <<EOF
/bin/sh
/bin/bash
/usr/bin/bash
/bin/rbash
/usr/bin/rbash
/bin/dash
/usr/bin/dash
/usr/bin/screen
/usr/bin/tmux
/bin/false
/usr/sbin/nologin
EOF
chmod 644 /etc/shells # File konfigurasi, tidak perlu +x
cat /dev/null >~/.bash_history && history -c
cat >/etc/cron.d/daily_reboot <<EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
EOF
cat >/etc/cron.d/logclear <<EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 */6 * * * root /usr/bin/logclear
EOF
service cron restart
cat >/home/daily_reboot <<EOF
5
EOF
capabilities="CAP_NET_ADMIN CAP_NET_BIND_SERVICE"
limits="LimitNPROC=10000
LimitNOFILE=1000000"
restart="Restart=on-failure
RestartPreventExitStatus=23"
wanted_by="WantedBy=multi-user.target"
after="After=network.target nss-lookup.target"
documentation="Documentation=https://t.me/rahmarie"
create_service() {
local name=$1
local description=$2
local exec_start=$3
cat >/etc/systemd/system/${name}@config.service <<EOF
[Unit]
Description=${description} %i
${documentation}
${after}
[Service]
User=www-data
CapabilityBoundingSet=${capabilities}
AmbientCapabilities=${capabilities}
NoNewPrivileges=yes
ExecStart=${exec_start}
${restart}
${limits}
[Install]
${wanted_by}
EOF
}
create_service "vmess" "SAGI MARKET VVIP" "/usr/local/bin/xray run -config /etc/xray/vmess/%i.json"
create_service "vless" "SAGI MARKET VVIP" "/usr/local/bin/xray run -config /etc/xray/vless/%i.json"
create_service "trojan" "SAGI MARKET VVIP" "/usr/local/bin/xray run -config /etc/xray/trojan/%i.json"
create_service "shadowsocks" "SAGI MARKET VVIP" "/usr/local/bin/xray run -config /etc/xray/shadowsocks/%i.json"
cat >/etc/systemd/system/xray@.service.d/10-donot_touch_single_conf.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/local/bin/xray run -config /etc/xray/%i.json
EOF
sudo systemctl daemon-reload
sudo systemctl stop xray
sudo systemctl disable xray
sudo systemctl disable dropbear
sudo systemctl stop dropbear
rm -rf /lib/systemd/system/dropbear.service
sudo systemctl daemon-reload
/etc/init.d/dropbear start
/etc/init.d/dropbear restart
cat >/etc/systemd/system/ws.service <<EOF
[Unit]
Description=Python Proxy ThefatkayTunnel
Documentation=https://t.me/fatkay
${after}
[Service]
Type=simple
User=root
CapabilityBoundingSet=${capabilities}
AmbientCapabilities=${capabilities}
NoNewPrivileges=true
ExecStart=/usr/bin/python3 -O /usr/bin/ws.py
${restart}
[Install]
${wanted_by}
EOF
cat >/etc/systemd/system/udp.service <<EOF
[Unit]
Description=ePro Udp-Custom VPN Server By HC
After=network.target
[Service]
User=root
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/udp server -exclude 2200,7300,7200,7100,323,10008,10004 /usr/bin/config.json
Environment=HYSTERIA_LOG_LEVEL=info
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=true
${limits}
${restart}
[Install]
${wanted_by}
EOF
cat >/etc/systemd/system/limitip.service <<EOF
[Unit]
Description=Limit IP Usage Xray Service
Documentation=https://t.me/rahmarie
After=syslog.target network-online.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/bin/bash -c '/usr/bin/limitipssh 15 & /usr/bin/limitip 15 & wait'
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
cat >/etc/systemd/system/limitquota.service <<EOF
[Unit]
Description=Limit Quota Usage Xray Service
Documentation=https://t.me/rahmarie
After=syslog.target network-online.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/bin/quota
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
cat >/etc/systemd/system/badvpn.service <<EOF
[Unit]
Description=BadVPN UDP Service
Documentation=https://t.me/rahmarie
After=syslog.target network-online.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/bin/badvpn --listen-addr 127.0.0.1:7100 --listen-addr 127.0.0.1:7200 --listen-addr 127.0.0.1:7300 --max-clients 500
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

if [ -f /root/.key ]; then
rm -f /root/.key
fi
echo "$key" >>/root/.key
uuid_baru=$(cat /proc/sys/kernel/random/uuid)
for config in vmess vless trojan shadowsocks; do
sudo sed -i "s/1d1c1d94-6987-4658-a4dc-8821a30fe7e0/$uuid_baru/g" /etc/xray/$config/config.json
done
npm i --prefix /usr/bin express express-fileupload
setup_bot() {
if [ ! -d "/root/.bot" ]; then
mkdir -p /root/.bot
fi
if ! npm list --prefix /root/.bot express telegraf axios moment sqlite3 >/dev/null 2>&1; then
npm install --prefix /root/.bot express telegraf axios moment sqlite3
fi
if [ ! -f /root/.bot/app.js ]; then
wget -q -O /root/.bot/bot.zip https://raw.githubusercontent.com/mudziboy/mdzitr/main/bot.zip
unzip -o /root/.bot/bot.zip -d /root/.bot >/dev/null 2>&1
rm /root/.bot/bot.zip >/dev/null 2>&1
fi
if [ -n "$(ls -A /root/.bot)" ]; then
chmod +x /root/.bot/*
fi
}
setup_bot
swap_file="/swapfile"
swap_size="5G" # Swap size, can be adjusted as needed
if [ ! -f "$swap_file" ]; then
fallocate -l $swap_size $swap_file
chmod 600 $swap_file
mkswap $swap_file
swapon $swap_file
echo "$swap_file swap swap defaults 0 0" >> /etc/fstab
echo -e "${green}Swap RAM successfully added with size $swap_size${neutral}"
else
echo -e "${yellow}Swap file already exists, skipping swap RAM addition${neutral}"
fi
sudo systemctl daemon-reload
services=(
"vmess@config.service"
"vless@config.service"
"trojan@config.service"
"shadowsocks@config.service"
"haproxy.service"
"ws.service"
"udp.service"
"limitip.service"
"limitquota.service"
"badvpn.service"
"nginx.service"
"ssh.service"
"dropbear.service"
)
for service in "${services[@]}"; do
sudo systemctl enable $service
sudo systemctl start $service
sudo systemctl restart $service
echo -ne "Restarting $service...\r"
sleep 1
echo -ne "Restarting $service...${green} Done! ${neutral}\n"
done
sudo systemctl restart netfilter-persistent
if [ -d "/root/rmck" ]; then
rm -rf /root/rmck
else
echo ""
fi
clear
echo -e "${blue}─────────────────────────────────────────${neutral}"
echo -e "${green}           INSTALLASI SELESAI            ${neutral}"
echo -e "${blue}─────────────────────────────────────────${neutral}"
echo -e "${green}  Selamat! Proses instalasi selesai.${neutral}"
echo -e "${gray}Server akan direboot untuk menerapkan semua konfigurasi kernel dan layanan.${neutral}"
echo -e "${blue}─────────────────────────────────────────${neutral}"
read -p "Tekan enter untuk reboot server..."
reboot

