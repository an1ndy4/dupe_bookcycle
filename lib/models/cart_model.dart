class CartModel {
  final int? keranjangId;
  final int userId;
  final int bukuId;
  final int jumlah;
  final DateTime? tanggalDibuat;

  CartModel({
    this.keranjangId,
    required this.userId,
    required this.bukuId,
    this.jumlah = 1,
    this.tanggalDibuat,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      keranjangId: json['keranjang_id'],
      userId: json['user_id'],
      bukuId: json['buku_id'],
      jumlah: json['jumlah'] ?? 1,
      tanggalDibuat: json['tanggal_dibuat'] != null
          ? DateTime.parse(json['tanggal_dibuat'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'buku_id': bukuId,
      'jumlah': jumlah,
    };
  }

  CartModel copyWith({
    int? keranjangId,
    int? userId,
    int? bukuId,
    int? jumlah,
    DateTime? tanggalDibuat,
  }) {
    return CartModel(
      keranjangId: keranjangId ?? this.keranjangId,
      userId: userId ?? this.userId,
      bukuId: bukuId ?? this.bukuId,
      jumlah: jumlah ?? this.jumlah,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
    );
  }
}