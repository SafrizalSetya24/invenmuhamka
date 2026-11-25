import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../utils/logout_helper.dart';
import '../../utils/nav_helper.dart';
import '../../widgets/top_bar_actions.dart';
import '../cart/cart_page.dart';
import '../catalog/item_category_page.dart';
import '../face/face_registration_page.dart';
import '../feedback/feedback_page.dart';
import '../history/borrowing_history_page.dart';
import '../home/home_page.dart';
import '../notification/notification_page.dart';

class ProfilePage extends StatelessWidget {
  final UserModel? user;
  const ProfilePage({super.key, this.user});

  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _lightBg = Color(0xFFF3F6FC);

  @override
  Widget build(BuildContext context) {
    final currentUser = user ?? DummyData.users.first;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: _lightBg,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Menu Tetap Ada (Desktop)
          if (isDesktop) _buildSidebar(context, currentUser),

          // Konten Utama Profil
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, currentUser, isDesktop),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 20,
                      vertical: 26,
                    ),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 640),
                        padding: EdgeInsets.all(screenWidth < 500 ? 18 : 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: _primaryBlue,
                              child: Text(
                                currentUser.initials,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              currentUser.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${currentUser.role} • ${currentUser.identifier} • ${currentUser.subInfo}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),

                            _buildProfileItem(
                              Icons.badge_outlined,
                              'Identitas Akun',
                              currentUser.role == 'Siswa'
                                  ? 'NIS: ${currentUser.identifier}'
                                  : 'NUPTK: ${currentUser.identifier}',
                            ),
                            _buildProfileItem(
                              Icons.school_outlined,
                              'Instansi Pendidikan',
                              'SMK Muhammadiyah Kramat',
                            ),
                            _buildProfileItem(
                              Icons.verified_user_outlined,
                              'Status Face Biometric',
                              'Aktif & Terdaftar',
                            ),
                            _buildProfileItem(
                              Icons.check_circle_outline,
                              'Status Peminjaman',
                              'Bebas Tanggungan (Siap Pinjam)',
                            ),

                            const SizedBox(height: 26),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FaceRegistrationPage(
                                            user: currentUser,
                                          ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.face_retouching_natural_rounded,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Update Foto Wajah Biometrik',
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _primaryBlue,
                                  side: const BorderSide(color: _primaryBlue),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
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
      drawer: isDesktop
          ? null
          : Drawer(child: _buildSidebar(context, currentUser, isDrawer: true)),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    UserModel currentUser,
    bool isDesktop,
  ) {
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
            'Profil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          HeaderNotificationBell(user: currentUser),
          const SizedBox(width: 8),
          HeaderUserPill(user: currentUser, isDesktop: isDesktop),
        ],
      ),
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    UserModel currentUser, {
    bool isDrawer = false,
  }) {
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

          _buildNavItem(context, 0, Icons.home_rounded, 'Beranda', () {
            NavHelper.navigateTo(context, HomePage(user: currentUser));
          }),
          _buildNavItem(context, 1, Icons.grid_view_rounded, 'Katalog', () {
            NavHelper.navigateTo(
              context,
              ItemCategoryPage(user: currentUser),
            );
          }),
          _buildNavItem(
            context,
            2,
            Icons.shopping_cart_outlined,
            'Keranjang',
            () {
              NavHelper.navigateTo(context, CartPage(user: currentUser));
            },
          ),
          _buildNavItem(context, 3, Icons.history_rounded, 'Riwayat', () {
            NavHelper.navigateTo(
              context,
              BorrowingHistoryPage(user: currentUser),
            );
          }),
          _buildNavItem(
            context,
            4,
            Icons.notifications_none_rounded,
            'Notifikasi',
            () {
              NavHelper.navigateTo(
                context,
                NotificationPage(user: currentUser),
              );
            },
            badgeCount: 3,
          ),
          _buildNavItem(
            context,
            5,
            Icons.person_outline_rounded,
            'Profil',
            () {},
            isSelected: true,
            hasIndicator: true,
          ),

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
            context,
            6,
            Icons.chat_bubble_outline_rounded,
            'Kritik & Saran',
            () {
              NavHelper.navigateTo(context, FeedbackPage(user: currentUser));
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
                    currentUser.initials,
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
                        currentUser.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${currentUser.role} • ${currentUser.identifier}',
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
    BuildContext context,
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

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: _primaryBlue),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
