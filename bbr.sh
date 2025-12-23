#!/usr/bin/env bash
#
# Optimized TCP BBR for Autoscript Setup
# No Reboot Required if Kernel >= 4.9
#

_info() {
    printf "\033[1;32m[Info]\033[0m %b\n" "$1"
}

_warn() {
    printf "\033[1;33m[Warning]\033[0m %b\n" "$1"
}

_error() {
    printf "\033[1;31m[Error]\033[0m %b\n" "$1"
    # Tidak keluar (exit) agar setup.sh tetap lanjut meski BBR gagal
}

# Fungsi cek status BBR
check_bbr_status() {
    sysctl net.ipv4.tcp_congestion_control | grep -q "bbr"
}

# Fungsi cek versi kernel
check_kernel_version() {
    local kernel_ver=$(uname -r | cut -d- -f1)
    # Memeriksa apakah versi >= 4.9
    if [[ $(echo -e "$kernel_ver\n4.9" | sort -V | head -n1) == "4.9" ]]; then
        return 0
    else
        return 1
    fi
}

sysctl_config() {
    _info "Applying TCP BBR configuration..."
    # Hapus baris lama untuk menghindari duplikasi
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    
    # Masukkan konfigurasi BBR
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    
    # Reload sysctl tanpa reboot
    sysctl -p >/dev/null 2>&1
}

# Main Logic
echo "----------------------------------------"
echo "  Checking TCP BBR Compatibility        "
echo "----------------------------------------"

if check_bbr_status; then
    _info "TCP BBR is already enabled."
elif check_kernel_version; then
    _info "Kernel $(uname -r) supports BBR. Enabling now..."
    sysctl_config
    if check_bbr_status; then
        _info "TCP BBR enabled successfully without reboot."
    else
        _warn "Failed to enable BBR. Skipping to continue setup..."
    fi
else
    _warn "Kernel too old ($(uname -r)). BBR requires 4.9+."
    _warn "Skipping BBR installation to avoid setup failure."
fi

echo "----------------------------------------"
