import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/book_controller.dart';
import '../../controllers/category_controller.dart';

import '../book/sell_book_screen.dart';
import '../widgets/book_card.dart';

import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final TextEditingController _searchController =
      TextEditingController();

  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);
  static const Color lightBlue = Color(0xFFF2F7FF);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookController>(
        context,
        listen: false,
      ).fetchAllBooks();

      Provider.of<CategoryController>(
        context,
        listen: false,
      ).fetchAllCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _currentIndex == 4
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'BookCycle',
                style: TextStyle(
                  color: green,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    color: blue,
                  ),
                ),
              ],
            ),

      body: _buildCurrentPage(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,

        selectedItemColor: green,
        unselectedItemColor: blue,

        selectedFontSize: 10,
        unselectedFontSize: 10,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Jual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();

      case 1:
        return _buildSearchPage();

      case 2:
        return SellBookScreen();

      case 3:
        return _buildNotificationPage();

      case 4:
        return const ProfileScreen();

      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 5, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              height: 45,
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText:
                      'Cari buku, judul, penulis, atau kategori...',
                  hintStyle: TextStyle(
                    color: Color(0xFF7C8BA5),
                    fontSize: 11,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: blue,
                    size: 21,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  Provider.of<BookController>(
                    context,
                    listen: false,
                  ).searchBooks(value);
                },
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Buku baru,\ncerita baru!',
              style: TextStyle(
                color: green,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Temukan buku favoritmu dengan harga terbaik.',
              style: TextStyle(
                color: blue,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [

                _mainMenu(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Beli',
                  onTap: () {
                    Provider.of<BookController>(
                      context,
                      listen: false,
                    ).fetchAllBooks();
                  },
                ),

                _mainMenu(
                  icon: Icons.upload_outlined,
                  title: 'Jual',
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                ),

                _mainMenu(
                  icon: Icons.swap_horiz,
                  title: 'Tukar',
                  onTap: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Fitur tukar buku akan segera tersedia.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(
                    color: blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            _buildCategorySection(),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Buku Tersedia',
                  style: TextStyle(
                    color: blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            _buildBookSection(),
          ],
        ),
      ),
    );
  }

  Widget _mainMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(
              color: blue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Consumer<CategoryController>(
      builder: (context, controller, child) {

        if (controller.isLoading) {
          return const SizedBox(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(
                color: green,
              ),
            ),
          );
        }
        if (controller.categories.isEmpty) {
          return _defaultCategories();
        }

        return GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: controller.categories.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.9,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final category =
                controller.categories[index];

            return _categoryItem(
              icon: _categoryIcon(index),
              title: category.namaKategori,
              onTap: () {
                Provider.of<BookController>(
                  context,
                  listen: false,
                ).filterByCategory(
                  category.kategoriId ?? 0,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _defaultCategories() {
    final categories = [
      {
        'title': 'Fiksi',
        'icon': Icons.menu_book,
      },
      {
        'title': 'Non-Fiksi',
        'icon': Icons.auto_stories,
      },
      {
        'title': 'Pelajaran',
        'icon': Icons.school,
      },
      {
        'title': 'Novel',
        'icon': Icons.book,
      },
      {
        'title': 'Self Help',
        'icon': Icons.self_improvement,
      },
      {
        'title': 'Teknologi',
        'icon': Icons.computer,
      },
      {
        'title': 'Bisnis',
        'icon': Icons.business_center,
      },
      {
        'title': 'Lainnya',
        'icon': Icons.more_horiz,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return _categoryItem(
          icon: categories[index]['icon'] as IconData,
          title: categories[index]['title'] as String,
          onTap: () {},
        );
      },
    );
  }

  IconData _categoryIcon(int index) {
    const icons = [
      Icons.menu_book,
      Icons.auto_stories,
      Icons.school,
      Icons.book,
      Icons.self_improvement,
      Icons.computer,
      Icons.business_center,
      Icons.more_horiz,
    ];

    return icons[index % icons.length];
  }

  Widget _categoryItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF8F3),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: green,
              size: 23,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: blue,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookSection() {
    return Consumer<BookController>(
      builder: (context, controller, child) {

        if (controller.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: green,
              ),
            ),
          );
        }

        if (controller.books.isEmpty) {
          return Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                'Belum ada buku tersedia',
                style: TextStyle(
                  color: blue,
                ),
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: controller.books.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return BookCard(
              book: controller.books[index],
            );
          },
        );
      },
    );
  }

  Widget _buildSearchPage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            Container(
              height: 45,
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Cari buku...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: blue,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  Provider.of<BookController>(
                    context,
                    listen: false,
                  ).searchBooks(value);
                },
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: Consumer<BookController>(
                builder:
                    (context, controller, child) {

                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: green,
                      ),
                    );
                  }

                  if (controller.books.isEmpty) {
                    return const Center(
                      child: Text(
                        'Buku tidak ditemukan',
                        style: TextStyle(
                          color: blue,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount:
                        controller.books.length,
                    itemBuilder:
                        (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: BookCard(
                          book:
                              controller.books[index],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationPage() {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            color: green,
            size: 65,
          ),

          SizedBox(height: 15),

          Text(
            'Belum ada notifikasi',
            style: TextStyle(
              color: blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Notifikasi transaksi akan muncul di sini.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}