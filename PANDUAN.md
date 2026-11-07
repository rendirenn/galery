# Galeri foto klien: GitHub Pages + Supabase (gratis)

File di folder ini:
- `index.html`: halaman untuk klien (lihat, pilih favorit, unduh)
- `admin.html`: halaman untukmu (buat galeri, unggah foto, lihat pilihan klien)
- `config.js`: tempat mengisi alamat dan kunci Supabase
- `setup.sql`: perintah untuk menyiapkan database dan penyimpanan

## 1. Buat project Supabase
1. Daftar di supabase.com, lalu klik **New project**. Pilih region terdekat (mis. Singapore).
2. Buka **SQL Editor > New query**, tempel seluruh isi `setup.sql`, klik **Run**.

## 2. Buat akun admin untukmu
1. Buka **Authentication > Users > Add user > Create new user**. Isi email dan kata sandi, centang auto confirm.
2. Setelah akun jadi, buka pengaturan **Authentication** (bagian Sign In / Providers) dan **matikan pendaftaran pengguna baru** ("Allow new users to sign up"). Ini penting supaya orang lain tidak bisa membuat akun dan masuk ke admin.

## 3. Isi config.js
Buka **Project Settings > API**. Salin **Project URL** dan **anon public key** ke `config.js`.

## 4. Pasang di GitHub Pages
1. Buat repositori publik baru di GitHub.
2. Unggah `index.html`, `admin.html`, dan `config.js` (file `setup.sql` dan panduan ini tidak wajib).
3. Buka **Settings > Pages**, pilih **Deploy from a branch**, branch `main`, folder `/ (root)`, lalu Save.
4. Tunggu 1 sampai 2 menit. Alamatnya: `https://NAMAKAMU.github.io/NAMA-REPO/`

## 5. Pakai
1. Buka `.../admin.html`, masuk, klik **Buat galeri**, lalu **Unggah foto**.
2. Klik **Salin tautan klien** dan kirim ke klien lewat WhatsApp.
3. Klien memilih favorit. Pilihannya langsung muncul di halaman adminmu, dan kamu bisa menyalin daftarnya.

## Yang perlu kamu ingat
- **Foto bersifat tidak terdaftar, bukan benar-benar privat.** Daftar foto tidak bisa dilihat orang tanpa kode galeri, dan alamat tiap foto acak. Tapi siapa pun yang memegang tautan klien bisa meneruskannya. Jangan pakai untuk foto yang sangat sensitif.
- **Kuota gratis Supabase: 1 GB file, 500 MB database, 5 GB bandwidth per bulan.** Opsi "Kecilkan ke 2400 px" menghemat banyak ruang, tapi klien mengunduh versi yang sudah dikecilkan. Kirim file resolusi penuh lewat Google Drive jika diperlukan.
- **Project gratis di-pause setelah 7 hari tanpa aktivitas.** Kalau galeri tiba-tiba tidak bisa dimuat, buka dashboard Supabase dan klik Restore project. Data tidak hilang.
- **Simpan file asli foto di laptop atau Google Drive.** Galeri ini bukan tempat cadangan.
- Kunci anon di `config.js` memang boleh publik. Jangan pernah menaruh kunci `service_role` di sana.
