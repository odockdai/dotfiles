function update_system --description 'Safe full system upgrade + cleanup + snapshots (CachyOS/Arch)'

    # -------------------- Settings --------------------
    set -l TS (date +%Y%m%d-%H%M%S)
    set -l LOG "$HOME/cachyos-updates-"$TS".log"
    set -l MIRROR_COUNTRIES "Indonesia,Japan,Singapore,Malaysia"
    set -l SAVE_PKG_VERSIONS 3

    # -------------------- Helpers ---------------------
    function _ok;    echo (set_color green)$argv(set_color normal); end
    function _warn;  echo (set_color yellow)$argv(set_color normal); end
    function _err;   echo (set_color red)$argv(set_color normal); end

    function _need --argument-names cmd
        type -q $cmd; or begin
            _err "Tool '$cmd' tidak ditemukan. Pasang dulu."
            return 1
        end
    end

    function _confirm --argument-names prompt
        read -P $prompt' [y/N] ' -n 1 ans; echo
        if string match -qr '^[Yy]$' -- $ans
            return 0
        else
            return 1
        end
    end

    # -------------------- Preflight -------------------
    _ok "--> Preflight checks..."
    for t in sudo reflector yay paccache snapper curl awk
        _need $t; or return 1
    end

    # cache sudo; fail early jika password salah
    sudo -v; or begin
        _err "Gagal mendapatkan hak sudo."
        return 1
    end

    # konektivitas internet (mirror utama CachyOS)
    curl -m 5 -Is https://mirror.cachyos.org/ >/dev/null; or begin
        _err "Mirror CachyOS tidak dapat diakses saat ini."
        return 1
    end

    # pacman lock
    if test -e /var/lib/pacman/db.lck
        _err "Pacman terkunci: /var/lib/pacman/db.lck. Tutup manajer paket lain terlebih dahulu."
        return 1
    end

    # -------------------- Snapshot pre ----------------
    _ok "--> (1/8) Membuat snapshot pre-update..."
    set -l SNAP_PRE_ID (sudo snapper -c root create --print-number -d "pre-update $TS" 2>/dev/null)
    set -l RC $status
    if test $RC -eq 0
      _ok "Snapshot pre-update dibuat (ID #$SNAP_PRE_ID)."
    else
      _warn "Snapshot pre-update gagal (lanjut tanpa snapshot)."
    end

    # -------------------- Mirrors ---------------------
    _ok "--> (2/8) Merangking mirror (reflector)..."
    # Tidak fatal kalau gagal; pakai mirrorlist yang ada
    sudo reflector \
        --country $MIRROR_COUNTRIES \
        --age 24 --latest 20 --sort rate \
        --save /etc/pacman.d/mirrorlist \
        2>/dev/null; or _warn "Reflector gagal; memakai mirrorlist saat ini."

    # -------------------- Upgrade ---------------------
    _ok "--> (3/8) Full upgrade (yay -Syu)..."
    yay -Syu
    or begin
        _err "Upgrade gagal. Lihat output di atas."
        return 1
    end

    # -------------------- Log ringkas -----------------
    _ok "--> (4/8) Menyimpan log ringkas ke: $LOG"
    # Ambil entri terbaru yang relevan dari pacman.log
    awk '/(installed|upgraded|downgraded|removed)/ {print $0}' /var/log/pacman.log | tail -n 400 > "$LOG"

    # -------------------- Bersihkan cache -------------
    _ok "--> (5/8) Bersihkan cache paket..."
    sudo paccache -rk $SAVE_PKG_VERSIONS
    sudo paccache -ruk0

    # -------------------- Orphans ---------------------
    _ok "--> (6/8) Cek dependencies yatim (orphans)..."
    set -l ORPHANS (pacman -Qtdq 2>/dev/null)
    if test -n "$ORPHANS"
        _warn "Ditemukan orphans:"
        printf "%s\n" $ORPHANS
        if _confirm "Hapus orphans tersebut?"
            sudo pacman -Rns $ORPHANS
        else
            _warn "Lewati penghapusan orphans."
        end
    else
        echo "Tidak ada orphans."
    end

    # -------------------- pacnew/pacsave --------------
    _ok "--> (7/8) Deteksi .pacnew/.pacsave..."
    # pacdiff (dari pacman-contrib) menuliskan daftar file jika ada
    set -l PACNEW_LIST (sudo pacdiff --output 2>/dev/null)
    if test -n "$PACNEW_LIST"
        set -l BDIR "$HOME/pacnew_backups"
        mkdir -p "$BDIR"
        for f in $PACNEW_LIST
            set -l base (basename $f)
            sudo cp "$f" "$BDIR/$base-$TS"
        end
        _warn "Backup pacnew/pacsave disalin ke: $BDIR"
        if functions -q restore_pacnew
            if _confirm "Buka menu restore_pacnew sekarang?"
                restore_pacnew
            else
                echo "Kamu bisa jalankan: restore_pacnew  (kapan saja)"
            end
        else
            _warn "Fungsi restore_pacnew tidak ditemukan. Lewati langkah ini."
        end
    else
        echo "Tidak ada .pacnew/.pacsave."
    end

    # -------------------- Snapshot post ---------------
    _ok "--> (8/8) Membuat snapshot post-update..."
    sudo snapper -c root create -d "post-update $TS" >/dev/null
    _ok "✅ Selesai. Sistem ter-update. Log: $LOG"
end
