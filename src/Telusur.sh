#!/bin/bash
# [Telusur.sh]
# Cari File dan Folder yang Disembunyikan

function menampilkan_banner() {
	clear
	echo "==========================================="
	echo "           ╔╦╗╔═╗╦  ╦ ╦╔═╗╦ ╦╦═╗           "
	echo "            ║ ║╣ ║  ║ ║╚═╗║ ║╠╦╝           "
	echo "            ╩ ╚═╝╩═╝╚═╝╚═╝╚═╝╩╚═           "
	echo "  Cari File dan Folder yang Disembunyikan  "
	echo "              Dalam Direktori              "
	echo "                                           "
	echo "   https://github.com/fixploit03/telusur   "
	echo "==========================================="
	echo ""
}

function masukkan_nama_direktori() {
	while true; do
		read -p "[#] Masukkan nama direktori: " direktori
		echo "[*] Mengecek direktori '${direktori}'..."
		sleep 3
		if [[ ! -d "${direktori}" ]]; then
			echo "[-] Direktori '${direktori}' tidak ditemukan. Coba lagi."
		else
			echo "[+] Direktori '${direktori}' ditemukan."
			break
		fi
	done
}

function mencari_file_dan_folder() {
	echo "[*] Mencari seluruh file dan folder yang disembunyikan dalam direktori '${direktori}'..."
	sleep 3
	echo ""

	cari=($(find "${direktori}" -name ".*" 2>/dev/null))

	if [[ "${#cari[@]}" -gt 0 ]]; then
		jumlah_file=0
		jumlah_folder=0
                waktu=$(date +"%d-%m-%Y_%H-%M-%S")
		folder_utama="hasil_pencarian"
		folder_hasil="${folder_utama}_${waktu}"

		# folder utama
                if [[ ! -d "${folder_utama}" ]]; then
                        mkdir -p "${folder_utama}"
                fi
		cd "${folder_utama}"

		# folder hasil
                if [[ ! -d "${folder_hasil}" ]]; then
                        mkdir -p "${folder_hasil}"
                fi
		cd "${folder_hasil}"

		# pindah ke folder utama '/hasil/utama'
		cd ../../

		nama_file="${folder_utama}/${folder_hasil}/${folder_hasil}.csv"

                touch "${nama_file}"
		echo "No, Jenis, Nama, Ukuran" >> "${nama_file}"

		counter=1

		for isi_direktori in "${cari[@]}"; do

			# Mendapatkan ukuran file dalam byte
			ukuran_byte=$(stat -c%s "${isi_direktori}" 2>/dev/null)

			# Menentukan satuan yang sesuai
			if [[ "${ukuran_byte}" -lt 1024 ]]; then
			    ukuran="${ukuran_byte} B"
			elif [[ "${ukuran_byte}" -lt $((1024 * 1024)) ]]; then
			    ukuran_kb=$(echo "scale=2; ${ukuran_byte} / 1024" | bc)
			    ukuran="${ukuran_kb} KB"
			elif [[ "${ukuran_byte}" -lt $((1024 * 1024 * 1024)) ]]; then
			    ukuran_mb=$(echo "scale=2; ${ukuran_byte} / 1024 / 1024" | bc)
			    ukuran="${ukuran_mb} MB"
			else
			    ukuran_gb=$(echo "scale=2; ${ukuran_byte} / 1024 / 1024 / 1024" | bc)
			    ukuran="${ukuran_gb} GB"
			fi

			if [[ -f "${isi_direktori}" ]]; then
				echo "[+] [File] '${isi_direktori}' [${ukuran}]"
				echo "${counter}, File, ${isi_direktori}, ${ukuran}" >> "${nama_file}"
				((jumlah_file+=1))
				((counter+=1))
			elif [[ -d "${isi_direktori}" ]]; then
                                echo "[+] [Folder] '${isi_direktori}' [${ukuran}]"
				echo "${counter}, Folder, ${isi_direktori}, ${ukuran}" >> "${nama_file}"
				((jumlah_folder+=1))
				((counter+=1))
			fi
		done

		echo ""
                echo "" >> "${nama_file}"
		echo "[+] Jumlah file yang disembunyikan: ${jumlah_file}"
                echo "[+] Jumlah folder yang disembunyikan: ${jumlah_folder}"
                echo "[+] Hasil pencarian disimpan di: ${nama_file}"
	else
		echo "[-] Tidak ada file atau folder tersembunyi yang ditemukan dalam '${direktori}'."
	fi
}

function main() {
	menampilkan_banner
	masukkan_nama_direktori
	mencari_file_dan_folder
}

main