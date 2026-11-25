import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../utils/logout_helper.dart';
import '../../utils/nav_helper.dart';
import '../../widgets/top_bar_actions.dart';
import '../cart/cart_page.dart';
import '../feedback/feedback_page.dart';
import '../history/borrowing_history_page.dart';
import '../home/home_page.dart';
import '../notification/notification_page.dart';
import '../profile/profile_page.dart';

class ItemCategoryPage extends StatefulWidget {
  final UserModel? user;

  const ItemCategoryPage({super.key, this.user});

  @override
  State<ItemCategoryPage> createState() => _ItemCategoryPageState();
}

class _ItemCategoryPageState extends State<ItemCategoryPage> {
  // Tab: 0 = Barang Per Unit (Wajib Kembali), 1 = Barang Habis Pakai (Tidak Kembali)
  int _selectedTabType = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Warna Konsisten Identitas SMK Muhammadiyah Kramat
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _lightBg = Color(0xFFF3F6FC);

  UserModel get _currentUser => widget.user ?? DummyData.users.first;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Data Barang Per Unit Sesuai Gambar
  final List<Map<String, dynamic>> _unitItems = [
    {
      'name': 'Laptop Asus Vivobook 14',
      'category': 'Laptop',
      'desc': 'Laptop Intel Core i5, RAM 8 GB, SSD 512 GB. Terpasang aplikasi perkantoran dan desain.',
      'stock': 4,
      'unit': 'unit',
      'icon': Icons.laptop_mac_rounded,
    },
    {
      'name': 'Laptop Lenovo IdeaPad 3',
      'category': 'Laptop',
      'desc':
          'Laptop Ryzen 5, RAM 8 GB, cocok untuk pembelajaran dan presentasi.',
      'stock': 4,
      'unit': 'unit',
      'icon': Icons.laptop_mac_rounded,
    },
    {
      'name': 'Proyektor Epson EB-X06',
      'category': 'Proyektor',
      'desc': 'Proyektor 3600 Lumens XGA, koneksi HDMI & VGA, ideal untuk presentasi kelas.',
      'stock': 2,
      'unit': 'unit',
      'icon': Icons.videocam_outlined,
    },
    {
      'name': 'Kamera DSLR Canon EOS 200D',
      'category': 'Kamera',
      'desc': 'Lensa Kit 18-55mm, baterai cadangan & tas. Siap untuk praktikum DKV/Multimedia.',
      'stock': 3,
      'unit': 'unit',
      'icon': Icons.camera_alt_outlined,
    },
  ];

  // Data Barang Habis Pakai Sesuai Konsep README
  final List<Map<String, dynamic>> _consumableItems = [
    {
      'name': 'Konektor RJ-45 Cat6 Belden',
      'category': 'Jaringan & Bahan LAN',
      'desc': 'Konektor crimping kabel UTP Cat6 gold plated. Bahan praktik tidak perlu dikembalikan.',
      'stock': 85,
      'unit': 'pcs',
      'icon': Icons.electrical_services_rounded,
    },
    {
      'name': 'Kabel UTP Cat6 Belden (Roll 305m)',
      'category': 'Jaringan & Bahan LAN',
      'desc': 'Kabel LAN jaringan untuk praktikum pengkabelan & routing siswa TKJ/RPL.',
      'stock': 120,
      'unit': 'meter',
      'icon': Icons.cable_rounded,
    },
    {
      'name': 'Spidol Boardmarker Snowman Hitam',
      'category': 'ATK & Pembelajaran',
      'desc': 'Spidol papan tulis putih cepat kering untuk kegiatan belajar mengajar & presentasi.',
      'stock': 42,
      'unit': 'pcs',
      'icon': Icons.edit_outlined,
    },
    {
      'name': 'Timah Solder Asahi 60/40 0.8mm',
      'category': 'Bahan Praktik Elektronika',
      'desc': 'Kawat timah solder presisi dengan resin flux untuk perakitan komponen elektro.',
      'stock': 18,
      'unit': 'roll',
      'icon': Icons.circle_outlined,
    },
    {
      'name': 'Kertas HVS A4 80gr PaperOne',
      'category': 'ATK & Cetak Laporan',
      'desc': 'Kertas cetak laporan tugas akhir, jobsheet praktik, dan dokumentasi kejuruan.',
      'stock': 15,
      'unit': 'rim',
      'icon': Icons.description_outlined,
    },
  ];

