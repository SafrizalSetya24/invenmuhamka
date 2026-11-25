import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../utils/logout_helper.dart';
import '../../utils/nav_helper.dart';
import '../../widgets/top_bar_actions.dart';
import '../cart/cart_page.dart';
import '../catalog/item_category_page.dart';
import '../feedback/feedback_page.dart';
import '../home/home_page.dart';
import '../notification/notification_page.dart';
import '../profile/profile_page.dart';

class BorrowingHistoryPage extends StatefulWidget {
  final UserModel? user;
  const BorrowingHistoryPage({super.key, this.user});

  @override
  State<BorrowingHistoryPage> createState() => _BorrowingHistoryPageState();
}

class _BorrowingHistoryPageState extends State<BorrowingHistoryPage> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _lightBg = Color(0xFFF3F6FC);

  UserModel get _currentUser => widget.user ?? DummyData.users.first;
  String _selectedFilter = 'Semua Status';

  // Riwayat Peminjaman Dummy mencakup semua status per README
  final List<Map<String, dynamic>> _historyData = [
    {
      'id': 'REQ-20261113-001',
      'item': '1 unit Kamera Canon EOS 200D',
      'category': 'Multimedia & Kamera',
      'type': 'Per Unit',
      'date': '15 Nov 2026, 08.00 - 12.00',
      'status': 'WAITING_APPROVAL',
      'statusLabel': 'Menunggu Persetujuan',
      'statusColor': const Color(0xFFB45309),
      'statusBg': const Color(0xFFFEF3C7),
      'note': 'Menunggu approval Sapras (Maks. 2 jam)',
    },
    {
      'id': 'REQ-20261110-004',
      'item': '1 unit Laptop ASUS VivoBook + 10 pcs Konektor RJ45',
      'category': 'Lab RPL 1',
      'type': 'Kombinasi (Unit & Habis Pakai)',
      'date': '10 Nov 2026',
      'status': 'HANDED_OVER',
      'statusLabel': 'Sedang Dipinjam',
      'statusColor': const Color(0xFF0369A1),
      'statusBg': const Color(0xFFE0F2FE),
      'note': 'Diserahkan oleh Sapras (Barcode fisik: INV-NB-109)',
    },
    {
      'id': 'REQ-20261102-008',
      'item': '1 unit Proyektor Epson EB-E500',
      'category': 'Multimedia',
      'type': 'Per Unit',
      'date': '02 Nov 2026',
      'status': 'COMPLETED',
      'statusLabel': 'Selesai Dikembalikan',
      'statusColor': const Color(0xFF15803D),
      'statusBg': const Color(0xFFDCFCE7),
      'note': 'Kondisi inspeksi akhir: LAYAK_PAKAI',
    },
    {
      'id': 'REQ-20261028-011',
      'item': '1 unit Solder Listrik 40W',
      'category': 'Elektronika',
      'type': 'Per Unit',
      'date': '28 Okt 2026',
      'status': 'EXPIRED',
      'statusLabel': 'Kedaluwarsa (Expired)',
      'statusColor': const Color(0xFFDC2626),
      'statusBg': const Color(0xFFFEE2E2),
      'note': 'Tidak dikonfirmasi dalam 2 jam; booking dilepas',
    },
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    if (_selectedFilter == 'Semua Status') return _historyData;
    return _historyData
        .where((item) => item['status'] == _selectedFilter)
        .toList();
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
          // Sidebar Menu Tetap Ada (Desktop)
          if (isDesktop) _buildSidebar(),

          // Konten Utama Riwayat
          Expanded(
            child: Column(
              children: [
                _buildHeader(isDesktop),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 20,
                      vertical: 26,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 920),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul & Keterangan
                            _buildTitleRow(),
                            const SizedBox(height: 20),

                            // Filter Status Chips
                            _buildStatusFilterRow(),
                            const SizedBox(height: 22),

                            // List History Cards
                            _buildHistoryList(),
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Drawer untuk Mobile/Tablet
      drawer: isDesktop ? null : Drawer(child: _buildSidebar(isDrawer: true)),
    );
  }

  // ─── 1. HEADER ATAS ────────────────────────────────────────────────────────
  Widget _buildHeader(bool isDesktop) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 36 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E293B)),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            const SizedBox(width: 4),
          ],
          const Text(
            'Riwayat',
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

  // ─── 2. TITLE ROW ──────────────────────────────────────────────────────────
  Widget _buildTitleRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Peminjaman & Pengambilan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pantau riwayat permohonan, barang yang sedang dipinjam, dan pengembalian.',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // ─── 3. STATUS FILTER ROW ──────────────────────────────────────────────────
  Widget _buildStatusFilterRow() {
    final filters = [
      {'key': 'Semua Status', 'label': 'Semua Status'},
      {'key': 'WAITING_APPROVAL', 'label': 'Menunggu Sapras'},
      {'key': 'HANDED_OVER', 'label': 'Sedang Dipinjam'},
      {'key': 'COMPLETED', 'label': 'Selesai Dikembalikan'},
      {'key': 'EXPIRED', 'label': 'Kedaluwarsa'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSel = _selectedFilter == f['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f['label']!),
              selected: isSel,
              onSelected: (val) {
                if (val) setState(() => _selectedFilter = f['key']!);
              },
              selectedColor: _primaryBlue,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 12.5,
                fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                color: isSel ? Colors.white : const Color(0xFF475569),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSel
                      ? _primaryBlue
                      : Colors.grey.withValues(alpha: 0.25),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── 4. HISTORY CARDS LIST ─────────────────────────────────────────────────
  Widget _buildHistoryList() {
    final list = _filteredHistory;

    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            const Text(
              'Belum ada transaksi pada status ini',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = list[index];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['id'] as String,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: item['statusBg'] as Color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['statusLabel'] as String,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: item['statusColor'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item['item'] as String,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Jadwal: ${item['date']} • Jenis: ${item['type']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: _primaryBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['note'] as String,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── 5. SIDEBAR MENU ───────────────────────────────────────────────────────
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
          // Header Logo
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

          // Menu Section
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

          _buildNavItem(0, Icons.home_rounded, 'Beranda', () {
            NavHelper.navigateTo(context, HomePage(user: _currentUser));
          }),
          _buildNavItem(1, Icons.grid_view_rounded, 'Katalog', () {
            NavHelper.navigateTo(
              context,
              ItemCategoryPage(user: _currentUser),
            );
          }),
          _buildNavItem(2, Icons.shopping_cart_outlined, 'Keranjang', () {
            NavHelper.navigateTo(context, CartPage(user: _currentUser));
          }),
          // Riwayat Aktif
          _buildNavItem(
            3,
            Icons.history_rounded,
            'Riwayat',
            () {},
            isSelected: true,
            hasIndicator: true,
          ),
          _buildNavItem(
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
          _buildNavItem(5, Icons.person_outline_rounded, 'Profil', () {
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
          _buildNavItem(
            6,
            Icons.chat_bubble_outline_rounded,
            'Kritik & Saran',
            () {
              NavHelper.navigateTo(context, FeedbackPage(user: _currentUser));
            },
          ),

          const Spacer(),

          // Bottom User Profile & Logout
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

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isSelected = false,
    bool hasIndicator = false,
    int? badgeCount,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE8EEF9) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        horizontalTitleGap: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        leading: Icon(
          icon,
          size: 20,
          color: isSelected ? _primaryBlue : const Color(0xFF6B7280),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? _primaryBlue : const Color(0xFF4B5563),
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
            if (isSelected && hasIndicator)
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
