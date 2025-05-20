## Indikator LED
🟢: Terhubung ke internet &emsp; 🔴🔴: Tidak terhubung ke internet.

## Pemantauan Koneksi
Jika koneksi internet terputus selama 10 detik sebanyak 5 kali berturut-turut, skrip akan menjalankan file Python untuk me-restart band pada modem Huawei.

## Notifikasi
Setelah koneksi internet kembali terhubung, sistem akan secara otomatis mengirimkan notifikasi melalui bot Telegram bahwa internet telah kembali terhubung.

## Installasi
```bash
curl -sL https://raw.githubusercontent.com/daerax/changeBandHuaweiModem/main/install.sh | bash
```

## Disclaimer
- Tools ini merupakan hasil modifikasi ringan dari project milik [@lutfailham96](https://github.com/lutfailham96/s905x-gpio).
- Semua kredit tetap diberikan kepada pemilik asli repository sebagai pembuat awal.
- Perubahan yang dilakukan hanya untuk menyesuaikan dengan kebutuhan pribadi, tanpa mengubah struktur utama dari tools aslinya.
