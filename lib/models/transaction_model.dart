
class TransactionModel {
  final int? transaksiId;
  final int userId;
  final int totalHarga;
  final String status;
  final String? alamatPengiriman;
  final String? metodePembayaran;
  final DateTime? tanggalDibuat;

  TransactionModel({
    this.transaksiId,
    required this.userId,
    required this.totalHarga,
    this.status = 'pending',
    this.alamatPengiriman,
    this.metodePembayaran,
    this.tanggalDibuat,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transaksiId: (json['transaksi_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num).toInt(),
      totalHarga: (json['total_harga'] as num).toInt(),
      status: json['status'] as String? ?? 'pending',
      alamatPengiriman: json['alamat_pengiriman'] as String?,
      metodePembayaran: json['metode_pembayaran'] as String?,
      tanggalDibuat: json['tanggal_dibuat'] != null
          ? DateTime.parse(json['tanggal_dibuat'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_harga': totalHarga,
      'status': status,
      'alamat_pengiriman': alamatPengiriman,
      'metode_pembayaran': metodePembayaran,
    };
  }

  TransactionModel copyWith({
    int? transaksiId,
    int? userId,
    int? totalHarga,
    String? status,
    String? alamatPengiriman,
    String? metodePembayaran,
    DateTime? tanggalDibuat,
  }) {
    return TransactionModel(
      transaksiId: transaksiId ?? this.transaksiId,
      userId: userId ?? this.userId,
      totalHarga: totalHarga ?? this.totalHarga,
      status: status ?? this.status,
      alamatPengiriman: alamatPengiriman ?? this.alamatPengiriman,
      metodePembayaran: metodePembayaran ?? this.metodePembayaran,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
    );
  }
}
