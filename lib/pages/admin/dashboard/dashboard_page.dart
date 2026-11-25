import 'package:flutter/material.dart';
import '../../../data/dummy_data.dart';
import '../../../utils/logout_helper.dart';

class AdminDashboardPage extends StatefulWidget {
  final UserModel? user;
  const AdminDashboardPage({super.key, this.user});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // Brand Color Palette (Konsisten dengan Sapras)
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _darkNavy = Color(0xFF061A40);
  static const Color _lightBg = Color(0xFFF3F6FC);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedTabIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  UserModel get _currentUser => widget.user ?? DummyData.users[3]; // Admin IT

  // ─── 1. DATA MASTER STATE (LENGKAP & DAPAT DI-UPDATE) ─────────────────────

  // Data Pengguna (Users)
  late List<Map<String, dynamic>> _userList;

  // Data Kategori Aset
  late List<Map<String, dynamic>> _categoryList;

  // Data Master Ruang & Denah
  late List<Map<String, dynamic>> _roomList;

  // Data Audit Log Sistem
  late List<Map<String, dynamic>> _auditLogs;

  int _selectedUserFilter = 0; // 0: Semua, 1: Siswa, 2: Guru, 3: Sapras, 4: Admin
  int _selectedAuditFilter = 0; // 0: Semua, 1: Auth, 2: Aset, 3: Pengguna

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    // 1. Data User
    _userList = [
      {
        'id': 'usr-001',
        'name': 'Safrizal Setya Wira Budiman',
        'identifier': '22090044',
        'role': 'Siswa',
        'subInfo': 'XI RPL 1',
        'initials': 'SB',
        'hasFace': true,
        'status': 'Aktif',
      },
      {
        'id': 'usr-002',
        'name': 'Ahmad Fauzi, S.Kom.',
        'identifier': '198705122010011003',
        'role': 'Guru',
        'subInfo': 'Guru Produktif RPL',
        'initials': 'AF',
        'hasFace': true,
        'status': 'Aktif',
      },
      {
        'id': 'usr-003',
        'name': 'Bambang Irawan, S.T.',
        'identifier': 'sapras',
        'role': 'Sapras',
        'subInfo': 'Kepala Unit Sarpras',
        'initials': 'BI',
        'hasFace': true,
        'status': 'Aktif',
      },
      {
        'id': 'usr-004',
        'name': 'Admin IT Muhamka',
        'identifier': 'admin',
        'role': 'Admin',
        'subInfo': 'Administrator Utama',
        'initials': 'AD',
        'hasFace': true,
        'status': 'Aktif',
      },
      {
        'id': 'usr-005',
        'name': 'Dedi Prasetyo',
        'identifier': '22090118',
        'role': 'Siswa',
        'subInfo': 'XII TKRO 2',
        'initials': 'DP',
        'hasFace': true,
        'status': 'Aktif',
      },
      {
        'id': 'usr-006',
        'name': 'Retno Wahyuni, S.Sn',
        'identifier': '199203152018022001',
        'role': 'Guru',
        'subInfo': 'Ketua Konsentrasi DKV',
        'initials': 'RW',
        'hasFace': true,
        'status': 'Aktif',
      },
      {
        'id': 'usr-007',
        'name': 'Dimas Bagus Anggoro',
        'identifier': '22090205',
        'role': 'Siswa',
        'subInfo': 'XI Las 1',
        'initials': 'DB',
        'hasFace': false,
        'status': 'Aktif',
      },
      {
        'id': 'usr-008',
        'name': 'Staf Loket Sarpras Pagi',
        'identifier': 'sapras_pagi',
        'role': 'Sapras',
        'subInfo': 'Petugas Loket Gudang',
        'initials': 'SP',
        'hasFace': true,
        'status': 'Aktif',
      },
    ];

