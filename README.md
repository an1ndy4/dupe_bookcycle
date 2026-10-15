# bookcycle

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


---------------------------------------
#CATATAN KEKURANGAN PROJECT BOOKCYCLE BAGIAN FITUR SPLASH SCREEN#
- Status Ketersediaan Fitur:
Halaman Splash Screen sudah dibuat di dalam kodingan project Flutter saat ini.
Namun masih abstrak karena masih dalam progress  (Status: progress)

- Komponen Visual (UI Acuan):
Perlu menambahkan halaman awal yang memuat logo utama BookCycle (buku dengan panah melingkar hijau),
tagline "Buku yang kamu punya, mungkin sedang dicari orang lain.", serta ilustrasi tumpukan buku
warna-warni di bagian bawah. (Status: To Do)

- Logika Navigasi & Timer:
Perlu menerapkan fungsi penundaan waktu (delay timer) sekitar 2-3 detik sebelum aplikasi berpindah secara 
otomatis ke halaman Login. (Status: To Do)

-----------------------------------------
#CATATAN KEKURANGAN PROJECT BAGIAN FITUR LOGIN#
- Logo Aplikasi:
Masih menggunakan ikon buku biasa. Perlu diperbarui menjadi logo buku dengan tambahan panah melingkar hijau 
pada logo buku, agar sesuai UI. (Status: need fix

- Style Input Field: 
Bentuknya masih garis bawah (underline). Perlu diubah InputDecoration-nya menjadi kotak berbingkai melengkung
(rounded border). (Status: need fix)

----------------------------------------------
#CATATAN KEKURANGAN PROJECT BOOKCYCLE BAGIAIN FITUR HOME#

- Status Perkembangan Fitur Home:
Sudah terdapat perkembangan yang sangat pesat. Isu bug kritis "BOTTOM OVERFLOWED" yang sebelumnya ada di halaman Home sudah berhasil diatasi (layar sudah bisa di-scroll dengan lancar). (Status: fixed)

- Komponen Visual & UI yang Sudah Sesuai (Progress):
1. Banner Promo: Kartu hijau "Buku baru, cerita baru!" beserta teks deskripsi dan ilustrasi buku sudah berhasil diimplementasikan sesuai UI acuan. (Status: done)
2. Aksen Warna Tombol Aksi: Warna tombol 'Jual' sudah disesuaikan menjadi Oranye/Kuning (sebelumnya hijau polos) untuk membedakan aksen tombol Beli, Jual, dan Tukar. (Status: done)
3. Grid Kategori Lengkap: Ikon-ikon kategori berwarna-warni (Fiksi, Non Fiksi, Pelajaran, Komik, Self Help, Teknologi, Bisnis, Lainnya) sudah tampil lengkap. (Status: done)
4. Navigasi Utama: Bottom Navigation Bar sudah terhubung dengan halaman pendukung (Jual Buku, Notifikasi, dan Profil Saya). (Status: done)

- Kekurangan & Catatan Revisi yang Masih Perlu Perbaikan (To Do / Need Fix):
1. Layout Tombol Aksi Utama: Bentuk tombol 'Jual' di tengah masih berupa background kapsul lebar. Perlu diselaraskan menjadi bentuk lingkaran konsisten (circular icon button) sejajar dengan tombol Beli dan Tukar. (Status: need fix)
2. Posisi Teks 'Lihat Semua >': Teks penunjuk pada seksi Kategori terdorong terlalu ke pinggir kanan. Perlu penyesuaian margin/padding agar sejajar rapi. (Status: need fix)
3. Seksi Rekomendasi / Ketersediaan Buku: Bagian bawah masih menampilkan teks placeholder "Belum ada buku yang tersedia." Perlu ditambahkan dummy card/daftar produk buku beserta harga dan rating sesuai UI acuan. (Status: progress)
4. Header App Bar: Perlu menambahkan ikon 'Keranjang Belanja' di pojok kanan atas sejajar dengan logo BookCycle. (Status: need fix)
