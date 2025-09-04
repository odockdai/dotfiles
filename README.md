# Dotfiles — Cheatsheet (tmux, Alacritty, Neovim)

> Catatan singkat:
>
> - Shell utama: **fish**
> - Terminal: **Alacritty** (TOML)
> - Multiplexer: **tmux** (prefix `Ctrl-a`)
> - Editor: **Neovim** (leader: `Space`)

---

## 🧰 tmux (Prefix: `Ctrl-a`)

| Aksi                              | Shortcut                                                                         |     |
| --------------------------------- | -------------------------------------------------------------------------------- | --- |
| **Prefix**                        | `Ctrl-a`                                                                         |     |
| Split **vertical** (kanan-kiri)   | `Prefix` \`                                                                      | \`  |
| Split **horizontal** (atas-bawah) | `Prefix` `-`                                                                     |     |
| New window (di cwd pane)          | `Prefix` `c`                                                                     |     |
| Reload config                     | `Prefix` `r`                                                                     |     |
| Resize pane                       | `Prefix` `h` / `j` / `k` / `l` (tahan untuk repeat)                              |     |
| Zoom/unzoom pane                  | `Prefix` `m`                                                                     |     |
| Mouse mode                        | Aktif (klik untuk fokus/resize/scroll)                                           |     |
| Navigasi Vim ↔ tmux              | `Ctrl-h` / `Ctrl-j` / `Ctrl-k` / `Ctrl-l` _(butuh vim-tmux-navigator di Neovim)_ |     |

**Tips**: `focus-events on`, `$TERM` dalam tmux `tmux-256color` (RGB aktif), warna truecolor & `autoread` di Neovim bekerja baik.

---

## 🖥️ Alacritty (TOML)

| Aksi                             | Shortcut                          |
| -------------------------------- | --------------------------------- |
| Copy                             | `Ctrl+Shift+C`                    |
| Paste                            | `Ctrl+Shift+V`                    |
| Cari maju / mundur               | `Ctrl+Shift+F` / `Ctrl+Shift+B`   |
| Clear screen / log notice        | `Ctrl+L`                          |
| Scroll PageUp / PageDown         | `Shift+PageUp` / `Shift+PageDown` |
| Scroll ke Top / Bottom           | `Shift+Home` / `Shift+End`        |
| Paste _primary selection_        | Klik tengah (mouse)               |
| Toggle Fullscreen (bila di-bind) | `Alt+Enter`                       |

**Catatan**: Hints URL aktif (klik link langsung), `TERM` default (umumnya `xterm-256color`).

---

## 📝 Neovim

**Leader**: `Space`
**Mode legend**: n = normal, i = insert, v/x = visual, o = operator-pending

### Dasar & Navigasi

| Aksi                          | Mode | Shortcut                  |
| ----------------------------- | ---- | ------------------------- |
| Esc cepat + simpan file       | i    | `jk`                      |
| Bersihkan highlight pencarian | n    | `<leader>nh`              |
| +1 / −1 angka di bawah kursor | n    | `<leader>+` / `<leader>-` |

### Window & Tab

| Aksi                                | Shortcut                    |
| ----------------------------------- | --------------------------- |
| Split **vertikal** / **horizontal** | `<leader>sv` / `<leader>sh` |
| Samakan ukuran split                | `<leader>se`                |
| Tutup split aktif                   | `<leader>sx`                |
| Tab baru / tutup tab                | `<leader>to` / `<leader>tx` |
| Tab berikutnya / sebelumnya         | `<leader>tn` / `<leader>tp` |
| Buka buffer saat ini di tab baru    | `<leader>tf`                |

### File Explorer

| Aksi                | Shortcut     |
| ------------------- | ------------ |
| Toggle explorer     | `<leader>ee` |
| Fokus file saat ini | `<leader>ef` |
| Collapse tree       | `<leader>ec` |
| Refresh tree        | `<leader>er` |

### Telescope (finder)

| Aksi                                   | Shortcut          |
| -------------------------------------- | ----------------- |
| Cari file                              | `<leader>ff`      |
| File terbaru                           | `<leader>fr`      |
| Live grep (cari teks)                  | `<leader>fs`      |
| Grep kata di bawah kursor              | `<leader>fc`      |
| Lihat TODO/FIX/NOTE…                   | `<leader>ft`      |
| Daftar keymaps                         | `<leader>fk`      |
| (Insert mode) turun/naik hasil         | `<C-j>` / `<C-k>` |
| (Insert) kirim ke quickfix (→ Trouble) | `<C-q>`           |
| (Insert) buka di Trouble               | `<C-t>`           |

### LSP (aktif saat server attach)

| Aksi                                  | Shortcut           |
| ------------------------------------- | ------------------ |
| Go to **declaration**                 | `gD`               |
| Go to **definition** (Telescope)      | `gd`               |
| Go to **implementation** (Telescope)  | `gi`               |
| Go to **type definition** (Telescope) | `gt`               |
| **Code action**                       | `<leader>ca` (n/v) |
| **Rename** simbol                     | `<leader>rn`       |
| Diagnostics buffer (Telescope)        | `<leader>D`        |
| Diagnostics baris (float)             | `<leader>d`        |
| Prev / Next diagnostic                | `[d` / `]d`        |

> Go (`gopls`): `usePlaceholders=true`, `staticcheck=true`, `gofumpt=true`. (Bisa ditambah `analyses.unusedparams=true` bila ingin lebih ketat.)

### Git — Gitsigns

| Aksi                             | Shortcut                        |
| -------------------------------- | ------------------------------- |
| Next / Prev **hunk**             | `]h` / `[h`                     |
| Stage / Reset hunk               | `<leader>hs` / `<leader>hr`     |
| Stage / Reset **range (visual)** | (v) `<leader>hs` / `<leader>hr` |
| Stage / Reset **buffer**         | `<leader>hS` / `<leader>hR`     |
| Undo stage hunk                  | `<leader>hu`                    |
| Preview hunk                     | `<leader>hp`                    |
| Blame line (detail)              | `<leader>hb`                    |
| Toggle inline blame              | `<leader>hB`                    |
| Diff this / Diff vs `~`          | `<leader>hd` / `<leader>hD`     |
| Textobject hunk                  | `ih` (o/x)                      |

### Todo Comments

| Aksi             | Shortcut    |
| ---------------- | ----------- |
| Next / Prev TODO | `]t` / `[t` |

### Trouble (diagnostics list, dll.)

| Aksi                      | Shortcut                    |
| ------------------------- | --------------------------- |
| Workspace diagnostics     | `<leader>xw`                |
| File (buffer) diagnostics | `<leader>xd`                |
| Quickfix / Location list  | `<leader>xq` / `<leader>xl` |
| TODOs (via todo-comments) | `<leader>xt`                |

### Formatting & Linting

| Aksi                            | Shortcut           |
| ------------------------------- | ------------------ |
| **Format** file/range (Conform) | `<leader>mp` (n/v) |
| **Lint sekarang** (nvim-lint)   | `<leader>l`        |

### Substitute (ganti teks cepat)

| Aksi                               | Shortcut                               |
| ---------------------------------- | -------------------------------------- |
| Substitute dengan **motion**       | `<leader>r` _(contoh: `<leader>r iw`)_ |
| Substitute satu baris              | `<leader>rr`                           |
| Substitute ke akhir baris          | `<leader>R`                            |
| Substitute di **visual selection** | (v) `<leader>r`                        |

### Flash (lompat cepat)

| Aksi                                | Shortcut  |
| ----------------------------------- | --------- |
| Flash jump                          | `s`       |
| Flash Treesitter                    | `S`       |
| Remote Flash (operator)             | `r` (o)   |
| Treesitter Search (operator/visual) | `R` (o/x) |
| Toggle Flash di command-line search | `<C-s>`   |

### Treesitter Textobjects

| Aksi                          | Shortcut    |
| ----------------------------- | ----------- |
| Assignment outer / inner      | `a=` / `i=` |
| Sisi kiri / kanan assignment  | `l=` / `r=` |
| Property outer / inner (ECMA) | `a:` / `i:` |

### Session (auto-session)

| Aksi                      | Shortcut     |
| ------------------------- | ------------ |
| **Simpan** session (cwd)  | `<leader>ws` |
| **Restore** session (cwd) | `<leader>wr` |

### Git TUI

| Aksi             | Shortcut     |
| ---------------- | ------------ |
| Buka **LazyGit** | `<leader>lg` |

### Maximizer

| Aksi                  | Shortcut     |
| --------------------- | ------------ |
| Toggle maximize split | `<leader>sm` |

### Completion (nvim-cmp — insert mode)

| Aksi              | Shortcut                     |
| ----------------- | ---------------------------- |
| Munculkan menu    | `<C-Space>`                  |
| Pilih next / prev | `<C-j>` / `<C-k>`            |
| Scroll docs       | `<C-b>` / `<C-f>`            |
| Tutup menu        | `<C-e>`                      |
| Confirm pilihan   | `<CR>` _(tanpa auto-select)_ |

---
