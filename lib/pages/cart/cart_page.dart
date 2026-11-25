import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../utils/logout_helper.dart';
import '../../utils/nav_helper.dart';
import '../../widgets/top_bar_actions.dart';
import '../borrowing/borrowing_detail_page.dart';
import '../catalog/item_category_page.dart';
import '../feedback/feedback_page.dart';
import '../history/borrowing_history_page.dart';
import '../home/home_page.dart';
import '../notification/notification_page.dart';
import '../profile/profile_page.dart';

class CartItemModel {
  final String name;
  final String category;
  final String type; // 'Per Unit' / 'Habis Pakai'
  int quantity;
  final String unit;
  final IconData icon;

  CartItemModel({
    required this.name,
    required this.category,
    required this.type,
    required this.quantity,
    required this.unit,
    required this.icon,
  });
}

class CartPage extends StatefulWidget {
  final UserModel? user;
  const CartPage({super.key, this.user});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _lightBg = Color(0xFFF3F6FC);

  UserModel get _currentUser => widget.user ?? DummyData.users.first;

  // Initial cart items (kombinasi per unit + habis pakai sesuai aturan README)
  final List<CartItemModel> _cartItems = [
    CartItemModel(
      name: 'Laptop Asus Vivobook 14',
      category: 'Laptop',
      type: 'Per Unit',
      quantity: 1,
      unit: 'unit',
      icon: Icons.laptop_mac_rounded,
    ),
    CartItemModel(
      name: 'Konektor RJ-45 Cat6 Belden',
      category: 'Jaringan & Bahan LAN',
      type: 'Habis Pakai',
      quantity: 10,
      unit: 'pcs',
      icon: Icons.electrical_services_rounded,
    ),
  ];

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

          // Konten Utama Keranjang
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
                            // Judul Halaman
                            _buildTitleRow(),
                            const SizedBox(height: 20),

                            if (_cartItems.isEmpty)
                              _buildEmptyState()
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SOP Info Banner
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8EEF9),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _primaryBlue
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.info_outline_rounded,
                                            size: 18, color: _primaryBlue),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Satu keranjang = Satu Borrow Request. Anda dapat meminjam unit & meminta bahan habis pakai sekaligus.',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: Color(0xFF1E293B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // List Item Keranjang
                                  _buildCartItemList(),
                                  const SizedBox(height: 24),

                                  // Bottom Summary & Checkout Card
                                  _buildCheckoutSummaryCard(),
                                  const SizedBox(height: 36),
                                ],
                              ),
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
            'Keranjang',
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Keranjang Peminjaman',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Periksa daftar alat dan bahan praktikum sebelum verifikasi.',
            style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ItemCategoryPage(user: _currentUser),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('+ Tambah Barang'),
            style: TextButton.styleFrom(
              foregroundColor: _primaryBlue,
              backgroundColor: _primaryBlue.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Keranjang Peminjaman',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Periksa daftar alat dan bahan praktikum sebelum verifikasi.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ItemCategoryPage(user: _currentUser),
              ),
            );
          },
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('+ Tambah Barang'),
          style: TextButton.styleFrom(
            foregroundColor: _primaryBlue,
            backgroundColor: _primaryBlue.withValues(alpha: 0.08),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // ─── 3. CART ITEM LIST ─────────────────────────────────────────────────────
  Widget _buildCartItemList() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 550;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cartItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        final isUnit = item.type == 'Per Unit';

        final counterWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 22),
              color: _primaryBlue,
              onPressed: item.quantity > 1
                  ? () => setState(() => item.quantity--)
                  : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Text(
                '${item.quantity} ${item.unit}',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 22),
              color: _primaryBlue,
              onPressed: () => setState(() => item.quantity++),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 22, color: Color(0xFFEF4444)),
              tooltip: 'Hapus Item',
              onPressed: () {
                setState(() => _cartItems.removeAt(index));
              },
            ),
          ],
        );

        if (isMobile) {
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.icon, color: _primaryBlue, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${item.type} • ${item.category}',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [counterWidget],
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: _primaryBlue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: isUnit
                                ? const Color(0xFFE8EEF9)
                                : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.type,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: isUnit
                                  ? _primaryBlue
                                  : const Color(0xFFB45309),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.category,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              counterWidget,
            ],
          ),
        );
      },
    );
  }

  // ─── 4. CHECKOUT SUMMARY CARD ──────────────────────────────────────────────
  Widget _buildCheckoutSummaryCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final summaryContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Total Permintaan',
            style: TextStyle(fontSize: 12.5, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          '${_cartItems.length} Model Item Dipilih',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );

    final checkoutBtn = ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BorrowingDetailPage(
              user: _currentUser,
              cartItems: _cartItems,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: _primaryBlue.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lanjut: Detail & Verifikasi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 18),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                summaryContent,
                const SizedBox(height: 16),
                checkoutBtn,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                summaryContent,
                checkoutBtn,
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_outlined,
                size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Keranjang Peminjaman Kosong',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Silakan pilih barang dari katalog praktikum terlebih dahulu.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ItemCategoryPage(user: _currentUser),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Buka Katalog Praktikum'),
            ),
          ],
        ),
      ),
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
          // Keranjang Aktif
          _buildNavItem(
            2,
            Icons.shopping_cart_outlined,
            'Keranjang',
            () {},
            isSelected: true,
            hasIndicator: true,
            badgeCount: _cartItems.isNotEmpty ? _cartItems.length : null,
          ),
          _buildNavItem(3, Icons.history_rounded, 'Riwayat', () {
            NavHelper.navigateTo(
              context,
              BorrowingHistoryPage(user: _currentUser),
            );
          }),
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
                            fontSize: 10, color: Colors.grey),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _primaryBlue,
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
