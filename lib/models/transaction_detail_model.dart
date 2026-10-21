class TransactionDetailModel {
  final int? detailId;
  final int transaksiId;
  final int bukuId;
  final int penjualId;
  final int jumlah;
  final int harga;
  final DateTime? tanggalDibuat;

  TransactionDetailModel({
    this.detailId,
    required this.transaksiId,
    required this.bukuId,
    required this.penjualId,
    required this.jumlah,
    required this.harga,
    this.tanggalDibuat,
  });

  factory TransactionDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionDetailModel(
      detailId: (json['detail_id'] as num?)?.toInt(),
      transaksiId: (json['transaksi_id'] as num).toInt(),
      bukuId: (json['buku_id'] as num).toInt(),
      penjualId: (json['penjual_id'] as num).toInt(),
      jumlah: (json['jumlah'] as num).toInt(),
      harga: (json['harga'] as num).toInt(),
      tanggalDibuat: json['tanggal_dibuat'] != null
          ? DateTime.parse(
              json['tanggal_dibuat'].toString(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaksi_id': transaksiId,
      'buku_id': bukuId,
      'penjual_id': penjualId,
      'jumlah': jumlah,
      'harga': harga,
    };
  }

  TransactionDetailModel copyWith({
    int? detailId,
    int? transaksiId,
    int? bukuId,
    int? penjualId,
    int? jumlah,
    int? harga,
    DateTime? tanggalDibuat,
  }) {
    return TransactionDetailModel(
      detailId: detailId ?? this.detailId,
      transaksiId: transaksiId ?? this.transaksiId,
      bukuId: bukuId ?? this.bukuId,
      penjualId: penjualId ?? this.penjualId,
      jumlah: jumlah ?? this.jumlah,
      harga: harga ?? this.harga,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
    );
  }
}