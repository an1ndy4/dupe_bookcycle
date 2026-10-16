class UserModel {
  final int? userId;
  final String? authId;
  final String namaLengkap;
  final String email;
  final String? nomorHp;
  final String? fotoProfil;
  final String? alamat;
  final DateTime? tanggalDaftar;

  UserModel({
    this.userId,
    this.authId,
    required this.namaLengkap,
    required this.email,
    this.nomorHp,
    this.fotoProfil,
    this.alamat,
    this.tanggalDaftar,
  });

  // Dari JSON (Supabase) ke Dart Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      authId: json['auth_id'],
      namaLengkap: json['nama_lengkap'] ?? '',
      email: json['email'] ?? '',
      nomorHp: json['nomor_hp'],
      fotoProfil: json['foto_profil'],
      alamat: json['alamat'],
      tanggalDaftar: json['tanggal_daftar'] != null
          ? DateTime.parse(json['tanggal_daftar'])
          : null,
    );
  }

  // Dari Dart Object ke JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'auth_id': authId,
      'nama_lengkap': namaLengkap,
      'email': email,
      'nomor_hp': nomorHp,
      'alamat': alamat,
      'tanggal_daftar': tanggalDaftar?.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? userId,
    String? authId,
    String? namaLengkap,
    String? email,
    String? nomorHp,
    String? fotoProfil,
    String? alamat,
    DateTime? tanggalDaftar,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      authId: authId ?? this.authId,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      email: email ?? this.email,
      nomorHp: nomorHp ?? this.nomorHp,
      fotoProfil: fotoProfil ?? this.fotoProfil,
      alamat: alamat ?? this.alamat,
      tanggalDaftar: tanggalDaftar ?? this.tanggalDaftar,
    );
  }
}