    // 2. Data Kategori Aset
    _categoryList = [
      {
        'id': 'CAT-01',
        'name': 'Elektronik & Komputer (RPL/TKJ)',
        'prefix': 'EL-',
        'itemCount': 128,
        'borrowLimit': '1 Hari Praktikum',
        'icon': Icons.computer_rounded,
        'color': _primaryBlue,
        'bg': const Color(0xFFEFF6FF),
        'desc': 'PC Desktop, Switch, Router Cisco, Mikrokontroler Arduino/ESP32, Kabel LAN.',
      },
      {
        'id': 'CAT-02',
        'name': 'Mesin & Otomotif (TKRO)',
        'prefix': 'TKR-',
        'itemCount': 86,
        'borrowLimit': 'Selama Jam Bengkel',
        'icon': Icons.directions_car_outlined,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFEF3C7),
        'desc': 'OBD-II Diagnostic Scanner, Kunci Pas/Ring Set, Car Lift, Multimeter Digital Sanwa.',
      },
      {
        'id': 'CAT-03',
        'name': 'Multimedia & Studio (DKV)',
        'prefix': 'CAM-',
        'itemCount': 45,
        'borrowLimit': '1 Hari (Surat Izin Guru)',
        'icon': Icons.videocam_outlined,
        'color': const Color(0xFF7C3AED),
        'bg': const Color(0xFFF3E8FF),
        'desc': 'Kamera Sony A6000/A6400, Tripod Somita, Mic Clip-On Wireless, Set Lighting Studio.',
      },
      {
        'id': 'CAT-04',
        'name': 'Teknik Las & Fabrikasi Logam',
        'prefix': 'LAS-',
        'itemCount': 52,
        'borrowLimit': 'Sesi Praktik Terjadwal',
        'icon': Icons.precision_manufacturing_outlined,
        'color': const Color(0xFFDC2626),
        'bg': const Color(0xFFFEF2F2),
        'desc': 'Mesin Las SMAW/GMAW, Tabung Argon, Helm Las Otomatis, Gerinda Tangan Bosch.',
      },
      {
        'id': 'CAT-05',
        'name': 'Bahan Habis Pakai (BHP)',
        'prefix': 'BHP-',
        'itemCount': 31,
        'borrowLimit': 'Non-Kembali (Sesuai Kebutuhan)',
        'icon': Icons.category_outlined,
        'color': const Color(0xFF16A34A),
        'bg': const Color(0xFFDCFCE7),
        'desc': 'Timah Solder, Konektor RJ45, Amplas Besi, Kawat Las E6013, Kertas A4 & Banner.',
      },
    ];

    // 3. Data Master Ruang
    _roomList = [
      {
        'code': 'R-A201',
        'name': 'Lab Komputer RPL 1 & 2',
        'building': 'Gedung A, Lantai 2',
        'supervisor': 'Ahmad Fauzi, S.Kom.',
        'capacity': '72 Workstation PC',
        'status': 'Siap Operasional',
        'statusColor': const Color(0xFF16A34A),
        'statusBg': const Color(0xFFDCFCE7),
        'icon': Icons.computer_rounded,
      },
      {
        'code': 'R-B101',
        'name': 'Bengkel Praktik TKRO',
        'building': 'Gedung Bengkel Terpadu, Lt 1',
        'supervisor': 'Joko Susilo, S.T.',
        'capacity': '6 Car Lift & Service Bay',
        'status': 'Beroperasi',
        'statusColor': const Color(0xFFD97706),
        'statusBg': const Color(0xFFFEF3C7),
        'icon': Icons.directions_car_outlined,
      },
      {
        'code': 'R-B102',
        'name': 'Bengkel Fabrikasi & Las',
        'building': 'Gedung Bengkel Terpadu, Lt 1',
        'supervisor': 'Slamet Riyadi',
        'capacity': '14 Booth Las Standar K3',
        'status': 'Siap Operasional',
        'statusColor': const Color(0xFF16A34A),
        'statusBg': const Color(0xFFDCFCE7),
        'icon': Icons.precision_manufacturing_outlined,
      },
      {
        'code': 'R-C103',
        'name': 'Studio Multimedia & DKV',
        'building': 'Gedung C Kreatif, Lt 1',
        'supervisor': 'Retno Wahyuni, S.Sn',
        'capacity': '32 Siswa + Green Screen Box',
        'status': 'Siap Operasional',
        'statusColor': const Color(0xFF16A34A),
        'statusBg': const Color(0xFFDCFCE7),
        'icon': Icons.videocam_outlined,
      },
      {
        'code': 'R-A100',
        'name': 'Gudang Pusat Sarpras',
        'building': 'Gedung A, Lantai 1',
        'supervisor': 'Bambang Irawan, S.T.',
        'capacity': 'Rak L-01 s/d Rak L-08',
        'status': 'Loket Terbuka',
        'statusColor': _primaryBlue,
        'statusBg': const Color(0xFFEFF6FF),
        'icon': Icons.warehouse_rounded,
      },
    ];

    // 4. Data Audit Log
    _auditLogs = [
      {
        'time': '25 Nov 2026, 16:38 WIB',
        'user': 'Admin IT Muhamka',
        'role': 'Admin',
        'action': 'LOGIN_SUCCESS',
        'actionBadge': 'LOGIN',
        'desc': 'Autentikasi sesi Super Admin berhasil melalui perangkat desktop pengawas.',
        'ip': '192.168.1.10 (Lab IT)',
        'status': 'SUCCESS',
        'color': const Color(0xFF16A34A),
      },
      {
        'time': '25 Nov 2026, 16:20 WIB',
        'user': 'Bambang Irawan, S.T.',
        'role': 'Sapras',
        'action': 'STATUS_CHANGE_LOKET',
        'actionBadge': 'SARPRAS',
        'desc': 'Status operasional loket diubah menjadi "Loket Dibuka • Shift Pagi".',
        'ip': '192.168.1.15 (Loket Gedung A)',
        'status': 'SUCCESS',
        'color': _primaryBlue,
      },
      {
        'time': '25 Nov 2026, 15:45 WIB',
        'user': 'Ahmad Fauzi, S.Kom.',
        'role': 'Guru',
        'action': 'VERIFY_BORROWING',
        'actionBadge': 'APPROVAL',
        'desc': 'Menyetujui rekomendasi pinjam 2 unit Multimeter untuk kelas XI TITL 1.',
        'ip': '192.168.1.42 (Ruang Guru)',
        'status': 'SUCCESS',
        'color': const Color(0xFF16A34A),
      },
      {
        'time': '25 Nov 2026, 14:12 WIB',
        'user': 'Safrizal Setya',
        'role': 'Siswa',
        'action': 'FACE_VERIFY_SUCCESS',
        'actionBadge': 'BIOMETRIK',
        'desc': 'Verifikasi biometrik wajah pemohon berhasil cocok 98.4% dengan profil terdaftar.',
        'ip': '10.20.4.88 (Mobile Chrome)',
        'status': 'SUCCESS',
        'color': const Color(0xFF16A34A),
      },
      {
        'time': '25 Nov 2026, 13:05 WIB',
        'user': 'Admin IT Muhamka',
        'role': 'Admin',
        'action': 'RESET_PASSWORD',
        'actionBadge': 'SECURITY',
        'desc': 'Mereset kata sandi siswa Dedi Prasetyo (NIS: 22090118) atas permohonan wali kelas.',
        'ip': '192.168.1.10 (Lab IT)',
        'status': 'WARNING',
        'color': const Color(0xFFD97706),
      },
      {
        'time': '25 Nov 2026, 10:30 WIB',
        'user': 'Dimas Bagus Anggoro',
        'role': 'Siswa',
        'action': 'LOGIN_FAILED',
        'actionBadge': 'AUTH_FAIL',
        'desc': 'Percobaan login gagal: Kata sandi salah sebanyak 2 kali.',
        'ip': '10.20.4.112 (Mobile)',
        'status': 'FAILED',
        'color': const Color(0xFFDC2626),
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1100;

    return Scaffold(
      backgroundColor: _lightBg,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sidebar Mengapung Khusus Super Admin
          if (isDesktop) _buildSidebar(),

          // Konten Utama
          Expanded(
            child: Column(
              children: [
                _buildHeader(isDesktop, screenWidth),
                Expanded(
                  child: _buildCurrentView(isDesktop, screenWidth),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: isDesktop
          ? null
          : Drawer(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: SafeArea(child: _buildSidebar(isDrawer: true)),
            ),
    );
  }

  // ─── 2. FLOATING SIDEBAR NAVIGATION ───────────────────────────────────────
  Widget _buildSidebar({bool isDrawer = false}) {
    return Container(
      width: 260,
      margin: isDrawer
          ? const EdgeInsets.all(12)
          : const EdgeInsets.fromLTRB(16, 16, 14, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_primaryBlue, _darkNavy],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _darkNavy.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Logo & Brand
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'inventarisMuhamka',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pusat Kendali Super Admin',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 6),
              children: [
                _buildSidebarGroupHeader('UTAMA'),
                _buildSidebarNavItem(0, Icons.dashboard_rounded, 'Ringkasan Sistem', onTap: () {
                  setState(() => _selectedTabIndex = 0);
                  if (isDrawer) Navigator.of(context).pop();
                }),

                const SizedBox(height: 12),
                _buildSidebarGroupHeader('PENGGUNA & BIOMETRIK'),
                _buildSidebarNavItem(1, Icons.people_alt_outlined, 'Manajemen Pengguna', badge: '${_userList.length}', onTap: () {
                  setState(() => _selectedTabIndex = 1);
                  if (isDrawer) Navigator.of(context).pop();
                }),

                const SizedBox(height: 12),
                _buildSidebarGroupHeader('DATA MASTER SEKOLAH'),
                _buildSidebarNavItem(2, Icons.category_outlined, 'Kategori & Model Aset', badge: '${_categoryList.length}', onTap: () {
                  setState(() => _selectedTabIndex = 2);
                  if (isDrawer) Navigator.of(context).pop();
                }),
                _buildSidebarNavItem(3, Icons.meeting_room_outlined, 'Master Ruang & Denah', badge: '${_roomList.length}', onTap: () {
                  setState(() => _selectedTabIndex = 3);
                  if (isDrawer) Navigator.of(context).pop();
                }),

                const SizedBox(height: 12),
                _buildSidebarGroupHeader('KEAMANAN & LOG'),
                _buildSidebarNavItem(4, Icons.security_rounded, 'Audit Log Sistem', badge: 'Aktif', badgeColor: const Color(0xFF16A34A), onTap: () {
                  setState(() => _selectedTabIndex = 4);
                  if (isDrawer) Navigator.of(context).pop();
                }),

                const SizedBox(height: 14),
                _buildSidebarGroupHeader('AKUN'),
                // Profile Card Mini Super Admin
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        child: Text(
                          _currentUser.initials,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentUser.name,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Super Administrator',
                              style: TextStyle(fontSize: 9.5, color: Colors.white.withValues(alpha: 0.7)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSidebarNavItem(
                  99,
                  Icons.logout_rounded,
                  'Keluar',
                  onTap: () => LogoutHelper.confirmLogout(context),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarGroupHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white.withValues(alpha: 0.55),
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSidebarNavItem(
    int index,
    IconData icon,
    String label, {
    String? badge,
    Color? badgeColor,
    VoidCallback? onTap,
  }) {
    final isSelected = _selectedTabIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.18) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        dense: true,
        horizontalTitleGap: 10,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        leading: Icon(
          icon,
          size: 19,
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.85),
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : (badgeColor ?? Colors.white.withValues(alpha: 0.16)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
        onTap: onTap ?? () => setState(() => _selectedTabIndex = index),
      ),
    );
  }

  // ─── 3. TOP HEADER CARD ───────────────────────────────────────────────────
  Widget _buildHeader(bool isDesktop, double screenWidth) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final showSearchInput = availableWidth >= 780;

        return Container(
          height: 64,
          margin: isDesktop ? const EdgeInsets.fromLTRB(0, 16, 20, 0) : EdgeInsets.zero,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isDesktop ? BorderRadius.circular(16) : BorderRadius.zero,
            border: isDesktop
                ? Border.all(color: _borderColor)
                : const Border(bottom: BorderSide(color: _borderColor)),
          ),
          child: Row(
            children: [
              if (!isDesktop) ...[
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu_rounded, color: _textPrimary),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                const SizedBox(width: 4),
              ],

              // Breadcrumb Info
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 16, color: _primaryBlue),
                    const SizedBox(width: 8),
                    const Text(
                      'Super Admin',
                      style: TextStyle(fontSize: 12, color: _textSecondary, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 6),
                    const Text('/', style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _getTabTitle(),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              if (showSearchInput)
                Container(
                  width: 220,
                  height: 38,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontSize: 12, color: _textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Cari data master...',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, size: 16, color: Color(0xFF94A3B8)),
                      prefixIconConstraints: const BoxConstraints(minWidth: 32),
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),

              // Primary Action Button
              _buildTopActionButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopActionButton() {
    switch (_selectedTabIndex) {
      case 1:
        return ElevatedButton.icon(
          onPressed: _showAddUserDialog,
          icon: const Icon(Icons.person_add_alt_1_rounded, size: 15),
          label: const Text('+ Tambah Pengguna'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        );
      case 2:
        return ElevatedButton.icon(
          onPressed: _showAddCategoryDialog,
          icon: const Icon(Icons.add_rounded, size: 15),
          label: const Text('+ Tambah Kategori'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        );
      case 3:
        return ElevatedButton.icon(
          onPressed: _showAddRoomDialog,
          icon: const Icon(Icons.add_rounded, size: 15),
          label: const Text('+ Tambah Ruangan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        );
      default:
        return ElevatedButton.icon(
          onPressed: () => setState(() => _selectedTabIndex = 1),
          icon: const Icon(Icons.manage_accounts_rounded, size: 15),
          label: const Text('Kelola Pengguna'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  String _getTabTitle() {
    switch (_selectedTabIndex) {
      case 0:
        return 'Ringkasan Sistem';
      case 1:
        return 'Manajemen Akun Pengguna';
      case 2:
        return 'Kategori & Standar Aset';
      case 3:
        return 'Master Ruang & Lokasi';
      case 4:
        return 'Audit Log & Keamanan Sistem';
      default:
        return 'Ringkasan Sistem';
    }
  }

  // ─── 4. VIEW ROUTER ───────────────────────────────────────────────────────
  Widget _buildCurrentView(bool isDesktop, double screenWidth) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewView(isDesktop, screenWidth);
      case 1:
        return _buildUsersView(isDesktop, screenWidth);
      case 2:
        return _buildCategoriesView(isDesktop, screenWidth);
      case 3:
        return _buildRoomsView(isDesktop, screenWidth);
      case 4:
        return _buildAuditLogView(isDesktop, screenWidth);
      default:
        return _buildOverviewView(isDesktop, screenWidth);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODUL 1: RINGKASAN SISTEM (OVERVIEW)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildOverviewView(bool isDesktop, double screenWidth) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : (screenWidth < 500 ? 14 : 18),
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Super Admin
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEFF6FF), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _primaryBlue,
                  child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pusat Konfigurasi & Keamanan Sistem Sekolah',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _primaryBlue),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Selamat Bertugas, ${_currentUser.name}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textPrimary),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Server Aktif • Database MySQL Terenkripsi • Sinkronisasi Biometrik Wajah Online',
                        style: TextStyle(fontSize: 11, color: _textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 4 Metric Stat Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = constraints.maxWidth > 850
                  ? (constraints.maxWidth - 36) / 4
                  : (constraints.maxWidth > 480
                      ? (constraints.maxWidth - 12) / 2
                      : constraints.maxWidth);

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildMetricCard(
                    title: 'Total Akun Pengguna',
                    value: '${_userList.length} Akun',
                    subtitle: '812 Siswa • 42 Guru Terdaftar',
                    icon: Icons.people_alt_outlined,
                    color: _primaryBlue,
                    bg: const Color(0xFFEFF6FF),
                    width: cardWidth,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                  ),
                  _buildMetricCard(
                    title: 'Model & Kategori Aset',
                    value: '${_categoryList.length} Kategori',
                    subtitle: '342 Model Unit Siap Praktikum',
                    icon: Icons.category_outlined,
                    color: const Color(0xFF7C3AED),
                    bg: const Color(0xFFF3E8FF),
                    width: cardWidth,
                    onTap: () => setState(() => _selectedTabIndex = 2),
                  ),
                  _buildMetricCard(
                    title: 'Master Ruang & Bengkel',
                    value: '${_roomList.length} Ruangan',
                    subtitle: 'Semua fasilitas siap pakai',
                    icon: Icons.meeting_room_outlined,
                    color: const Color(0xFF16A34A),
                    bg: const Color(0xFFDCFCE7),
                    width: cardWidth,
                    onTap: () => setState(() => _selectedTabIndex = 3),
                  ),
                  _buildMetricCard(
                    title: 'Keandalan Audit Log',
                    value: '100% Aktif',
                    subtitle: '${_auditLogs.length} Aktivitas Krusial Tercatat',
                    icon: Icons.shield_outlined,
                    color: const Color(0xFFD97706),
                    bg: const Color(0xFFFEF3C7),
                    width: cardWidth,
                    onTap: () => setState(() => _selectedTabIndex = 4),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),

          // Distribusi Pengguna & Fasilitas Sekolah
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Distribusi Inventaris per Konsentrasi Keahlian (Jurusan)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textPrimary),
                    ),
                    Text(
                      'SMK Muhammadiyah Kramat',
                      style: TextStyle(fontSize: 11, color: _textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDepartmentProgress('Rekayasa Perangkat Lunak (RPL)', 0.88, '128 Alat', _primaryBlue),
                const SizedBox(height: 12),
                _buildDepartmentProgress('Teknik Kendaraan Ringan Otomotif (TKRO)', 0.74, '86 Alat', const Color(0xFFD97706)),
                const SizedBox(height: 12),
                _buildDepartmentProgress('Teknik Pengelasan & Fabrikasi (TP)', 0.65, '52 Alat', const Color(0xFFDC2626)),
                const SizedBox(height: 12),
                _buildDepartmentProgress('Desain Komunikasi Visual (DKV)', 0.58, '45 Alat', const Color(0xFF7C3AED)),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Ringkasan Audit Log Terkini
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Aktivitas Sistem & Log Keamanan Terkini',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textPrimary),
                    ),
                    InkWell(
                      onTap: () => setState(() => _selectedTabIndex = 4),
                      child: const Row(
                        children: [
                          Text(
                            'Buka Log Lengkap',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: _primaryBlue),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 13, color: _primaryBlue),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...List.generate(3, (index) {
                  final log = _auditLogs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: log['color'].withValues(alpha: 0.12),
                          child: Icon(Icons.history_rounded, size: 14, color: log['color']),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${log['user']} — ${log['action']}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textPrimary),
                              ),
                              Text(
                                '${log['desc']} • IP: ${log['ip']}',
                                style: const TextStyle(fontSize: 11, color: _textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          log['time'],
                          style: const TextStyle(fontSize: 10.5, color: _textSecondary),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bg,
    required double width,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: bg,
                    child: Icon(icon, color: color, size: 18),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey.shade400),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10.5, color: color, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentProgress(String name, double percent, String count, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textPrimary)),
            Text(count, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODUL 2: MANAJEMEN AKUN PENGGUNA (USERS)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildUsersView(bool isDesktop, double screenWidth) {
    final filteredUsers = _userList.where((u) {
      if (_selectedUserFilter == 1 && u['role'] != 'Siswa') return false;
      if (_selectedUserFilter == 2 && u['role'] != 'Guru') return false;
      if (_selectedUserFilter == 3 && u['role'] != 'Sapras') return false;
      if (_selectedUserFilter == 4 && u['role'] != 'Admin') return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (u['name'] as String).toLowerCase();
        final id = (u['identifier'] as String).toLowerCase();
        final sub = (u['subInfo'] as String).toLowerCase();
        return name.contains(q) || id.contains(q) || sub.contains(q);
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildUserFilterChip('Semua (${_userList.length})', 0),
              _buildUserFilterChip('Siswa (${_userList.where((u) => u['role'] == 'Siswa').length})', 1),
              _buildUserFilterChip('Guru (${_userList.where((u) => u['role'] == 'Guru').length})', 2),
              _buildUserFilterChip('Staf Sapras (${_userList.where((u) => u['role'] == 'Sapras').length})', 3),
              _buildUserFilterChip('Admin IT (${_userList.where((u) => u['role'] == 'Admin').length})', 4),
            ],
          ),
          const SizedBox(height: 16),

          // Tabel Pengguna
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: filteredUsers.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text('Tidak ada pengguna yang cocok dengan pencarian.', style: TextStyle(color: _textSecondary, fontSize: 13)),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      const minWidth = 860.0;
                      final tableWidth = constraints.maxWidth > minWidth ? constraints.maxWidth : minWidth;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: tableWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header
                              Container(
                                height: 42,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8FAFC),
                                  border: Border(bottom: BorderSide(color: _borderColor)),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(flex: 30, child: Text('NAMA LENGKAP PENGGUNA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 18, child: Text('NOMOR INDUK (NIS/NUPTK)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 14, child: Text('PERAN (ROLE)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 18, child: Text('KELAS / JABATAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 16, child: Text('STATUS BIOMETRIK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    SizedBox(width: 90, child: Text('AKSI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                  ],
                                ),
                              ),

                              // Baris Data
                              ...List.generate(filteredUsers.length, (index) {
                                final u = filteredUsers[index];
                                final hasFace = u['hasFace'] as bool;
                                final role = u['role'] as String;

                                Color roleBg = const Color(0xFFEFF6FF);
                                Color roleFg = _primaryBlue;
                                if (role == 'Guru') {
                                  roleBg = const Color(0xFFDCFCE7);
                                  roleFg = const Color(0xFF16A34A);
                                } else if (role == 'Sapras') {
                                  roleBg = const Color(0xFFFEF3C7);
                                  roleFg = const Color(0xFFD97706);
                                } else if (role == 'Admin') {
                                  roleBg = const Color(0xFFF3E8FF);
                                  roleFg = const Color(0xFF7C3AED);
                                }

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: index.isOdd ? const Color(0xFFFAFAFA) : Colors.white,
                                    border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                                  ),
                                  child: Row(
                                    children: [
                                      // Nama & Avatar
                                      Expanded(
                                        flex: 30,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: roleFg.withValues(alpha: 0.15),
                                              child: Text(
                                                u['initials'],
                                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: roleFg),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                u['name'],
                                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: _textPrimary),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // NIS / NUPTK
                                      Expanded(
                                        flex: 18,
                                        child: Text(
                                          u['identifier'],
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Role
                                      Expanded(
                                        flex: 14,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                            decoration: BoxDecoration(color: roleBg, borderRadius: BorderRadius.circular(4)),
                                            child: Text(
                                              role,
                                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: roleFg),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Kelas / Jabatan
                                      Expanded(
                                        flex: 18,
                                        child: Text(
                                          u['subInfo'],
                                          style: const TextStyle(fontSize: 11.5, color: _textSecondary),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Status Wajah
                                      Expanded(
                                        flex: 16,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                            decoration: BoxDecoration(
                                              color: hasFace ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  hasFace ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                                  size: 11,
                                                  color: hasFace ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  hasFace ? 'Face Ready' : 'Belum Rekam',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: hasFace ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Aksi
                                      SizedBox(
                                        width: 90,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.lock_reset_rounded, size: 16, color: Color(0xFFD97706)),
                                              tooltip: 'Reset Password',
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () => _showResetPasswordDialog(u),
                                            ),
                                            const SizedBox(width: 10),
                                            IconButton(
                                              icon: const Icon(Icons.face_retouching_natural_rounded, size: 16, color: _primaryBlue),
                                              tooltip: 'Reset Wajah',
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () => _showResetFaceDialog(u),
                                            ),
                                            const SizedBox(width: 10),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                                              tooltip: 'Hapus Pengguna',
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () => _confirmDeleteUser(u),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserFilterChip(String label, int index) {
    final isSelected = _selectedUserFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedUserFilter = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? _primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _primaryBlue : _borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : _textPrimary,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODUL 3: KATEGORI & MODEL ASET (CATEGORIES)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCategoriesView(bool isDesktop, double screenWidth) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Struktur Taksonomi & Standar Kategori Inventaris',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Master kategori digunakan untuk menetapkan prefix barcode, penanggung jawab kejuruan, dan batas waktu peminjaman.',
            style: TextStyle(fontSize: 12, color: _textSecondary),
          ),
          const SizedBox(height: 16),

          // Grid Kategori
          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = constraints.maxWidth > 800
                  ? (constraints.maxWidth - 16) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _categoryList.map((cat) {
                  return Container(
                    width: cardWidth,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: (cat['bg'] as Color),
                              child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat['name'] as String,
                                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: _textPrimary),
                                  ),
                                  Text(
                                    'Prefix Barcode: ${cat['prefix']} • ID: ${cat['id']}',
                                    style: const TextStyle(fontSize: 11, color: _textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${cat['itemCount']} Unit',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          cat['desc'] as String,
                          style: const TextStyle(fontSize: 12, height: 1.4, color: _textSecondary),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Durasi: ${cat['borrowLimit']}',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: cat['color'] as Color),
                            ),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => _showEditCategoryDialog(cat),
                                  icon: const Icon(Icons.edit_outlined, size: 14),
                                  label: const Text('Edit Standar', style: TextStyle(fontSize: 11)),
                                  style: TextButton.styleFrom(foregroundColor: _primaryBlue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODUL 4: MASTER RUANG & DENAH (ROOMS)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildRoomsView(bool isDesktop, double screenWidth) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Direktori Fasilitas, Gedung & Rak Penyimpanan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Setiap alat dan mesin inventaris wajib ditugaskan ke salah satu ruangan atau nomor rak resmi berikut.',
            style: TextStyle(fontSize: 12, color: _textSecondary),
          ),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = constraints.maxWidth > 800
                  ? (constraints.maxWidth - 16) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _roomList.map((room) {
                  return Container(
                    width: cardWidth,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFFEFF6FF),
                              child: Icon(room['icon'] as IconData, color: _primaryBlue, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    room['name'] as String,
                                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: _textPrimary),
                                  ),
                                  Text(
                                    '${room['building']} • Kode: ${room['code']}',
                                    style: const TextStyle(fontSize: 11, color: _textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: room['statusBg'] as Color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                room['status'] as String,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: room['statusColor'] as Color),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Kapasitas: ${room['capacity']}', style: const TextStyle(fontSize: 11.5, color: _textPrimary)),
                              Text('PJ: ${room['supervisor']}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: _primaryBlue)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODUL 5: AUDIT LOG SISTEM (SECURITY AUDIT)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildAuditLogView(bool isDesktop, double screenWidth) {
    final filteredLogs = _auditLogs.where((log) {
      if (_selectedAuditFilter == 1 && !log['action'].toString().contains('LOGIN')) return false;
      if (_selectedAuditFilter == 2 && !log['action'].toString().contains('STATUS')) return false;
      if (_selectedAuditFilter == 3 && !log['action'].toString().contains('PASSWORD') && !log['action'].toString().contains('FACE')) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final u = (log['user'] as String).toLowerCase();
        final a = (log['action'] as String).toLowerCase();
        final d = (log['desc'] as String).toLowerCase();
        return u.contains(q) || a.contains(q) || d.contains(q);
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAuditFilterChip('Semua Catatan (${_auditLogs.length})', 0),
              _buildAuditFilterChip('Autentikasi & Login', 1),
              _buildAuditFilterChip('Aset & Operasional', 2),
              _buildAuditFilterChip('Keamanan & Sandi', 3),
            ],
          ),
          const SizedBox(height: 16),

          // Tabel Log
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const minWidth = 820.0;
                final tableWidth = constraints.maxWidth > minWidth ? constraints.maxWidth : minWidth;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Baris
                        Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            border: Border(bottom: BorderSide(color: _borderColor)),
                          ),
                          child: const Row(
                            children: [
                              Expanded(flex: 20, child: Text('WAKTU (WIB)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                              SizedBox(width: 12),
                              Expanded(flex: 22, child: Text('AKTOR / PENGGUNA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                              SizedBox(width: 12),
                              Expanded(flex: 16, child: Text('TIPE AKSI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                              SizedBox(width: 12),
                              Expanded(flex: 36, child: Text('DESKRIPSI AKTIVITAS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                              SizedBox(width: 12),
                              Expanded(flex: 18, child: Text('ALAMAT IP / PERANGKAT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                              SizedBox(width: 12),
                              SizedBox(width: 72, child: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                            ],
                          ),
                        ),

                        // Data Baris
                        ...List.generate(filteredLogs.length, (index) {
                          final log = filteredLogs[index];
                          final isSuccess = log['status'] == 'SUCCESS';
                          final isWarn = log['status'] == 'WARNING';

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: index.isOdd ? const Color(0xFFFAFAFA) : Colors.white,
                              border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                            ),
                            child: Row(
                              children: [
                                // Waktu
                                Expanded(
                                  flex: 20,
                                  child: Text(
                                    log['time'],
                                    style: const TextStyle(fontSize: 11, color: _textSecondary),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Aktor
                                Expanded(
                                  flex: 22,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        log['user'],
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textPrimary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        log['role'],
                                        style: const TextStyle(fontSize: 10.5, color: _textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Tipe Aksi
                                Expanded(
                                  flex: 16,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: Text(
                                        log['actionBadge'],
                                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Deskripsi
                                Expanded(
                                  flex: 36,
                                  child: Text(
                                    log['desc'],
                                    style: const TextStyle(fontSize: 11.5, color: _textPrimary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // IP / Perangkat
                                Expanded(
                                  flex: 18,
                                  child: Text(
                                    log['ip'],
                                    style: const TextStyle(fontSize: 11, color: _textSecondary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Status
                                SizedBox(
                                  width: 72,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSuccess
                                            ? const Color(0xFFDCFCE7)
                                            : (isWarn ? const Color(0xFFFEF3C7) : const Color(0xFFFEF2F2)),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        log['status'],
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.bold,
                                          color: isSuccess
                                              ? const Color(0xFF15803D)
                                              : (isWarn ? const Color(0xFFB45309) : const Color(0xFFDC2626)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditFilterChip(String label, int index) {
    final isSelected = _selectedAuditFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedAuditFilter = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? _primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _primaryBlue : _borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : _textPrimary,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOG & FORM INTERAKTIF NYATA
  // ═══════════════════════════════════════════════════════════════════════════

  // A. Tambah Akun Baru
  void _showAddUserDialog() {
    final nameCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    final classCtrl = TextEditingController();
    String selectedRole = 'Siswa';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModal) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Row(
            children: [
              Icon(Icons.person_add_alt_1_rounded, color: _primaryBlue),
              SizedBox(width: 8),
              Text('Tambah Akun Pengguna Baru', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  decoration: const InputDecoration(labelText: 'Peran / Hak Akses', border: OutlineInputBorder(), isDense: true),
                  items: ['Siswa', 'Guru', 'Sapras', 'Admin'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (val) => setModal(() => selectedRole = val!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap', hintText: 'Contoh: Muhammad Ihsan', border: OutlineInputBorder(), isDense: true),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: idCtrl,
                  decoration: InputDecoration(
                    labelText: selectedRole == 'Siswa' ? 'Nomor Induk Siswa (NIS)' : (selectedRole == 'Guru' ? 'NUPTK' : 'Username Login'),
                    hintText: selectedRole == 'Siswa' ? 'Contoh: 22090301' : 'Contoh: 1988...',
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: classCtrl,
                  decoration: InputDecoration(
                    labelText: selectedRole == 'Siswa' ? 'Kelas & Konsentrasi' : 'Jabatan / Tugas',
                    hintText: selectedRole == 'Siswa' ? 'Contoh: XI RPL 2' : 'Contoh: Guru Produktif Otomotif',
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue, foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty || idCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Harap lengkapi nama dan identitas pengguna!'), backgroundColor: Colors.red),
                  );
                  return;
                }

                final parts = nameCtrl.text.trim().split(' ');
                final initials = parts.length > 1 ? '${parts[0][0]}${parts[1][0]}'.toUpperCase() : parts[0].substring(0, 2).toUpperCase();

                setState(() {
                  _userList.insert(0, {
                    'id': 'usr-${DateTime.now().millisecondsSinceEpoch}',
                    'name': nameCtrl.text.trim(),
                    'identifier': idCtrl.text.trim(),
                    'role': selectedRole,
                    'subInfo': classCtrl.text.trim().isNotEmpty ? classCtrl.text.trim() : '-',
                    'initials': initials,
                    'hasFace': false,
                    'status': 'Aktif',
                  });

                  _auditLogs.insert(0, {
                    'time': 'Baru saja',
                    'user': _currentUser.name,
                    'role': 'Admin',
                    'action': 'CREATE_USER',
                    'actionBadge': 'USER_ADD',
                    'desc': 'Mendaftarkan akun baru $selectedRole: ${nameCtrl.text.trim()} (${idCtrl.text.trim()}).',
                    'ip': '192.168.1.10 (Lab IT)',
                    'status': 'SUCCESS',
                    'color': const Color(0xFF16A34A),
                  });
                });

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Akun $selectedRole "${nameCtrl.text}" berhasil dibuat! Kata sandi bawaan: "123".'),
                    backgroundColor: const Color(0xFF16A34A),
                  ),
                );
              },
              child: const Text('Simpan Pengguna'),
            ),
          ],
        ),
      ),
    );
  }

  // B. Reset Password
  void _showResetPasswordDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset_rounded, color: Color(0xFFD97706)),
            SizedBox(width: 8),
            Text('Reset Kata Sandi Akun', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin mengatur ulang kata sandi untuk ${user['name']} (${user['identifier']}) ke sandi default ("123")?',
          style: const TextStyle(fontSize: 12.5, height: 1.4),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _auditLogs.insert(0, {
                  'time': 'Baru saja',
                  'user': _currentUser.name,
                  'role': 'Admin',
                  'action': 'RESET_PASSWORD',
                  'actionBadge': 'SECURITY',
                  'desc': 'Reset kata sandi ${user['name']} (${user['identifier']}) menjadi "123".',
                  'ip': '192.168.1.10 (Lab IT)',
                  'status': 'WARNING',
                  'color': const Color(0xFFD97706),
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kata sandi untuk ${user['name']} berhasil direset ke "123".'),
                  backgroundColor: const Color(0xFFD97706),
                ),
              );
            },
            child: const Text('Reset Sandi'),
          ),
        ],
      ),
    );
  }

  // C. Reset Profil Wajah Biometrik
  void _showResetFaceDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.face_retouching_natural_rounded, color: _primaryBlue),
            SizedBox(width: 8),
            Text('Reset Pendaftaran Wajah', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Reset biometrik akan mewajibkan ${user['name']} melakukan perekaman foto wajah ulang saat login berikutnya.',
          style: const TextStyle(fontSize: 12.5, height: 1.4),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                user['hasFace'] = false;
                _auditLogs.insert(0, {
                  'time': 'Baru saja',
                  'user': _currentUser.name,
                  'role': 'Admin',
                  'action': 'RESET_FACE_PROFILE',
                  'actionBadge': 'BIOMETRIK',
                  'desc': 'Mereset data biometrik wajah siswa/guru ${user['name']}.',
                  'ip': '192.168.1.10 (Lab IT)',
                  'status': 'WARNING',
                  'color': const Color(0xFFD97706),
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Data biometrik ${user['name']} berhasil direset. User wajib rekam ulang.'),
                  backgroundColor: _primaryBlue,
                ),
              );
            },
            child: const Text('Konfirmasi Reset Wajah'),
          ),
        ],
      ),
    );
  }

  // D. Hapus Pengguna
  void _confirmDeleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text('Hapus Akun Pengguna', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus akun ${user['name']} (${user['identifier']})? Tindakan ini akan dicatat ke dalam audit log.',
          style: const TextStyle(fontSize: 12.5, height: 1.4),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _userList.remove(user);
                _auditLogs.insert(0, {
                  'time': 'Baru saja',
                  'user': _currentUser.name,
                  'role': 'Admin',
                  'action': 'DELETE_USER',
                  'actionBadge': 'USER_DEL',
                  'desc': 'Menghapus permanen akun ${user['name']} (${user['identifier']}).',
                  'ip': '192.168.1.10 (Lab IT)',
                  'status': 'FAILED',
                  'color': const Color(0xFFDC2626),
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Akun ${user['name']} berhasil dihapus dari sistem.'),
                  backgroundColor: const Color(0xFFDC2626),
                ),
              );
            },
            child: const Text('Hapus Akun'),
          ),
        ],
      ),
    );
  }

  // E. Tambah Kategori Aset
  void _showAddCategoryDialog() {
    final nameCtrl = TextEditingController();
    final prefixCtrl = TextEditingController();
    final limitCtrl = TextEditingController(text: '1 Hari Praktikum');
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.category_outlined, color: _primaryBlue),
            SizedBox(width: 8),
            Text('Tambah Kategori Aset Baru', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Kategori', hintText: 'Contoh: Alat Jaringan & Fiber Optik', border: OutlineInputBorder(), isDense: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: prefixCtrl,
                decoration: const InputDecoration(labelText: 'Prefix Barcode', hintText: 'Contoh: FO- atau NET-', border: OutlineInputBorder(), isDense: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: limitCtrl,
                decoration: const InputDecoration(labelText: 'Batas Peminjaman Default', border: OutlineInputBorder(), isDense: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Deskripsi Cakupan Alat', hintText: 'Contoh: Fusion Splicer, OPM, VFL...', border: OutlineInputBorder(), isDense: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue, foregroundColor: Colors.white),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty || prefixCtrl.text.trim().isEmpty) return;

              setState(() {
                _categoryList.add({
                  'id': 'CAT-0${_categoryList.length + 1}',
                  'name': nameCtrl.text.trim(),
                  'prefix': prefixCtrl.text.trim().toUpperCase(),
                  'itemCount': 0,
                  'borrowLimit': limitCtrl.text.trim(),
                  'icon': Icons.inventory_2_outlined,
                  'color': _primaryBlue,
                  'bg': const Color(0xFFEFF6FF),
                  'desc': descCtrl.text.trim(),
                });
              });

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kategori "${nameCtrl.text}" berhasil ditambahkan.'),
                  backgroundColor: const Color(0xFF16A34A),
                ),
              );
            },
            child: const Text('Simpan Kategori'),
          ),
        ],
      ),
    );
  }

  // F. Edit Kategori
  void _showEditCategoryDialog(Map<String, dynamic> cat) {
    final limitCtrl = TextEditingController(text: cat['borrowLimit']);
    final descCtrl = TextEditingController(text: cat['desc']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.edit_outlined, color: cat['color'] as Color),
            const SizedBox(width: 8),
            Text('Edit Aturan ${cat['name']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: limitCtrl,
                decoration: const InputDecoration(labelText: 'Batas Durasi Peminjaman', border: OutlineInputBorder(), isDense: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Deskripsi Barang', border: OutlineInputBorder(), isDense: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                cat['borrowLimit'] = limitCtrl.text.trim();
                cat['desc'] = descCtrl.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aturan kategori berhasil diperbarui.'), backgroundColor: Color(0xFF16A34A)),
              );
            },
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  // G. Tambah Ruang Baru
  void _showAddRoomDialog() {
    final nameCtrl = TextEditingController();
    final buildingCtrl = TextEditingController();
    final pjCtrl = TextEditingController();
    final capCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.meeting_room_outlined, color: _primaryBlue),
            SizedBox(width: 8),
            Text('Tambah Master Ruangan / Rak', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Ruangan / Area Rak', hintText: 'Contoh: Lab Robotika & IoT', border: OutlineInputBorder(), isDense: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: buildingCtrl,
                decoration: const InputDecoration(labelText: 'Gedung & Lokasi Lantai', hintText: 'Contoh: Gedung A, Lantai 3', border: OutlineInputBorder(), isDense: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pjCtrl,
                decoration: const InputDecoration(labelText: 'Penanggung Jawab Ruang', hintText: 'Contoh: Hendra Kusuma, S.T.', border: OutlineInputBorder(), isDense: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: capCtrl,
                decoration: const InputDecoration(labelText: 'Kapasitas Siswa / Rak', hintText: 'Contoh: 36 Siswa Praktik', border: OutlineInputBorder(), isDense: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue, foregroundColor: Colors.white),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;

              setState(() {
                _roomList.add({
                  'code': 'R-NEW${_roomList.length + 1}',
                  'name': nameCtrl.text.trim(),
                  'building': buildingCtrl.text.trim(),
                  'supervisor': pjCtrl.text.trim().isNotEmpty ? pjCtrl.text.trim() : 'Staf Sarpras',
                  'capacity': capCtrl.text.trim().isNotEmpty ? capCtrl.text.trim() : '-',
                  'status': 'Siap Operasional',
                  'statusColor': const Color(0xFF16A34A),
                  'statusBg': const Color(0xFFDCFCE7),
                  'icon': Icons.meeting_room_outlined,
                });
              });

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ruangan "${nameCtrl.text}" berhasil didaftarkan ke sistem.'),
                  backgroundColor: const Color(0xFF16A34A),
                ),
              );
            },
            child: const Text('Simpan Ruangan'),
          ),
        ],
      ),
    );
  }
}
