function update_system
    set -l ts (date +%Y%m%d-%H%M%S)

    # --- Preflight -----------------------------------------------------------
    echo (set_color green)"--> Preflight checks..."(set_color normal)

    # sudo cache
    sudo -v; or begin
        echo (set_color red)"Gagal mendapat sudo."(set_color normal); return 1
    end

    # tool yang dibutuhkan
    for tool in reflector yay paccache snapper curl
        type -q $tool; or begin
            echo (set_color red)"Tool '$tool' belum terpasang."(set_color normal)
            return 1
        end
    end

    # konektivitas internet & mirror kecil
    curl -m 5 -Is https://mirror.cachyos.org/ >/dev/null; or begin
        echo (set_color red)"Mirror CachyOS tidak terjangkau saat ini."(set_color normal)
        return 1
    end

    # pacman lock
    if test -e /var/lib/pacman/db.lck
        echo (set_color red)"Pacman sedang terkunci (/var/lib/pacman/db.lck)."(set_color normal)
        return 1
    end

    # --- Snapshot pre-update -------------------------------------------------
    echo (set_color green)"--> (1/8) Membuat snapshot pre-update..."(set_color normal)
    set -l snap_pre (sudo snapper -c root create -d "pre-update $ts"; or echo "")

    # --- Rank mirrors --------------------------------------------------------
    echo (set_color green)"--> (2/8) Merangking mirror..."(set_color normal)
    # Indonesia + fallback Asia; umur <= 24 jam; 20 tercepat
    sudo reflector --country Indonesia,Japan,Singapore,Malaysia \
        --age 24 --latest 20 --sort rate \
        --save /etc/pacman.d/mirrorlist; or echo (set_color yellow)"Reflector gagal, lanjut dengan mirror saat ini."(set_color normal)

    # --- Full upgrade (pacman + AUR) ----------------------------------------
    echo (set_color green)"--> (3/8) Melakukan full upgrade (yay -Syu)..."(set_color normal)
    # tanpa --noconfirm agar kamu tetap bisa lihat perubahan penting
    yay -Syu; or begin
        echo (set_color red)"Upgrade gagal. Coba cek output di atas."(set_color normal)
        return 1
    end

    # --- Log ringkas paket berubah ------------------------------------------
    echo (set_color green)"--> (4/8) Menyimpan log ringkas..."(set_color normal)
    set upgrade_log "$HOME/cachyos-updates-"$ts".log"
    awk '/(upgraded|installed|removed)/ {print $0}' /var/log/pacman.log | tail -n 200 > "$upgrade_log"
    echo "Log upgrade: $upgrade_log"

    # --- Bersihkan cache -----------------------------------------------------
    echo (set_color green)"--> (5/8) Bersihkan cache paket..."(set_color normal)
    # simpan 3 versi terakhir yang terpasang
    sudo paccache -rk 3
    # buang cache paket yang sudah tidak terpasang
    sudo paccache -ruk0

    # --- Orphan deps ---------------------------------------------------------
    echo (set_color green)"--> (6/8) Cek dependencies yatim..."(set_color normal)
    set -l orphans (pacman -Qtdq ^/dev/null)
    if test -n "$orphans"
        echo (set_color yellow)"Ditemukan orphans:"(set_color normal)
        printf "%s\n" $orphans
        read -n1 -P "Hapus orphans ini? (y/N) " resp; echo
        if string match -qr "^[Yy]$" -- $resp
            sudo pacman -Rns $orphans
        end
    else
        echo "Tidak ada orphans."
    end

    # --- Pacnew / Pacsave ----------------------------------------------------
    echo (set_color green)"--> (7/8) Cek .pacnew/.pacsave..."(set_color normal)
    set -l pacnew_list (sudo pacdiff --output 2>/dev/null)
    if test -n "$pacnew_list"
        set backup_dir "$HOME/pacnew_backups"
        mkdir -p "$backup_dir"
        for f in $pacnew_list
            set base (basename $f)
            sudo cp "$f" "$backup_dir/$base-$ts"
        end
        echo (set_color yellow)"File .pacnew/.pacsave dibackup ke: $backup_dir"(set_color normal)

        read -n1 -P "Buka menu restore sekarang? (y/N) " r; echo
        if string match -qr "^[Yy]$" -- $r
            restore_pacnew
        else
            echo "Nanti bisa jalankan: restore_pacnew"
        end
    else
        echo "Tidak ada .pacnew/.pacsave."
    end

    # --- Snapshot post-update ------------------------------------------------
    echo (set_color green)"--> (8/8) Membuat snapshot post-update..."(set_color normal)
    sudo snapper -c root create -d "post-update $ts"

    echo (set_color cyan)"✅ Selesai. Sistem ter-update dan dibersihkan."(set_color normal)
end