  List<Map<String, dynamic>> get _currentDisplayItems {
    final list = _selectedTabType == 0 ? _unitItems : _consumableItems;
    if (_searchQuery.trim().isEmpty) return list;
    return list.where((item) {
      final name = item['name'].toString().toLowerCase();
      final desc = item['desc'].toString().toLowerCase();
      final cat = item['category'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) ||
          desc.contains(query) ||
          cat.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: _lightBg,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Kiri (Desktop)
          if (isDesktop) _buildSidebar(),

          // Konten Utama
          Expanded(
            child: Column(
              children: [
                _buildHeader(isDesktop),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 18,
                      vertical: 26,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul & Ikon Keranjang Belanja Kanan
                        _buildTitleRow(),
                        const SizedBox(height: 16),

                        // Informasi Singkat Inventaris
                        _buildInventoryNotice(),
                        const SizedBox(height: 18),

                        // Dua Tab Seleksi: Barang Per Unit vs Barang Habis Pakai
                        _buildDualSelectionTabs(isDesktop),
                        const SizedBox(height: 18),

                        // Search Bar
                        _buildSearchBar(),
                        const SizedBox(height: 20),

                        // List Kartu Barang (List View Horizontal Row Cards)
                        _buildItemList(),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebar(isDrawer: true)),
    );
  }

  // ─── 1. HEADER ────────────────────────────────────────────────────────────
  Widget _buildHeader(bool isDesktop) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 36 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.14)),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            const SizedBox(width: 4),
          ],
          const Text(
            'Katalog',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),

