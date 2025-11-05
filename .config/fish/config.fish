# ==============================================================================
# Konfigurasi Dasar CachyOS
# ==============================================================================
# Selalu letakkan di paling atas.
source /usr/share/cachyos-fish-config/cachyos-config.fish  # [cite: 1]

# ==============================================================================
# Environment Variables
# ==============================================================================
# Editor default untuk program lain (git, dll).
set -x EDITOR nvim

# Tambahkan path pnpm (idempotent).
fish_add_path ~/.local/share/pnpm

# ==============================================================================
# Inisialisasi Tools
# ==============================================================================
# Pola `... | source` adalah cara standar yang direkomendasikan developer.

# Starship Prompt
starship init fish | source

# Zoxide (navigasi direktori cerdas)
zoxide init fish | source

# FNM (Fast Node Manager)
fnm env --use-on-cd | source

# ==============================================================================
# Fungsi Kustom
# ==============================================================================

# Kosongkan greeting bawaan Fish agar startup bersih.
function fish_greeting
    # dibiarkan kosong dengan sengaja
end

# Fungsi `y`:
# Buka Yazi dan pindahkan direktori terminal ke lokasi terakhir saat Yazi ditutup.
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Fungsi for atau pengulangan
function runfor
    # 1. Tanya berapa kali pengulangan dan bersihkan input
    read -P "Mau diulang berapa kali? (misal: 5): " loop_count
    
    # Bersihkan spasi di awal/akhir
    set -l cleaned_loop_count (string trim $loop_count)

    # Cek apakah input adalah angka integer positif
    if not string match -r '^[0-9]+$' "$cleaned_loop_count"
        echo "Error: Jumlah pengulangan harus berupa angka (integer)."
        return 1
    end
    
    # Cek apakah nilai angka lebih besar dari nol
    if test (math $cleaned_loop_count) -le 0
        echo "Error: Jumlah pengulangan harus lebih besar dari nol."
        return 1
    end
    
    set loop_count $cleaned_loop_count # Gunakan nilai yang sudah valid

    # 2. Tanya rentang waktu tunggu (menit)
    read -P "Masukkan rentang waktu tunggu random (menit, misal: 10-40): " sleep_range
    
    # Pisahkan angka min dan max dari input (misal: 10-40)
    if not set -l min_max (echo $sleep_range | string split --max 2 -)
        echo "Error: Format rentang waktu tunggu salah. Gunakan format MIN-MAX (misal: 10-40)."
        return 1
    end
    
    # [PERBAIKAN KRUSIAL] Gunakan string trim untuk memastikan hanya angka murni yang diproses
    set -l min_sleep (string trim $min_max[1])
    set -l max_sleep (string trim $min_max[2])

    # Cek validitas angka sleep
    if not math --query "$min_sleep >= 0 and $max_sleep > $min_sleep" 2>/dev/null
        echo "Error: Rentang waktu tunggu tidak valid. Pastikan MIN >= 0 dan MAX > MIN (angka)."
        return 1
    end

    # 3. Tanya command yang akan diulang
    read -P "Masukkan command yang akan diulang: " loop_command
    
    if test -z "$loop_command"
        echo "Error: Command tidak boleh kosong."
        return 1
    end

    echo "--- Memulai pengulangan $loop_count kali ---"
    
    for i in (seq $loop_count)
        echo ""
        echo "--- Iterasi $i dari $loop_count: Menjalankan command... ---"
        
        # Eksekusi command
        eval "$loop_command"
        
        # Cek apakah perlu sleep (tidak perlu setelah iterasi terakhir)
        if test $i -lt $loop_count
            # Generate angka acak dalam rentang
            set -l random_minutes (random $min_sleep $max_sleep)
            
            echo "Akan menunggu secara acak selama $random_minutes menit ($min_sleep-$max_sleep)..."
            sleep $random_minutes\m
        end
    end

    echo ""
    echo "--- Selesai. Total $loop_count iterasi telah selesai. ---"
end

# ==============================================================================
# Alias
# ==============================================================================

# Shortcut untuk kembali ke direktori home.
# alias home "cd ~"

# ==============================================================================
# pyenv
# ==============================================================================

# Root pyenv (user-local)
set -Ux PYENV_ROOT $HOME/.pyenv

# Pastikan shims ada di depan PATH, lalu bin pyenv.
fish_add_path -p $PYENV_ROOT/shims
fish_add_path $PYENV_ROOT/bin

# Inisialisasi pyenv
pyenv init - | source

# Inisialisasi pyenv-virtualenv (jika tersedia)
if test -e (pyenv root)/plugins/pyenv-virtualenv/etc/pyenv.fish
    source (pyenv root)/plugins/pyenv-virtualenv/etc/pyenv.fish
end


# opencode
fish_add_path /home/irfan/.opencode/bin

# claude
fish_add_path /home/irfan/.local/bin/claude
