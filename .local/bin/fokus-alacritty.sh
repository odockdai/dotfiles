#!/bin/bash

# --- Konfigurasi ---
APP_WM_CLASS="Alacritty"
APP_COMMAND="alacritty"

# --- Logika "Operasi Bedah" (Versi Final) ---

# 1. Cari ID Alacritty yang mungkin sudah terbuka
ALACRITTY_ID=$(kdotool search --class "${APP_WM_CLASS}" | head -n 1)

# 2. Dapatkan daftar SEMUA ID jendela yang sedang aktif di desktop saat ini
#    (Ini adalah baris yang diperbaiki, tanpa --all-desktops)
ALL_WINDOW_IDS=$(kdotool search ".*")

# 3. Loop melalui semua jendela, dan minimize satu per satu JIKA ITU BUKAN ALACRITTY
for WID in $ALL_WINDOW_IDS; do
    if [ "$WID" != "$ALACRITTY_ID" ]; then
        kdotool windowminimize "$WID"
    fi
done

# 4. Setelah semua jendela lain di-minimize, urus Alacritty
if [ -z "$ALACRITTY_ID" ]; then
    # Jika Alacritty belum ada, buka jendela baru
    ${APP_COMMAND} &
else
    # Jika Alacritty sudah ada, pastikan dia aktif dan muncul di depan.
    kdotool windowactivate ${ALACRITTY_ID}
fi
