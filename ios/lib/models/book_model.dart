class BookModel {
  final int? bukuId;
  final int? userId;
  final int? kategoriId;
  final String judulBuku;
  final String? penulis;
  final String? penerbit;
  final String? isbn;
  final String kondisiBuku; // 'Baru', 'Bekas_Layak', 'Bekas_Cukup'
  final String? deskripsi;
  final int? harga;
  final String jenisTransaksi; // 'Jual', 'Tukar', 'Jual_Tukar'
  final String? fotoBuku;
  final String statusBuku; // 'Tersedia', 'Terjual', 'Sudah_Ditukar'
  final DateTime? createdAt;

  BookModel({
    this.bukuId,
    this.userId,
    this.kategoriId,
    required this.judulBuku,
    this.penulis,
    this.penerbit,
    this.isbn,
    required this.kondisiBuku,
    this.deskripsi,
    this.harga,
    required this.jenisTransaksi,
    this.fotoBuku,
    this.statusBuku = 'Tersedia',
    this.createdAt,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      bukuId: json['buku_id'],
      userId: json['user_id'],
      kategoriId: json['kategori_id'],
      judulBuku: json['judul_buku'] ?? '',
      penulis: json['penulis'],
      penerbit: json['penerbit'],
      isbn: json['isbn'],
      kondisiBuku: json['kondisi_buku'] ?? 'Bekas_Layak',
      deskripsi: json['deskripsi'],
      harga: json['harga'],
      jenisTransaksi: json['jenis_transaksi'] ?? 'Jual',
      fotoBuku: json['foto_buku'],
      statusBuku: json['status_buku'] ?? 'Tersedia',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buku_id': bukuId,
      'user_id': userId,
      'kategori_id': kategoriId,
      'judul_buku': judulBuku,
      'penulis': penulis,
      'penerbit': penerbit,
      'isbn': isbn,
      'kondisi_buku': kondisiBuku,
      'deskripsi': deskripsi,
      'harga': harga,
      'jenis_transaksi': jenisTransaksi,
      'foto_buku': fotoBuku,
      'status_buku': statusBuku,
    };
  }

  BookModel copyWith({
    int? bukuId,
    int? userId,
    int? kategoriId,
    String? judulBuku,
    String? penulis,
    String? penerbit,
    String? isbn,
    String? kondisiBuku,
    String? deskripsi,
    int? harga,
    String? jenisTransaksi,
    String? fotoBuku,
    String? statusBuku,
  }) {
    return BookModel(
      bukuId: bukuId ?? this.bukuId,
      userId: userId ?? this.userId,
      kategoriId: kategoriId ?? this.kategoriId,
      judulBuku: judulBuku ?? this.judulBuku,
      penulis: penulis ?? this.penulis,
      penerbit: penerbit ?? this.penerbit,
      isbn: isbn ?? this.isbn,
      kondisiBuku: kondisiBuku ?? this.kondisiBuku,
      deskripsi: deskripsi ?? this.deskripsi,
      harga: harga ?? this.harga,
      jenisTransaksi: jenisTransaksi ?? this.jenisTransaksi,
      fotoBuku: fotoBuku ?? this.fotoBuku,
      statusBuku: statusBuku ?? this.statusBuku,
    );
  }
}