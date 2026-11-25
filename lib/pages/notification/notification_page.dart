import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/dummy_data.dart';

class NotificationPage extends StatefulWidget {
  final UserModel? user;

  const NotificationPage({super.key, this.user});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _lightBg = Color(0xFFF3F6FC);

  int _selectedFilterTab =
      0; // 0: Semua, 1: Belum Dibaca, 2: Peminjaman, 3: Sistem

  // Data notifikasi interaktif
  late List<Map<String, dynamic>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      {
        'id': 'notif-1',
        'title': 'Permohonan Peminjaman Disetujui',
        'desc': 'Petugas Sapras telah menyetujui permohonan 1 unit Kamera Canon EOS 200D. Silakan ambil unit di ruang Sapras dengan verifikasi wajah atau barcode.',
        'time': '10 menit yang lalu',
        'category': 'peminjaman',
        'isUnread': true,
        'icon': Icons.check_circle_outline_rounded,
        'color': const Color(0xFF16A34A),
      },
      {
        'id': 'notif-2',
        'title': 'Batas Waktu Pengembalian Mendekati',
        'desc': 'Peminjaman Laptop ASUS VivoBook berakhir hari ini pukul 15.00 WIB. Harap segera melakukan serah terima kembali ke petugas Sapras.',
        'time': '1 jam yang lalu',
        'category': 'peminjaman',
        'isUnread': true,
        'icon': Icons.access_time_rounded,
        'color': const Color(0xFFEAB308),
      },
      {
        'id': 'notif-3',
        'title': 'Profil Wajah Berhasil Didaftarkan',
        'desc': 'Verifikasi wajah Anda telah terdaftar dan aktif untuk validasi serah terima inventaris tanpa tanda tangan manual.',
        'time': 'Kemarin',
        'category': 'sistem',
        'isUnread': false,
        'icon': Icons.verified_user_outlined,
        'color': _primaryBlue,
      },
    ];
  }

  int get _unreadCount =>
      _notifications.where((n) => n['isUnread'] as bool).length;

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilterTab == 1) {
      return _notifications.where((n) => n['isUnread'] as bool).toList();
    } else if (_selectedFilterTab == 2) {
      return _notifications
          .where((n) => n['category'] == 'peminjaman')
          .toList();
    } else if (_selectedFilterTab == 3) {
      return _notifications.where((n) => n['category'] == 'sistem').toList();
    }
    return _notifications;
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['isUnread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi telah ditandai sebagai dibaca'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _primaryBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 650;

    final Widget mobileContent = Scaffold(
      backgroundColor: _lightBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE2E8F0)),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Tandai Dibaca',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: _primaryBlue,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleRow(),
            const SizedBox(height: 14),
            _buildFilterTabs(),
            const SizedBox(height: 16),
            _buildNotificationList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: Center(
          child: Container(
            width: 440,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: mobileContent,
          ),
        ),
      );
    }

    return mobileContent;
  }

  // ─── 2. TITLE ROW ──────────────────────────────────────────────────────────
  Widget _buildTitleRow() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifikasi & Pemberitahuan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pantau update status persetujuan, batas pengembalian, dan aktivitas akun.',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );

    final readAllBtn = _unreadCount > 0
        ? TextButton.icon(
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.done_all_rounded, size: 16),
            label: const Text(
              'Tandai Semua Dibaca',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
              foregroundColor: _primaryBlue,
              backgroundColor: _primaryBlue.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        : null;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleColumn,
          if (readAllBtn != null) ...[const SizedBox(height: 12), readAllBtn],
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [titleColumn, ?readAllBtn],
    );
  }

  // ─── 3. FILTER TABS ────────────────────────────────────────────────────────
  Widget _buildFilterTabs() {
    final tabs = [
      {'label': 'Semua', 'count': _notifications.length},
      {'label': 'Belum Dibaca', 'count': _unreadCount},
      {'label': 'Peminjaman', 'count': null},
      {'label': 'Sistem', 'count': null},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(tabs.length, (i) {
        final isSelected = _selectedFilterTab == i;
        final t = tabs[i];
        final count = t['count'];

        return InkWell(
          onTap: () => setState(() => _selectedFilterTab = i),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? _primaryBlue : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? _primaryBlue
                    : Colors.grey.withValues(alpha: 0.2),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _primaryBlue.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t['label'] as String,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.25)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  // ─── 4. NOTIFICATION LIST ──────────────────────────────────────────────────
  Widget _buildNotificationList() {
    final list = _filteredNotifications;

    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada notifikasi pada kategori ini',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pemberitahuan terkait inventaris akan ditampilkan di sini.',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final n = list[index];
        final isUnread = n['isUnread'] as bool;
        final color = n['color'] as Color;

        return InkWell(
          onTap: () {
            setState(() {
              n['isUnread'] = false;
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isUnread
                    ? _primaryBlue.withValues(alpha: 0.35)
                    : const Color(0xFFE2E8F0),
                width: isUnread ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(n['icon'] as IconData, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              n['title'] as String,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: isUnread
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        n['desc'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            n['time'] as String,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
