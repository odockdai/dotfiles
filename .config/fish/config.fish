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
