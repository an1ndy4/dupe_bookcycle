import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/book_controller.dart';
import '../../controllers/category_controller.dart';
import '../book/sell_book_screen.dart';
import '../widgets/book_card.dart';
import 'category_books_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class HomeScreen
    extends
        StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<
    HomeScreen
  >
  createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends
        State<
          HomeScreen
        > {
  static const Color
  green = Color(
    0xFF087F3E,
  );
  static const Color
  blue = Color(
    0xFF092B8F,
  );

  final TextEditingController
  _searchController =
      TextEditingController();

  int
  _selectedIndex =
      0;

  final List<
    Map<
      String,
      dynamic
    >
  >
  categories = [
    {
      'id': 1,
      'name': 'Fiksi',
      'icon': Icons.auto_stories_rounded,
      'color': Color(
        0xFFE1F4E8,
      ),
    },
    {
      'id': 2,
      'name': 'Non Fiksi',
      'icon': Icons.menu_book_rounded,
      'color': Color(
        0xFFFFE8D5,
      ),
    },
    {
      'id': 3,
      'name': 'Pelajaran',
      'icon': Icons.school_rounded,
      'color': Color(
        0xFFE1EAFF,
      ),
    },
    {
      'id': 4,
      'name': 'Komik',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(
        0xFFFFE4EC,
      ),
    },
    {
      'id': 5,
      'name': 'Self Help',
      'icon': Icons.psychology_rounded,
      'color': Color(
        0xFFFFF0C9,
      ),
    },
    {
      'id': 6,
      'name': 'Teknologi',
      'icon': Icons.computer_rounded,
      'color': Color(
        0xFFDDF5F8,
      ),
    },
    {
      'id': 7,
      'name': 'Bisnis',
      'icon': Icons.business_center_rounded,
      'color': Color(
        0xFFEAE2FF,
      ),
    },
  ];

  @override
  void
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((
      _,
    ) {
      if (!mounted)
        return;

      context
          .read<
            BookController
          >()
          .fetchAllBooks();
      context
          .read<
            CategoryController
          >()
          .fetchAllCategories();
    });
  }

  @override
  void
  dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void
  _searchBooks(
    String
    query,
  ) {
    context
        .read<
          BookController
        >()
        .searchBooks(query);
  }

  void
  _openCategory(
    int
    id,
    String
    name,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(
          kategoriId: id,
          namaKategori: name,
        ),
      ),
    );
  }

  void
  _openBookList({
    required bool
    forSale,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookListScreen(
          forSale: forSale,
        ),
      ),
    );
  }

  // Navigasi bawah tetap berada di dalam Scaffold yang sama.
  void
  _onBottomNavTap(
    int
    index,
  ) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget
  build(
    BuildContext
    context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(),
            const SellBookScreen(),
            const NotificationScreen(),
            const ProfileScreen(),
          ],
        ),
      ),

      // NAVIGASI BAWAH
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: green,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
            ),
            label: 'Jual',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_none_rounded,
            ),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_rounded,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // =========================================================
  // KONTEN HOME
  // =========================================================
  Widget
  _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =================================================
          // SEARCH BAR
          // =================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              18,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _searchBooks,
              decoration: InputDecoration(
                hintText: 'Cari buku, judul, penulis, atau kategori...',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: blue,
                ),
                filled: true,
                fillColor: const Color(
                  0xFFEEF4FD,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // =================================================
          // BANNER BOOKCYCLE
          // =================================================
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Container(
              height: 150,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(
                      0xFF087F3E,
                    ),
                    Color(
                      0xFF079B70,
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // TULISAN BANNER
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                      14,
                      12,
                      130,
                      12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buku baru,\ncerita baru!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            height: 1.15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Temukan buku favoritmu '
                          'dengan harga terbaik.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // GAMBAR BUKU DI SEBELAH KANAN
                  Positioned(
                    right: 8,
                    top: 8,
                    bottom: 8,
                    width: 125,
                    child: Center(
                      child: Image.asset(
                        'assets/images/book_bunner.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return const Icon(
                                Icons.menu_book_rounded,
                                color: Colors.white,
                                size: 65,
                              );
                            },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 22,
          ),

          // =================================================
          // MENU BELI, JUAL, TUKAR
          // =================================================
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _menuItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Beli',
                  color: const Color(
                    0xFF087F3E,
                  ),
                  onTap: () => _openBookList(
                    forSale: true,
                  ),
                ),
                _menuItem(
                  icon: Icons.sell_outlined,
                  label: 'Jual',
                  color: const Color(
                    0xFFFFC329,
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                _menuItem(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Tukar',
                  color: const Color(
                    0xFF13A4E0,
                  ),
                  onTap: () => _openBookList(
                    forSale: false,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 50,
          ),

          // =================================================
          // KATEGORI BUKU
          // =================================================
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              'Kategori Buku',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: blue,
              ),
            ),
          ),

          // Jarak judul ke kategori diperkecil.
          const SizedBox(
            height: 30,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 8,

                // Area setiap kategori dibuat lebih pendek.
                childAspectRatio: 1.15,
              ),
              itemBuilder:
                  (
                    context,
                    index,
                  ) {
                    final category = categories[index];

                    return InkWell(
                      onTap: () => _openCategory(
                        category['id'] as int,
                        category['name'] as String,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: category['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              color: green,
                              size: 27,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            category['name'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              color: blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Consumer<
            BookController
          >(
            builder:
                (
                  context,
                  controller,
                  child,
                ) {
                  final books = controller.books;

                  if (controller.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(
                          color: green,
                        ),
                      ),
                    );
                  }

                  if (controller.errorMessage !=
                          null &&
                      books.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Gagal memuat buku: '
                        '${controller.errorMessage}',
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  }


                  return SizedBox(
                    height: 245,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      itemCount: books.length,
                      itemBuilder:
                          (
                            context,
                            index,
                          ) {
                            return SizedBox(
                              width: 155,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                ),
                                child: BookCard(
                                  book: books[index],
                                ),
                              ),
                            );
                          },
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MENU ITEM: BELI, JUAL, TUKAR
  // =========================================================
  Widget
  _menuItem({
    required IconData
    icon,
    required String
    label,
    required Color
    color,
    required VoidCallback
    onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        16,
      ),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// HALAMAN DAFTAR BUKU UNTUK BELI DAN TUKAR
// =========================================================

class BookListScreen
    extends
        StatelessWidget {
  final bool
  forSale;

  const BookListScreen({
    super.key,
    required this.forSale,
  });

  static const Color
  green = Color(
    0xFF087F3E,
  );
  static const Color
  blue = Color(
    0xFF092B8F,
  );

  @override
  Widget
  build(
    BuildContext
    context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          forSale
              ? 'Beli Buku'
              : 'Tukar Buku',
        ),
        backgroundColor: Colors.white,
        foregroundColor: blue,
        elevation: 0,
      ),
      body:
          Consumer<
            BookController
          >(
            builder:
                (
                  context,
                  controller,
                  child,
                ) {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: green,
                      ),
                    );
                  }

                  final books = controller.books.where((book) {
                    final jenis = book.jenisTransaksi.trim().toLowerCase();
                    final status = book.statusBuku.trim().toLowerCase();

                    final tersedia =
                        status ==
                        'tersedia';

                    final bisaDibeli =
                        jenis == 'jual' ||
                        jenis == 'jual_tukar';

                    final bisaDitukar =
                        jenis == 'tukar' ||
                        jenis == 'jual_tukar';

                    return tersedia &&
                        (forSale
                            ? bisaDibeli
                            : bisaDitukar);
                  }).toList();

                  if (books.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              forSale
                                  ? Icons.shopping_bag_outlined
                                  : Icons.swap_horiz_rounded,
                              size: 70,
                              color: green,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              forSale
                                  ? 'Belum ada buku untuk dibeli'
                                  : 'Belum ada buku untuk ditukar',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: blue,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Buku yang tersedia akan muncul di sini.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: books.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.62,
                    ),
                    itemBuilder:
                        (
                          context,
                          index,
                        ) {
                          return BookCard(
                            book: books[index],
                          );
                        },
                  );
                },
          ),
    );
  }
}
