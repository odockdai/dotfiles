function restore_pacnew
    set backup_dir "$HOME/pacnew_backups"
    if not test -d "$backup_dir"
        echo "Folder backup tidak ditemukan di $backup_dir"
        return 1
    end

    set backups (ls -1t "$backup_dir")
    if test -z "$backups"
        echo "Tidak ada backup tersedia."
        return 1
    end

    echo "Backup tersedia:"
    for i in (seq (count $backups))
        echo "$i) $backups[$i]"
    end

    read -P "Masukkan nomor backup untuk di-restore (atau 0 untuk batal): " choice
    if test "$choice" -eq 0
        echo "Restore dibatalkan."
        return 0
    end

    if test "$choice" -lt 1 -o "$choice" -gt (count $backups)
        echo "Pilihan tidak valid."
        return 1
    end

    set backup_file $backups[$choice]
    set original_name (string split -r -m 1 -- - "$backup_file")[1]
    set original_path "/etc/$original_name"

    if test -f "$backup_dir/$backup_file"
        echo "Me-restore $backup_file ke $original_path"
        sudo cp "$backup_dir/$backup_file" "$original_path"
        echo "Restore selesai."
    else
        echo "File backup tidak ditemukan."
        return 1
    end
end
