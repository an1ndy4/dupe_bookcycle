class CartDetailModel {
  final int? detailId;
  final int? keranjangId;
  final int? bukuId;
  final int jumlah;
  final int subtotal;

  CartDetailModel({
    this.detailId,
    this.keranjangId,
    this.bukuId,
    required this.jumlah,
    required this.subtotal,
  });

  factory CartDetailModel.fromJson(Map<String, dynamic> json) {
    return CartDetailModel(
      detailId: json['detail_id'],
      keranjangId: json['keranjang_id'],
      bukuId: json['buku_id'],
      jumlah: json['jumlah'] ?? 1,
      subtotal: json['subtotal'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keranjang_id': keranjangId,
      'buku_id': bukuId,
      'jumlah': jumlah,
      'subtotal': subtotal,
    };
  }

  CartDetailModel copyWith({
    int? detailId,
    int? keranjangId,
    int? bukuId,
    int? jumlah,
    int? subtotal,
  }) {
    return CartDetailModel(
      detailId: detailId ?? this.detailId,
      keranjangId: keranjangId ?? this.keranjangId,
      bukuId: bukuId ?? this.bukuId,
      jumlah: jumlah ?? this.jumlah,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}