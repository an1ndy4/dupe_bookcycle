class CategoryModel {
  final int? kategoriId;
  final String namaKategori;
  final String? iconKategori;

  CategoryModel({
    this.kategoriId,
    required this.namaKategori,
    this.iconKategori,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      kategoriId: json['kategori_id'],
      namaKategori: json['nama_kategori'] ?? '',
      iconKategori: json['icon_kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kategori_id': kategoriId,
      'nama_kategori': namaKategori,
      'icon_kategori': iconKategori,
    };
  }
}