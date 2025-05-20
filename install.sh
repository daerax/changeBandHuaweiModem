#!/bin/bash

read -p "Masukkan Telegram BOT TOKEN: " token
read -p "Masukkan Telegram CHAT ID: " chatid

echo "[*] Mengkloning repository..."
git clone https://github.com/daerax/changeBandHuaweiModem.git
cd changeBandHuaweiModem || { echo "Gagal masuk folder repo."; exit 1; }

echo "[*] Menyesuaikan file hgled..."
sed -i "21s|.*|token=\"$token\"; chatid=\"$chatid\"|" usr/bin/hgled

echo "[*] Mengecek file lama di /usr/bin/..."
for file in hgled hgledon; do
    if [ -f "/usr/bin/$file" ]; then
        echo "  → Backup $file ke $file.bak"
        sudo cp "/usr/bin/$file" "/usr/bin/$file.bak"
    fi
done

echo "[*] Menyalin file hgled dan hgledon ke /usr/bin/..."
sudo cp usr/bin/hgled /usr/bin/hgled
sudo cp usr/bin/hgledon /usr/bin/hgledon
sudo chmod +x /usr/bin/hgled /usr/bin/hgledon

echo "[*] Menyalin huawei.py dan requirements.txt ke /root/..."
sudo cp huawei.py /root/huawei.py
sudo cp requirements.txt /root/requirements.txt

echo "[*] Menginstall dependensi Python dari /root/requirements.txt..."
pip install --upgrade pip
pip install -r /root/requirements.txt

echo "[*] Menjalankan hgled -r..."
hgled -r

echo "[✓] Instalasi selesai dan semua file sudah ditempatkan di path yang sesuai."
