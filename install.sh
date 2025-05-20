#!/bin/bash

read -p "Masukkan Telegram BOT TOKEN: " token
read -p "Masukkan Telegram CHAT ID: " chatid

echo "[*] Mengkloning repository..."
git clone https://github.com/daerax/changeBandHuaweiModem.git
cd changeBandHuaweiModem || { echo "Gagal masuk folder repo."; exit 1; }

echo "[*] Mengedit isi file hgled..."
sed -i "21s|.*|token=\"$token\"; chatid=\"$chatid\"|" usr/bin/hgled

echo "[*] Mengecek file lama di /usr/bin/..."
if [ -f /usr/bin/hgled ]; then
    echo "  → Backup hgled ke hgled.bak"
    sudo cp /usr/bin/hgled /usr/bin/hgled.bak
fi

if [ -f /usr/bin/hgledon ]; then
    echo "  → Backup hgledon ke hgledon.bak"
    sudo cp /usr/bin/hgledon /usr/bin/hgledon.bak
fi

echo "[*] Menyalin file baru ke /usr/bin/..."
sudo cp usr/bin/hgled /usr/bin/hgled
sudo cp usr/bin/hgledon /usr/bin/hgledon
sudo chmod +x /usr/bin/hgled
sudo chmod +x /usr/bin/hgledon

echo "[*] Menjalankan script dengan hgled -r..."
hgled -r

echo "[✓] Instalasi selesai dan script telah dijalankan!"