#!/bin/bash

# --- Konfigurasi ---
APP_WM_CLASS="org.kde.dolphin"
APP_COMMAND="dolphin"

# --- Logika Modern dengan kdotool (untuk Plasma 6) ---

# Cari jendela berdasarkan WM_CLASS.
WINDOW_ID=$(kdotool search --class "${APP_WM_CLASS}" | head -n 1)

# Cek apakah ID ditemukan
if [ -z "$WINDOW_ID" ]; then
    # Jika tidak, jalankan perintah untuk membuka aplikasi baru
    ${APP_COMMAND} &
else
    # Jika ya, aktifkan jendela tersebut menggunakan ID-nya
    kdotool windowactivate ${WINDOW_ID}
fi
