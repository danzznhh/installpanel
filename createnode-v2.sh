#!/bin/bash

# =======================
# Minta input dari pengguna
# =======================
echo "🗂️ Masukkan nama lokasi: "
read location_name
echo "📝 Masukkan deskripsi lokasi: "
read location_description
echo "🌐 Masukkan domain panel (tanpa https://): "
read domain
echo "📦 Masukkan nama node: "
read node_name
echo "💾 Masukkan RAM (dalam MB): "
read ram
echo "💽 Masukkan jumlah maksimum disk space (dalam MB): "
read disk_space
echo "📍 Masukkan Locid: "
read locid

echo "🌍 Masukkan IP address untuk allocation: "
read ip_address
echo "🏷️ Masukkan IP alias (boleh kosong): "
read ip_alias
echo "🔢 Masukkan Port awal (contoh: 7000): "
read port_start
echo "🔢 Masukkan Port akhir (contoh: 7500): "
read port_end

# =======================
# Masuk ke direktori panel
# =======================
cd /var/www/pterodactyl || { echo "❌ Direktori tidak ditemukan"; exit 1; }

# =======================
# Buat lokasi
# =======================
php artisan p:location:make <<EOF
$location_name
$location_description
EOF

# =======================
# Buat node
# =======================
php artisan p:node:make <<EOF
$node_name
$location_description
$locid
https
$domain
yes
no
no
$ram
0
$disk_space
0
100
8080
2022
/var/lib/pterodactyl/volumes
EOF

echo "✅ Node '$node_name' berhasil dibuat."

# =======================
# Buat allocation (loop port)
# =======================
for port in $(seq "$port_start" "$port_end"); do
  php artisan p:allocation:make <<EOF
$node_name
$ip_address
$port
$ip_alias
EOF
  echo "✅ Allocation $ip_address:$port ditambahkan ke node $node_name"
done

echo "🎉 Semua proses selesai. Node + Allocation sukses dibuat!"
exit 0