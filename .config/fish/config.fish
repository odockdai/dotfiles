# ------------------------------------------------------------------------------
# Konfigurasi Dasar CachyOS
# ------------------------------------------------------------------------------
# Memuat konfigurasi dasar dari CachyOS. Sebaiknya selalu di paling atas.
source /usr/share/cachyos-fish-config/cachyos-config.fish [cite: 1]


# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------
# Mengatur editor default yang akan digunakan oleh program lain (git, dll).
set -x EDITOR nvim

# Menambahkan path pnpm ke environment variable PATH.
# `fish_add_path` adalah cara Fish yang paling efisien dan aman (idempotent).
fish_add_path ~/.local/share/pnpm


# ------------------------------------------------------------------------------
# Inisialisasi Tools
# ------------------------------------------------------------------------------
# Pola `... | source` adalah cara standar yang direkomendasikan developer.
# Inisialisasi Starship Prompt
starship init fish | source 

# Inisialisasi Zoxide (navigasi direktori cerdas)
zoxide init fish | source 

# Inisialisasi FNM (Fast Node Manager)
fnm env --use-on-cd | source 


# ------------------------------------------------------------------------------
# Fungsi Kustom
# ------------------------------------------------------------------------------
# Mengosongkan greeting bawaan Fish agar startup lebih bersih.
function fish_greeting
    # Dibiarkan kosong dengan sengaja
end

# Fungsi 'y': Buka Yazi, dan pindah direktori terminal setelah keluar.
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# ------------------------------------------------------------------------------
# Alias (Shortcut Perintah)
# ------------------------------------------------------------------------------
# Shortcut untuk 'pulang' ke direktori home.
alias home "cd ~"

# Setting pyenv
# --- pyenv setup ---
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path -p $PYENV_ROOT/shims
fish_add_path $PYENV_ROOT/bin

# init pyenv
pyenv init - | source

# init pyenv-virtualenv hanya kalau file-nya ada
if test -e (pyenv root)/plugins/pyenv-virtualenv/etc/pyenv.fish
    source (pyenv root)/plugins/pyenv-virtualenv/etc/pyenv.fish
end

