#!/bin/bash

# --- Konfigurasi ---
APP_WINDOW_NAME="YouTube Music"
APP_COMMAND="/opt/brave-bin/brave --profile-directory=Default --app-id=cinhimbnkkaeohfgghhklpknlkffjgod"

# --- Logika kdotool (Mencari berdasarkan NAMA JENDELA) ---
# Kita gunakan --name sesuai hasil tes kita yang berhasil
WINDOW_ID=$(kdotool search --name "${APP_WINDOW_NAME}" | head -n 1)

# Cek apakah ID ditemukan
if [ -z "$WINDOW_ID" ]; then
    # Jika tidak, jalankan perintah untuk membuka aplikasi baru
    ${APP_COMMAND} &
else
    # Jika ya, aktifkan jendela tersebut menggunakan ID-nya
    kdotool windowactivate ${WINDOW_ID}
fi
