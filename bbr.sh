#!/usr/bin/env bash
#
# Auto Enable TCP BBR (Stable Version)
# System Required: Debian 9+, Ubuntu 18+
#

# Warna untuk output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

_info() { printf "${GREEN}[Info]${NC} %s\n" "$1"; }
_warn() { printf "${YELLOW}[Warning]${NC} %s\n" "$1"; }
_error() { printf "${RED}[Error]${NC} %s\n" "$1"; exit 1; }

# Pastikan dijalankan sebagai root
[[ $EUID -ne 0 ]] && _error "Script ini harus dijalankan sebagai root (sudo)."

# Cek apakah BBR sudah aktif
check_bbr_status() {
    local status=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
    if [ "$status" == "bbr" ]; then
        return 0
    else
        return 1
    fi
}

# Cek versi kernel (BBR butuh kernel 4.9+)
check_kernel_version() {
    local kernel_ver=$(uname -r | cut -d- -f1)
    # Membandingkan versi kernel secara numerik
    if [[ $(echo -e "$kernel_ver\n4.9" | sort -V | head -n1) == "4.9" ]]; then
        return 0 # Versi mencukupi
    else
        return 1 # Versi terlalu tua
    fi
}

# Konfigurasi sysctl untuk mengaktifkan BBR
apply_bbr_config() {
    _info "Mengonfigurasi sysctl untuk BBR..."
    
    # Hapus konfigurasi lama jika ada agar tidak double
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    
    # Tambahkan konfigurasi baru
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    
    # Terapkan perubahan
    sysctl -p >/dev/null 2>&1
    
    if check_bbr_status; then
        _info "TCP BBR berhasil diaktifkan!"
    else
        _error "Gagal mengaktifkan TCP BBR."
    fi
}

clear
echo "----------------------------------------"
echo "   TCP BBR Auto Installer (Stable)      "
echo "----------------------------------------"
echo " OS      : $(uname -s)"
echo " Kernel  : $(uname -r)"
echo "----------------------------------------"

if check_bbr_status; then
    _info "TCP BBR sudah aktif di sistem kamu. Tidak ada perubahan yang diperlukan."
    exit 0
fi

if check_kernel_version; then
    _info "Versi kernel memadai ($(uname -r))."
    apply_bbr_config
else
    _warn "Kernel kamu terlalu tua. Mencoba mengupdate sistem..."
    # Update repository dan coba install kernel terbaru jika di Debian/Ubuntu
    apt-get update && apt-get install -y --install-recommends linux-generic
    _info "Silakan REBOOT server kamu dan jalankan script ini lagi."
fi

echo "----------------------------------------"
