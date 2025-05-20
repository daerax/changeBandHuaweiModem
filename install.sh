#!/bin/bash

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

if ! command -v git &> /dev/null; then
    echo "Error: git tidak terinstal. Silakan instal git terlebih dahulu."
    exit 1
fi
if ! command -v pip3 &> /dev/null; then
    echo "Error: pip3 tidak terinstal. Silakan instal pip3 terlebih dahulu."
    exit 1
fi

echo -n "Masukkan Telegram BOT TOKEN: "
read -r token
echo -n "Masukkan Telegram CHAT ID: "
read -r chatid

# Validasi input
if [[ ! "$token" =~ ^[A-Za-z0-9:_-]+$ || ! "$chatid" =~ ^[0-9-]+$ ]]; then
    echo "Error: TOKEN atau CHAT ID mengandung karakter tidak valid."
    exit 1
fi

# Periksa dan hapus folder changeBandHuaweiModem jika sudah ada
if [ -d "changeBandHuaweiModem" ]; then
    echo "[*] Folder changeBandHuaweiModem sudah ada. Menghapus folder lama..."
    rm -rf changeBandHuaweiModem
    if [ $? -ne 0 ]; then
        echo "Error: Gagal menghapus folder changeBandHuaweiModem."
        exit 1
    fi
fi

echo "[*] Mengkloning repository..."
git clone https://github.com/daerax/changeBandHuaweiModem.git
cd changeBandHuaweiModem || { echo "Gagal masuk folder repo."; exit 1; }

# Periksa keberadaan file
for file in usr/bin/hgled usr/bin/hgledon huawei.py requirements.txt; do
    if [ ! -f "$file" ]; then
        echo "Error: File $file tidak ditemukan di repository."
        exit 1
    fi
done

echo "[*] Menyesuaikan file hgled..."
sed -i "s|<TOKEN>|${token}|g" usr/bin/hgled
sed -i "s|<CHAT_ID>|${chatid}|g" usr/bin/hgled

echo "[*] Mengecek file lama di /usr/bin/..."
for file in hgled hgledon; do
    if [ -f "/usr/bin/$file" ]; then
        echo "  → Backup $file ke $file.bak"
        cp "/usr/bin/$file" "/usr/bin/$file.bak"
    fi
done

echo "[*] Menyalin file hgled dan hgledon ke /usr/bin/..."
cp usr/bin/hgled /usr/bin/hgled
cp usr/bin/hgledon /usr/bin/hgledon
chmod +x /usr/bin/hgled /usr/bin/hgledon

echo "[*] Menyalin huawei.py dan requirements.txt ke /root/..."
cp huawei.py /root/huawei.py
cp requirements.txt /root/requirements.txt

echo "[*] Menginstall dependensi Python dari /root/requirements.txt..."
pip3 install --upgrade pip
if ! pip3 install -r /root/requirements.txt; then
    echo "Error: Gagal menginstall dependensi Python."
    exit 1
fi

echo "[*] Menjalankan hgled -r..."
if ! hgled -r; then
    echo "Error: Gagal menjalankan hgled -r."
    exit 1
fi

echo "[*] Membersihkan folder sementara..."
cd .. && rm -rf changeBandHuaweiModem

echo "[✓] Instalasi selesai dan semua file sudah ditempatkan di path yang sesuai."