          HeaderNotificationBell(user: _currentUser),
          const SizedBox(width: 8),
          HeaderUserPill(user: _currentUser, isDesktop: isDesktop),
        ],
      ),
    );
  }

  // ─── 2. TITLE & SHOPPING CART ICON ────────────────────────────────────────
  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Katalog Barang',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            letterSpacing: -0.3,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.shopping_cart_outlined,
            size: 26,
            color: Color(0xFF1F2937),
          ),
          onPressed: () {
            NavHelper.navigateTo(context, CartPage(user: _currentUser));
          },
          tooltip: 'Lihat Keranjang',
        ),
      ],
    );
  }

  // ─── 3. INFORMASI INVENTARIS ───────────────────────────────────────────────
  Widget _buildInventoryNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: Color(0xFF475569),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Informasi: Tentukan model dan jumlah unit yang dibutuhkan. Penyerahan fisik dan verifikasi kelayakan alat dilakukan langsung di Ruang Sarpras Gedung A.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 4. DUAL TABS: BARANG PER UNIT vs BARANG HABIS PAKAI ──────────────────
  Widget _buildDualSelectionTabs(bool isDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    Widget buildTab({
      required int index,
      required IconData icon,
      required String title,
      required String subtitle,
      required Color iconBgColor,
      required Color iconColor,
    }) {
      final isSelected = _selectedTabType == index;
      return InkWell(
        onTap: () => setState(() => _selectedTabType = index),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? _primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? _primaryBlue
                  : Colors.grey.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: _primaryBlue.withValues(alpha: isSelected ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.15)
                      : iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.white : iconColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final tab1 = buildTab(
      index: 0,
      icon: Icons.laptop_chromebook_rounded,
      title: 'Barang Per Unit',
      subtitle: 'Wajib Kembali (4)',
      iconBgColor: const Color(0xFFF1F5F9),
      iconColor: const Color(0xFF475569),
    );

    final tab2 = buildTab(
      index: 1,
      icon: Icons.edit_outlined,
      title: 'Barang Habis Pakai',
      subtitle: 'Tidak Kembali (5)',
      iconBgColor: const Color(0xFFF0FDF4),
      iconColor: const Color(0xFF10B981),
    );

    if (isMobile) {
      return Column(children: [tab1, const SizedBox(height: 10), tab2]);
    }

    return Row(
      children: [
        Expanded(child: tab1),
        const SizedBox(width: 16),
        Expanded(child: tab2),
      ],
    );
  }

  // ─── 5. SEARCH BAR ────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(fontSize: 13.5),
        decoration: InputDecoration(
          hintText: _selectedTabType == 0
              ? 'Cari model laptop, proyektor, kamera...'
              : 'Cari konektor RJ-45, kabel LAN, spidol, ATK...',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: Color(0xFF64748B),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // ─── 6. LIST BARANG (SESUAI DOKUMEN GAMBAR) ────────────────────────────────
  Widget _buildItemList() {
    final items = _currentDisplayItems;

    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: const Column(
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Tidak ada model barang yang cocok dengan pencarian.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCardRow(item);
      },
    );
  }

  Widget _buildItemCardRow(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kotak Ikon Device/Barang
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item['icon'] as IconData,
              color: const Color(0xFF334155),
              size: 28,
            ),
          ),
          const SizedBox(width: 18),

          // Detail Teks Barang
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item['category'] as String,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey[500]),
                ),
                const SizedBox(height: 6),
                Text(
                  item['desc'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                // Baris Info Stok Hijau + Tombol Pilih Hitam/Navy
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Badge Ketersediaan Hijau Muda
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Tersedia: ${item['stock']} ${item['unit']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),

                    // Tombol Pilih (Biru Muhamka)
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          _showConfirmDialog(item);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          elevation: 1,
                        ),
                        child: const Text(
                          'Pilih',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── DIALOG KONFIRMASI PEMILIHAN BARANG ────────────────────────────────────
  void _showConfirmDialog(Map<String, dynamic> item) {
    int qty = 1;
    final maxStock = item['stock'] as int;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Pilih ${item['name']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['desc'] as String,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Tentukan Jumlah:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: _primaryBlue,
                        onPressed: qty > 1
                            ? () => setDialogState(() => qty--)
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$qty ${item['unit']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: _primaryBlue,
                        onPressed: qty < maxStock
                            ? () => setDialogState(() => qty++)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Tersedia maksimal $maxStock ${item['unit']}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Berhasil memilih $qty ${item['unit']} ${item['name']} ke Keranjang Peminjaman!',
                        ),
                        backgroundColor: _primaryBlue,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Tambah ke Keranjang'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ─── 7. SIDEBAR ───────────────────────────────────────────────────────────
  Widget _buildSidebar({bool isDrawer = false}) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'inventarisMuhamka',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'SMK Muhammadiyah Kramat',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F7)),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'MENU',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9CA3AF),
                letterSpacing: 0.8,
              ),
            ),
          ),
          _buildSidebarNavItem(0, Icons.home_rounded, 'Beranda', () {
            NavHelper.navigateTo(context, HomePage(user: _currentUser));
          }),
          _buildSidebarNavItem(
            1,
            Icons.grid_view_rounded,
            'Katalog',
            () {},
            isSelected: true,
          ),
          _buildSidebarNavItem(
            2,
            Icons.shopping_cart_outlined,
            'Keranjang',
            () {
              NavHelper.navigateTo(context, CartPage(user: _currentUser));
            },
          ),
          _buildSidebarNavItem(3, Icons.history_rounded, 'Riwayat', () {
            NavHelper.navigateTo(
              context,
              BorrowingHistoryPage(user: _currentUser),
            );
          }),
          _buildSidebarNavItem(
            4,
            Icons.notifications_none_rounded,
            'Notifikasi',
            () {
              NavHelper.navigateTo(
                context,
                NotificationPage(user: _currentUser),
              );
            },
            badgeCount: 3,
          ),
          _buildSidebarNavItem(5, Icons.person_outline_rounded, 'Profil', () {
            NavHelper.navigateTo(context, ProfilePage(user: _currentUser));
          }),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'LAINNYA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9CA3AF),
                letterSpacing: 0.8,
              ),
            ),
          ),
          _buildSidebarNavItem(
            6,
            Icons.chat_bubble_outline_rounded,
            'Kritik & Saran',
            () {
              NavHelper.navigateTo(context, FeedbackPage(user: _currentUser));
            },
          ),
          const Spacer(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F7)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: _primaryBlue,
                  child: Text(
                    _currentUser.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentUser.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${_currentUser.role} • ${_currentUser.identifier}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    LogoutHelper.confirmLogout(context);
                  },
                  tooltip: 'Keluar',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem(
    int index,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isSelected = false,
    int? badgeCount,
  }) {
    final isSelectedTab = isSelected;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      decoration: BoxDecoration(
        color: isSelectedTab ? const Color(0xFFE8EEF9) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        horizontalTitleGap: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        leading: Icon(
          icon,
          size: 20,
          color: isSelectedTab ? _primaryBlue : const Color(0xFF6B7280),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelectedTab ? FontWeight.bold : FontWeight.w500,
            color: isSelectedTab ? _primaryBlue : const Color(0xFF4B5563),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeCount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isSelectedTab)
              Container(
                margin: const EdgeInsets.only(left: 6),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primaryBlue,
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
