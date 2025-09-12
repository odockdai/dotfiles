#!/bin/bash

# --- Konfigurasi (Berdasarkan file .desktop) ---
APP_WM_CLASS="crx_cinhimbnkkaeohfgghhklpknlkffjgod"
APP_COMMAND="/opt/brave-bin/brave --profile-directory=Default --app-id=cinhimbnkkaeohfgghhklpknlkffjgod"

# --- Logika kdotool (untuk KDE Plasma) ---

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
