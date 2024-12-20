#!/bin/bash
# [instal.sh]
# Skrip untuk menginstal Telusur secara otomatis

# Fungsi untuk mengecek root
function cek_root(){
        if [[ "$EUID" -ne 0 ]]; then
                echo "[-] Skrip ini harus dijalankan sebagai root!"
                exit 1
        fi
}

# Fungsi untuk mengecek sistem operasi
function cek_sistem_operasi(){
        # Sistem operasi
        so=$(uname -o)

        # Android (Termux)
        if [[ "${so}" == "Android" ]]; then
                :
        # Linux (Debian/Ubuntu)
        elif [[ "${so}" == "GNU/Linux" ]]; then
                cek_root
        fi

}

# Funsi untuk menampilkan banner
function menampilkan_banner(){
        echo "Selamat datang di menu instalasi Telusur"
        echo ""
}

# Fungsi untuk konfirmasi apakah mau instal atau tidak
function konfirmasi(){
        while true; do
                read -p "[#] Apakah Anda ingin menginstal Telusur [Y/n]: " nanya
                if [[ "${nanya}" == "y" || "${nanya}" == "Y" ]]; then
                        instal_telusur
                        exit 0
                elif [[ "${nanya}" == "n" || "${nanya}" == "N" ]]; then
                        echo "[*] Semoga harimu menyenangkan ^_^"
                        exit 0
                else
                        echo "[-] Masukkan tidak valid"
                        continue
                fi
        done
}

# Fungsi untuk menginstal Telusur
function instal_telusur(){
        # File
        file="src/telusur"
        if [[ ! -f "${file}" ]]; then
                echo "[-] File '${file}' tidak ditemukan."
                exit 1
        fi

        chmod +x "${file}"

        # Sistem operasi
        so=$(uname -o)

        if [[ "${so}" == "Android" ]]; then
                instal_termux
        elif [[ "${so}" == "GNU/Linux" ]]; then
                instal_linux
        fi
}

# Fungsi untuk menginstal Telusur di Termux
instal_termux(){
        path="/data/data/com.termux/files/usr/bin"
        echo "[*] Menginstal Telusur..."
        sleep 3
        cp "${file}" "${path}"
        echo "[+] Telusur berhasil diinstal."
        sleep 1
        echo "[+] Ketikkan 'telusur' untuk menjalankannya."
}

# Fungsi untuk menginstal Telusur di Linux
instal_linux(){
        # Memanggil fungsi cek_root
        cek_root
        path="/usr/bin"
        echo "[*] Menginstal Telusur..."
        sleep 3
        mv "${file}" "${path}"
        echo "[+] Telusur berhasil diinstal."
        sleep 1
        echo "[+] Ketikkan 'telusur' untuk menjalankannya."

}

# Fungsi main (utama)
function main(){
        cek_sistem_operasi
        menampilkan_banner
        konfirmasi
        instal_telusur
}

# Memanggil fungsi main
main
