#!/bin/bash
# [instal.sh]
# Skrip untuk menginstal Telusur secara otomatis

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
	path="/data/data/com.termux/files/usr/bin"
	echo "[*] Menginstal Telusur..."
	sleep 3
	cp "${file}" "${path}"
	echo "[+] Telusur berhasil diinstal."
	sleep 1
	echo "[+] Ketikkan 'telusur' untuk menjalankannya."
elif [[ "${so}" == "GNU/Linux" ]]; then

	if [[ "$EUID" -ne 0 ]]; then
		echo "[-] Skrip ini harus dijalankan sebagai root!"
		exit 1
	fi

	path="/usr/bin"
	echo "[*] Menginstal Telusur..."
	sleep 3
	mv "${file}" "${path}"
	echo "[+] Telusur berhasil diinstal."
	sleep 1
	echo "[+] Ketikkan 'telusur' untuk menjalankannya."
fi
