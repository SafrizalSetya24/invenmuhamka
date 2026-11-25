import 'package:flutter/material.dart';

import '../../../data/dummy_data.dart';
import '../../../utils/logout_helper.dart';
import '../views/sapras_consumables_view.dart';
import '../views/sapras_inventory_view.dart';
import '../views/sapras_handover_view.dart';
import '../views/sapras_return_view.dart';
import '../views/sapras_repair_view.dart';
import '../views/sapras_approval_view.dart';
import '../views/sapras_feedback_view.dart';
import '../views/sapras_notifications_view.dart';

class SaprasDashboardPage extends StatefulWidget {
  final UserModel? user;
  const SaprasDashboardPage({super.key, this.user});

  @override
  State<SaprasDashboardPage> createState() => _SaprasDashboardPageState();
}

class _SaprasDashboardPageState extends State<SaprasDashboardPage> {
  // Warna Desain Selaras dengan Identitas SMK Muhammadiyah Kramat
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _lightBg = Color(0xFFF3F6FC);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedSidebarIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _unreadNotifCount = 3;

  // Status Operasional Loket Sarpras (Interaktif)
  String _loketStatus = 'Loket Dibuka • Shift Pagi';
  Color _loketStatusFg = const Color(0xFF15803D);
  Color _loketStatusBg = const Color(0xFFDCFCE7);
  Color _loketStatusBorder = const Color(0xFFBBF7D0);
  IconData _loketStatusIcon = Icons.check_circle_rounded;

  UserModel get _currentUser =>
      widget.user ?? DummyData.users[2]; // Bambang Irawan

  // Data Peminjaman Aktif yang dapat di-update secara interaktif oleh Sapras
  final List<Map<String, dynamic>> _dueItems = [
    {
      'id': 'TR-202611-0012',
      'item': 'Multimeter Digital Sanwa',
      'code': 'EL-MLT-012',
      'borrower': 'Ahmad Zulfikar',
      'class': 'XI TITL 1',
      'due': '14:00 WIB',
      'isLate': false,
      'status': 'Jatuh Tempo',
      'statusColor': const Color(0xFF6366F1),
      'statusBg': const Color(0xFFEEF2FF),
    },
    {
      'id': 'TR-202611-0018',
      'item': 'Camera Sony Alpha A6400',
      'code': 'CAM-DKV-003',
      'borrower': 'Retno Wahyuni, S.Sn',
      'class': 'Guru Produktif',
      'due': '15:30 WIB',
      'isLate': false,
      'status': 'Dipakai',
      'statusColor': _primaryBlue,
      'statusBg': const Color(0xFFEFF6FF),
    },
    {
      'id': 'TR-202611-0021',
      'item': 'Diagnostic Scanner OBD-II',
      'code': 'TKR-OBD-008',
      'borrower': 'Dedi Prasetyo',
      'class': 'XII TKRO 2',
      'due': '16:00 WIB',
      'isLate': false,
      'status': 'Tepat Waktu',
      'statusColor': const Color(0xFF475569),
      'statusBg': const Color(0xFFF1F5F9),
    },
    {
      'id': 'TR-202611-0009',
      'item': 'LCD Projector Epson EB-X500',
      'code': 'PRJ-EPS-005',
      'borrower': 'Siti Aminah, M.Pd',
      'class': 'Guru Umum',
      'due': 'Lewat 25 Mnt',
      'isLate': true,
      'status': 'Terlambat',
      'statusColor': const Color(0xFFDC2626),
      'statusBg': const Color(0xFFFEF2F2),
    },
  ];

  List<Map<String, dynamic>> get _filteredDueItems {
    if (_searchQuery.trim().isEmpty) return _dueItems;
    final q = _searchQuery.toLowerCase();
    return _dueItems.where((d) {
      final item = d['item'].toString().toLowerCase();
      final code = d['code'].toString().toLowerCase();
      final borrower = d['borrower'].toString().toLowerCase();
      final cls = d['class'].toString().toLowerCase();
      return item.contains(q) ||
          code.contains(q) ||
          borrower.contains(q) ||
          cls.contains(q);
    }).toList();
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
          // Sidebar Navigasi Kiri (Desktop)
          if (isDesktop) _buildSidebar(),

          // Konten Utama Dashboard
          Expanded(
            child: Column(
              children: [
                _buildHeader(isDesktop, screenWidth),
                Expanded(child: _buildCurrentView(isDesktop, screenWidth)),
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

  Widget _buildCurrentView(bool isDesktop, double screenWidth) {
    switch (_selectedSidebarIndex) {
      case 0:
        return _buildOverviewDashboard(isDesktop, screenWidth);
      case 1:
        return SaprasApprovalView(
          isDesktop: isDesktop,
          screenWidth: screenWidth,
        );
      case 2:
        return SaprasHandoverView(
          isDesktop: isDesktop,
          screenWidth: screenWidth,
        );
      case 3:
        return SaprasReturnView(isDesktop: isDesktop, screenWidth: screenWidth);
      case 4:
        return SaprasInventoryView(
          isDesktop: isDesktop,
          screenWidth: screenWidth,
        );
      case 5:
        return SaprasConsumablesView(
          isDesktop: isDesktop,
          screenWidth: screenWidth,
        );
      case 6:
        return SaprasRepairView(isDesktop: isDesktop, screenWidth: screenWidth);
      case 7:
        return SaprasFeedbackView(
          isDesktop: isDesktop,
          screenWidth: screenWidth,
        );
      case 8:
        return SaprasNotificationsView(
          isDesktop: isDesktop,
          screenWidth: screenWidth,
          onNavigateTab: (tabIndex) =>
              setState(() => _selectedSidebarIndex = tabIndex),
        );
      default:
        return _buildOverviewDashboard(isDesktop, screenWidth);
    }
  }

  Widget _buildOverviewDashboard(bool isDesktop, double screenWidth) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 36 : (screenWidth < 500 ? 14 : 20),
        vertical: screenWidth < 500 ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Profil & Salam Petugas (Sesuai Gaya Portal Siswa)
          _buildStaffProfileBanner(screenWidth),
          const SizedBox(height: 18),

          // 2. 4 Kartu Ringkasan Status
          _buildDashboardMetricGrid(screenWidth),
          const SizedBox(height: 22),

          // 3. Peminjaman Alat Hari Ini
          _buildDueBorrowingSection(screenWidth),
          const SizedBox(height: 22),

          // 4. Kondisi Ruang Praktik & Bengkel
          _buildLabReadinessSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ─── 1. SIDEBAR NAVIGASI SAPRAS (FLOATING CARD STYLE) ──────────────────────
  Widget _buildSidebar({bool isDrawer = false}) {
    return Container(
      width: 255,
      margin: isDrawer
          ? const EdgeInsets.fromLTRB(14, 14, 14, 14)
          : const EdgeInsets.fromLTRB(16, 16, 14, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0038A8),
            Color(0xFF061A40),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF061A40).withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Logo Header (Creovative Panel Style)
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
                        'SMK Muhammadiyah Kramat',
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
                // Group 1: UTAMA
                _buildSidebarGroupHeader('UTAMA'),
                _buildSidebarNavItem(
                  0,
                  Icons.dashboard_rounded,
                  'Dashboard',
                  onTap: () {
                    setState(() => _selectedSidebarIndex = 0);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                _buildSidebarNavItem(
                  1,
                  Icons.assignment_turned_in_outlined,
                  'Persetujuan Pinjam',
                  badge: '12 Antrean',
                  onTap: () {
                    setState(() => _selectedSidebarIndex = 1);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                _buildSidebarNavItem(
                  2,
                  Icons.qr_code_scanner_rounded,
                  'Penyerahan Barang',
                  onTap: () {
                    setState(() => _selectedSidebarIndex = 2);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                _buildSidebarNavItem(
                  3,
                  Icons.fact_check_outlined,
                  'Pengembalian Fisik',
                  badge: '8 Unit',
                  onTap: () {
                    setState(() => _selectedSidebarIndex = 3);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),

                const SizedBox(height: 12),
                // Group 2: INVENTARIS & LOGISTIK
                _buildSidebarGroupHeader('INVENTARIS & LOGISTIK'),
                _buildSidebarNavItem(
                  4,
                  Icons.inventory_2_outlined,
                  'Katalog & Inventaris',
                  onTap: () {
                    setState(() => _selectedSidebarIndex = 4);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                _buildSidebarNavItem(
                  5,
                  Icons.category_outlined,
                  'Bahan Habis Pakai',
                  badge: '3 Menipis',
                  onTap: () {
                    setState(() => _selectedSidebarIndex = 5);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                _buildSidebarNavItem(
                  6,
                  Icons.build_outlined,
                  'Antrean Perbaikan',
                  badge: '14 Servis',
                  onTap: () {
                    setState(() => _selectedSidebarIndex = 6);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),

                const SizedBox(height: 12),
                // Group 3: LAYANAN
                _buildSidebarGroupHeader('LAYANAN'),
                _buildSidebarNavItem(
                  7,
                  Icons.chat_bubble_outline_rounded,
                  'Keluhan Fasilitas',
                  badge: '5 Baru',
                  onTap: () {
                    setState(() => _selectedSidebarIndex = 7);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                _buildSidebarNavItem(
                  8,
                  Icons.notifications_none_rounded,
                  'Riwayat Notifikasi',
                  badge: _unreadNotifCount > 0 ? '$_unreadNotifCount' : null,
                  onTap: () {
                    setState(() => _selectedSidebarIndex = 8);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),

                const SizedBox(height: 12),
                // Group 4: AKUN
                _buildSidebarGroupHeader('AKUN'),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        child: Text(
                          _currentUser.initials,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentUser.name,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Kepala Unit Sarpras',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
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
    final isSelected = _selectedSidebarIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withValues(alpha: 0.18)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        dense: true,
        horizontalTitleGap: 10,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        leading: Icon(
          icon,
          size: 19,
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.8),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.85),
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 2.5,
                ),
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
        onTap: onTap ?? () => setState(() => _selectedSidebarIndex = index),
      ),
    );
  }

  // ─── 2. TOP HEADER ────────────────────────────────────────────────────────
  Widget _buildHeader(bool isDesktop, double screenWidth) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final showSearchInput = availableWidth >= 780;
        final showSearchBtn = !showSearchInput && availableWidth >= 480;
        final showScan = availableWidth >= 880;

        return Container(
          height: 64,
          margin: isDesktop
              ? const EdgeInsets.fromLTRB(0, 16, 20, 0)
              : EdgeInsets.zero,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isDesktop
                ? BorderRadius.circular(16)
                : BorderRadius.zero,
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

              // Breadcrumbs (Auto ellipsis, takes remaining available space)
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.dashboard_outlined,
                      size: 16,
                      color: _primaryBlue,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _getBreadcrumbCategory(),
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: _textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '/',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        _getBreadcrumbTitle(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Action Buttons (Seragam dengan grid tinggi 38px)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Scan QR Button (38px)
                  if (showScan) ...[
                    SizedBox(
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: () => _showScanBarcodeQuickDialog(),
                        icon: const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Scan QR',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // 2. Search Box / Icon (38px)
                  if (showSearchInput)
                    Container(
                      width: availableWidth >= 1100
                          ? 240
                          : (availableWidth >= 900 ? 200 : 170),
                      height: 38,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: _textPrimary,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Cari alat, tiket...',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 17,
                            color: Color(0xFF94A3B8),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 34,
                            minHeight: 34,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(right: 12),
                        ),
                      ),
                    )
                  else if (showSearchBtn)
                    Container(
                      width: 38,
                      height: 38,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: IconButton(
                        tooltip: 'Cari Aset / Tiket',
                        icon: const Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: Color(0xFF475569),
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () => _showQuickSearchModal(),
                      ),
                    ),

                  // 3. Panduan Button (38x38)
                  Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: IconButton(
                      tooltip: 'Panduan Operasional Sarpras',
                      icon: const Icon(
                        Icons.help_outline_rounded,
                        size: 19,
                        color: Color(0xFF475569),
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => _showHelpGuideDialog(),
                    ),
                  ),

                  // 4. Notifications Bell dengan Dropdown ala FB Desktop (38x38)
                  PopupMenuButton<void>(
                    tooltip: 'Notifikasi',
                    offset: const Offset(0, 46),
                    elevation: 12,
                    shadowColor: Colors.black.withValues(alpha: 0.18),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            size: 20,
                            color: Color(0xFF475569),
                          ),
                          if (_unreadNotifCount > 0)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(3.5),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDC2626),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$_unreadNotifCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem<void>(
                        enabled: false,
                        padding: EdgeInsets.zero,
                        child: _buildFacebookStyleNotificationDropdown(context),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getBreadcrumbCategory() {
    switch (_selectedSidebarIndex) {
      case 0:
        return 'Portal Sarpras';
      case 1:
        return 'Sirkulasi Harian';
      case 2:
        return 'Operasional Loket';
      case 3:
        return 'Operasional Sarpras';
      case 4:
        return 'Modul Logistik Sarpras';
      case 5:
        return 'Sarana & Prasarana';
      case 6:
        return 'Divisi Sarana & Prasarana';
      case 7:
        return 'Layanan & Aspirasi';
      case 8:
        return 'Pemberitahuan Sistem';
      default:
        return 'Portal Sarpras';
    }
  }

  String _getBreadcrumbTitle() {
    switch (_selectedSidebarIndex) {
      case 0:
        return 'Ringkasan Utama';
      case 1:
        return 'Persetujuan Pinjaman';
      case 2:
        return 'Penyerahan Barang';
      case 3:
        return 'Pemeriksaan Pengembalian';
      case 4:
        return 'Katalog & Unit Aset';
      case 5:
        return 'Bahan Habis Pakai (BHP)';
      case 6:
        return 'Antrean Perbaikan & Servis';
      case 7:
        return 'Keluhan Fasilitas';
      case 8:
        return 'Riwayat Notifikasi Sarpras';
      default:
        return 'Ringkasan Utama';
    }
  }

  void _showScanBarcodeQuickDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Scan QR / Barcode Cepat',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 80,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Arahkan scanner ke tiket atau label unit inventaris',
              style: TextStyle(fontSize: 11.5, color: _textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue),
            onPressed: () {
              Navigator.pop(ctx);
              _showHandoverScanDialog();
            },
            child: const Text(
              'Simulasi Tiket Loket',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickSearchModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Pencarian Cepat Aset / Tiket',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 380,
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: const InputDecoration(
              hintText: 'Ketik nama alat, nomor tiket, atau NIS siswa...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // ─── 3. PROFIL & SALAM PETUGAS (DENGAN AKSEN WARNA SEGAR) ───────────────
  Widget _buildStaffProfileBanner(double screenWidth) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bannerWidth = constraints.maxWidth;
        final showActionSide = bannerWidth >= 620;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEFF6FF), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
            boxShadow: [
              BoxShadow(
                color: _primaryBlue.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0038A8), Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryBlue.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _currentUser.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Portal Layanan Sarana & Prasarana',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Selamat Bertugas, ${_currentUser.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'NIP: ${_currentUser.identifier} • Kepala Unit Sarpras',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF475569),
                              ),
                            ),
                            InkWell(
                              onTap: _showLoketStatusDialog,
                              borderRadius: BorderRadius.circular(6),
                              child: Tooltip(
                                message: 'Klik untuk ubah status loket sarpras',
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _loketStatusBg,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _loketStatusBorder,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _loketStatusIcon,
                                        size: 11,
                                        color: _loketStatusFg,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _loketStatus,
                                        style: TextStyle(
                                          color: _loketStatusFg,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 13,
                                        color: _loketStatusFg,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (showActionSide) ...[
                    const SizedBox(width: 14),
                    ElevatedButton.icon(
                      onPressed: () => _showNewAssetDialog(),
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Tambah Barang Baru'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (!showActionSide) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showNewAssetDialog(),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Tambah Barang Baru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ─── 4. 4 KARTU METRIK RINGKASAN STATUS ───────────────────────────────────
  Widget _buildDashboardMetricGrid(double screenWidth) {
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 640 && screenWidth < 1024;

    final metrics = [
      _SaprasMetricData(
        title: 'Perlu Disetujui',
        value: '4 Pengajuan',
        caption: 'Permohonan pinjam alat baru',
        subCaption: 'Menunggu konfirmasi petugas',
        icon: Icons.assignment_turned_in_outlined,
        color: _primaryBlue,
        bgColor: const Color(0xFFEFF6FF),
        onTap: () => setState(() => _selectedSidebarIndex = 1),
      ),
      _SaprasMetricData(
        title: 'Sedang Dipinjam',
        value: '42 Unit',
        caption: 'Alat aktif di lab & bengkel',
        subCaption: '4 alat harus kembali hari ini',
        icon: Icons.schedule_rounded,
        color: const Color(0xFFD97706),
        bgColor: const Color(0xFFFFFBEB),
        onTap: () => setState(() => _selectedSidebarIndex = 2),
      ),
      _SaprasMetricData(
        title: 'Perlu Perbaikan',
        value: '14 Alat',
        caption: 'Alat dalam perawatan teknisi',
        subCaption: '6 menunggu suku cadang',
        icon: Icons.build_circle_outlined,
        color: const Color(0xFFDC2626),
        bgColor: const Color(0xFFFEF2F2),
        onTap: () => setState(() => _selectedSidebarIndex = 6),
      ),
      _SaprasMetricData(
        title: 'Laporan Masuk',
        value: '5 Laporan',
        caption: 'Aduan fasilitas dari warga sekolah',
        subCaption: '2 perlu dicek segera',
        icon: Icons.chat_bubble_outline_rounded,
        color: const Color(0xFF059669),
        bgColor: const Color(0xFFECFDF5),
        onTap: () => setState(() => _selectedSidebarIndex = 7),
      ),
    ];

    if (isDesktop) {
      return Row(
        children: metrics
            .map(
              (m) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _buildMetricCard(m),
                ),
              ),
            )
            .toList(),
      );
    } else if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricCard(metrics[0])),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricCard(metrics[1])),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildMetricCard(metrics[2])),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricCard(metrics[3])),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: metrics
            .map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildMetricCard(m),
              ),
            )
            .toList(),
      );
    }
  }

  Widget _buildMetricCard(_SaprasMetricData m) {
    return InkWell(
      onTap: m.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: m.color.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: m.color.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    m.title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: m.bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: m.color.withValues(alpha: 0.2)),
                  ),
                  child: Icon(m.icon, size: 18, color: m.color),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              m.value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              m.caption,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: m.bgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                m.subCaption,
                style: TextStyle(
                  fontSize: 10.5,
                  color: m.color,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 5. KESIAPAN FASILITAS LAB & BENGKEL ───────────────────────────────────
  Widget _buildLabReadinessSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kondisi Ruang Praktik & Bengkel',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Kesiapan fasilitas dan kelengkapan peralatan praktikum kejuruan',
                    style: TextStyle(fontSize: 11.5, color: _textSecondary),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showFacilityFloorPlanDialog(),
                borderRadius: BorderRadius.circular(6),
                child: const Row(
                  children: [
                    Text(
                      'Lihat Denah Fasilitas',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: _primaryBlue,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: _primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4 Ruang Praktik
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildRoomCard(
                title: 'Lab Komputer RPL 1 & 2',
                status: 'Siap Praktik',
                statusBg: const Color(0xFFDCFCE7),
                statusColor: const Color(0xFF16A34A),
                icon: Icons.computer_rounded,
                desc: '72 unit komputer PC siap digunakan untuk kegiatan praktikum pemrograman.',
              ),
              _buildRoomCard(
                title: 'Bengkel Praktik TKRO',
                status: 'Beroperasi',
                statusBg: const Color(0xFFFEF3C7),
                statusColor: const Color(0xFFD97706),
                icon: Icons.directions_car_outlined,
                desc: '6 car lift aktif & alat scanner siap. 2 unit lift sedang servis berkala.',
              ),
              _buildRoomCard(
                title: 'Bengkel Fabrikasi & Las',
                status: 'Siap Praktik',
                statusBg: const Color(0xFFDCFCE7),
                statusColor: const Color(0xFF16A34A),
                icon: Icons.precision_manufacturing_outlined,
                desc: 'Peralatan las busur & tabung argon lengkap. Perlengkapan APD aman.',
              ),
              _buildRoomCard(
                title: 'Studio Multimedia & DKV',
                status: 'Siap Praktik',
                statusBg: const Color(0xFFDCFCE7),
                statusColor: const Color(0xFF16A34A),
                icon: Icons.videocam_outlined,
                desc: '29 kamera DSLR, tripod, dan set tata lampu studio siap dipinjam.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard({
    required String title,
    required String status,
    required Color statusBg,
    required Color statusColor,
    required IconData icon,
    required String desc,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 850
            ? (constraints.maxWidth - 36) / 4
            : (constraints.maxWidth > 480
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showRoomDetailsModal(
              title,
              status,
              statusBg,
              statusColor,
              icon,
              desc,
            ),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: cardWidth,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 16, color: _primaryBlue),
                          const SizedBox(width: 6),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        'Cek Kesiapan & Inventaris',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: _primaryBlue,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 12,
                        color: _primaryBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRoomDetailsModal(
    String title,
    String status,
    Color statusBg,
    Color statusColor,
    IconData icon,
    String desc,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(icon, color: _primaryBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                desc,
                style: const TextStyle(fontSize: 12.5, height: 1.4, color: _textPrimary),
              ),
              const SizedBox(height: 16),
              const Text(
                'Kesiapan Operasional Fasilitas:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textSecondary),
              ),
              const SizedBox(height: 8),
              _buildRoomCheckItem('Peralatan & Mesin Praktik', 'Lengkap & Terverifikasi'),
              _buildRoomCheckItem('Kelistrikan & Keselamatan (K3)', 'Standar Keamanan Terpenuhi'),
              _buildRoomCheckItem('Jadwal Praktik Hari Ini', '2 Sesi Terjadwal Siap Berjalan'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _selectedSidebarIndex = 4);
            },
            icon: const Icon(Icons.inventory_2_outlined, size: 14),
            label: const Text('Buka Katalog Alat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCheckItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF16A34A)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 11.5, color: _textPrimary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
        ],
      ),
    );
  }

  void _showLoketStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.storefront_rounded, color: _primaryBlue),
            SizedBox(width: 8),
            Text('Ubah Status Loket Sarpras', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoketStatusOption(
              label: 'Loket Dibuka • Shift Pagi',
              desc: 'Loket melayani peminjaman & pengembalian aktif',
              fg: const Color(0xFF15803D),
              bg: const Color(0xFFDCFCE7),
              border: const Color(0xFFBBF7D0),
              icon: Icons.check_circle_rounded,
              ctx: ctx,
            ),
            const SizedBox(height: 8),
            _buildLoketStatusOption(
              label: 'Istirahat Loket (12:00 - 13:00)',
              desc: 'Loket sementara ditutup untuk istirahat siang & ibadah',
              fg: const Color(0xFFB45309),
              bg: const Color(0xFFFEF3C7),
              border: const Color(0xFFFDE68A),
              icon: Icons.pause_circle_rounded,
              ctx: ctx,
            ),
            const SizedBox(height: 8),
            _buildLoketStatusOption(
              label: 'Loket Ditutup • Selesai Shift',
              desc: 'Operasional loket berakhir. Pengajuan baru diproses esok hari',
              fg: const Color(0xFFDC2626),
              bg: const Color(0xFFFEF2F2),
              border: const Color(0xFFFECACA),
              icon: Icons.cancel_rounded,
              ctx: ctx,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoketStatusOption({
    required String label,
    required String desc,
    required Color fg,
    required Color bg,
    required Color border,
    required IconData icon,
    required BuildContext ctx,
  }) {
    final isSelected = _loketStatus == label;

    return InkWell(
      onTap: () {
        setState(() {
          _loketStatus = label;
          _loketStatusFg = fg;
          _loketStatusBg = bg;
          _loketStatusBorder = border;
          _loketStatusIcon = icon;
        });
        Navigator.pop(ctx);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status operasional loket diubah menjadi "$label"'),
            backgroundColor: fg,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? bg : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? border : _borderColor, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: fg),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? fg : _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 11, color: _textSecondary),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, size: 18, color: fg),
          ],
        ),
      ),
    );
  }

  // ─── 6. PEMINJAMAN MENDEKATI JATUH TEMPO (TABEL OPERASIONAL) ─────────────
  Widget _buildDueBorrowingSection(double screenWidth) {
    final list = _filteredDueItems;

    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Peminjaman Alat Mendekati Jatuh Tempo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'Menampilkan hasil filter: "$_searchQuery" (${list.length} item)'
                          : 'Verifikasi dan pencatatan fisik barang sebelum pukul 16:00 WIB',
                      style: const TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showMassReminderDialog(),
                icon: const Icon(Icons.notifications_active_outlined, size: 16),
                label: const Text('Kirim Pengingat Masal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (list.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    size: 36,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tidak ditemukan peminjaman yang cocok dengan "$_searchQuery"',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _borderColor),
              ),
              clipBehavior: Clip.antiAlias,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const minTableWidth = 720.0;
                  final tableWidth = constraints.maxWidth > minTableWidth
                      ? constraints.maxWidth
                      : minTableWidth;

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
                              border: Border(
                                bottom: BorderSide(color: _borderColor),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 32,
                                  child: Text(
                                    'ALAT & SERI',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  flex: 26,
                                  child: Text(
                                    'PEMINJAM',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  flex: 18,
                                  child: Text(
                                    'BATAS WAKTU',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  flex: 14,
                                  child: Text(
                                    'STATUS',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                SizedBox(
                                  width: 96,
                                  child: Text(
                                    'AKSI',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Data Rows
                          ...List.generate(list.length, (index) {
                            final d = list[index];
                            final isLate = d['isLate'] as bool;
                            final isLast = index == list.length - 1;

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: index.isOdd
                                    ? const Color(0xFFFAFAFA)
                                    : Colors.white,
                                border: isLast
                                    ? null
                                    : const Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFF1F5F9),
                                        ),
                                      ),
                              ),
                              child: Row(
                                children: [
                                  // Alat & Seri
                                  Expanded(
                                    flex: 32,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.devices_other_rounded,
                                          size: 16,
                                          color: _primaryBlue,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                d['item'] as String,
                                                style: const TextStyle(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: _textPrimary,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                d['code'] as String,
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                  color: _textSecondary,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Peminjam
                                  Expanded(
                                    flex: 26,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          d['borrower'] as String,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _textPrimary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          d['class'] as String,
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            color: _textSecondary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Batas Waktu
                                  Expanded(
                                    flex: 18,
                                    child: Text(
                                      d['due'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isLate
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Status
                                  Expanded(
                                    flex: 14,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: d['statusBg'] as Color,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          d['status'] as String,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: d['statusColor'] as Color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Aksi
                                  SizedBox(
                                    width: 96,
                                    height: 32,
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          _showReturnInspectionDialog(d),
                                      icon: const Icon(
                                        Icons.check_circle_rounded,
                                        size: 14,
                                      ),
                                      label: const Text('Terima'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryBlue,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
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
          const SizedBox(height: 14),

          // Footer Tabel
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menampilkan ${list.length} dari ${_dueItems.length + 38} peminjaman aktif',
                style: const TextStyle(fontSize: 11.5, color: _textSecondary),
              ),
              InkWell(
                onTap: () => setState(() => _selectedSidebarIndex = 3),
                child: const Row(
                  children: [
                    Text(
                      'Lihat Semua Peminjaman',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: _primaryBlue,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: _primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODAL OPERASIONAL LENGKAP UNTUK PETUGAS SAPRAS
  // ═══════════════════════════════════════════════════════════════════════════

  // A0. Modal Denah Fasilitas Lab & Bengkel
  void _showFacilityFloorPlanDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Row(
          children: [
            Icon(Icons.map_outlined, color: _primaryBlue),
            SizedBox(width: 8),
            Text(
              'Denah Fasilitas & Kesiapan Ruang Praktik',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status kesiapan ruang praktik dan bengkel SMK Muhammadiyah Kramat:',
                style: TextStyle(fontSize: 12, color: _textSecondary),
              ),
              const SizedBox(height: 14),
              _buildFloorPlanTile(
                'Lab Komputer RPL 1 & 2',
                'Gedung A Lantai 2',
                '72 / 72 PC Siap & Prima',
                '100% Siap',
                const Color(0xFF16A34A),
              ),
              const SizedBox(height: 8),
              _buildFloorPlanTile(
                'Bengkel Praktik TKRO',
                'Gedung Workshop Selatan',
                '6 Car Lift Aktif, 2 Maintenance',
                '92% Siap',
                const Color(0xFFD97706),
              ),
              const SizedBox(height: 8),
              _buildFloorPlanTile(
                'Bengkel Fabrikasi & TPL',
                'Gedung Industri Barat',
                'Sirkulasi Normal, 1 Tabung Argon Menipis',
                '95% Siap',
                const Color(0xFFD97706),
              ),
              const SizedBox(height: 8),
              _buildFloorPlanTile(
                'Studio Multimedia & DKV',
                'Gedung B Lantai 1',
                '29 / 30 Kamera & Lighting Siap',
                '98% Siap',
                const Color(0xFF16A34A),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue),
            icon: const Icon(
              Icons.inventory_2_outlined,
              size: 14,
              color: Colors.white,
            ),
            label: const Text(
              'Kelola Aset di Lab',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _selectedSidebarIndex = 4);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloorPlanTile(
    String name,
    String loc,
    String note,
    String badge,
    Color badgeColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              Text(
                '$loc • $note',
                style: const TextStyle(fontSize: 10.5, color: _textSecondary),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // A. Modal Inspeksi Pengembalian Fisik
  void _showReturnInspectionDialog(Map<String, dynamic> item) {
    String selectedCondition = 'LAYAK_PAKAI';
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Row(
            children: [
              const Icon(Icons.fact_check_outlined, color: _primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Inspeksi Pengembalian: ${item['item']}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No. Transaksi: ${item['id']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: _textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Peminjam: ${item['borrower']} (${item['class']})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Kode Fisik: ${item['code']} • Batas: ${item['due']}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Pemeriksaan Fisik Barang:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Opsi Kondisi Fisik Modern Custom Chips
                InkWell(
                  onTap: () =>
                      setModalState(() => selectedCondition = 'LAYAK_PAKAI'),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: selectedCondition == 'LAYAK_PAKAI'
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedCondition == 'LAYAK_PAKAI'
                            ? const Color(0xFF16A34A)
                            : _borderColor,
                        width: selectedCondition == 'LAYAK_PAKAI' ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedCondition == 'LAYAK_PAKAI'
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: selectedCondition == 'LAYAK_PAKAI'
                              ? const Color(0xFF16A34A)
                              : Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Layak Pakai & Lengkap (Kembali ke Rak)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Status unit fisik akan otomatis diubah menjadi "AVAILABLE"',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setModalState(
                    () => selectedCondition = 'PERLU_DIPERBAIKI',
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedCondition == 'PERLU_DIPERBAIKI'
                          ? const Color(0xFFFEF2F2)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedCondition == 'PERLU_DIPERBAIKI'
                            ? const Color(0xFFDC2626)
                            : _borderColor,
                        width: selectedCondition == 'PERLU_DIPERBAIKI'
                            ? 1.5
                            : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedCondition == 'PERLU_DIPERBAIKI'
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: selectedCondition == 'PERLU_DIPERBAIKI'
                              ? const Color(0xFFDC2626)
                              : Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ada Kerusakan / Kendala (Kirim ke Servis)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Status akan dialihkan ke antrean "REPAIR"',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFFDC2626),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                TextField(
                  controller: notesController,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: 'Catatan Petugas (Opsional)',
                    hintText:
                        'Contoh: Kelengkapan kabel lengkap, lensa bersih...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _dueItems.removeWhere(
                    (element) => element['id'] == item['id'],
                  );
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      selectedCondition == 'LAYAK_PAKAI'
                          ? 'Pengembalian ${item['item']} diterima! Unit siap dipinjam kembali.'
                          : 'Barang ${item['item']} dicatat rusak dan dialihkan ke teknisi servis (REPAIR).',
                    ),
                    backgroundColor: selectedCondition == 'LAYAK_PAKAI'
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFDC2626),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Konfirmasi Pengembalian Fisik'),
            ),
          ],
        ),
      ),
    );
  }

  // B. Modal Input Aset Baru
  void _showNewAssetDialog() {
    final nameController = TextEditingController();
    final codeController = TextEditingController(
      text:
          'AST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
    );
    String category = 'Elektronika & Komputer';
    String room = 'Lab Komputer RPL 1';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Row(
            children: [
              Icon(Icons.add_box_rounded, color: _primaryBlue),
              SizedBox(width: 8),
              Text(
                'Pendaftaran Aset Inventaris Baru',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lengkapi spesifikasi unit fisik untuk didaftarkan ke sistem inventaris Sarpras.',
                    style: TextStyle(fontSize: 11.5, color: _textSecondary),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: 'Nama Barang / Model Aset',
                      hintText: 'Contoh: Kamera DSLR Canon EOS 200D',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: codeController,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: 'Kode Barcode / Nomor Seri',
                      hintText: 'Contoh: CAM-RPL-015',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Aset',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Elektronika & Komputer',
                        child: Text(
                          'Elektronika & Komputer',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Alat Multimedia & Audio',
                        child: Text(
                          'Alat Multimedia & Audio',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Peralatan Bengkel Otomotif',
                        child: Text(
                          'Peralatan Bengkel Otomotif',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Instrumen Kelistrikan',
                        child: Text(
                          'Instrumen Kelistrikan',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                    onChanged: (val) => setModalState(() => category = val!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: room,
                    decoration: const InputDecoration(
                      labelText: 'Lokasi Ruang / Rak Penempatan',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Lab Komputer RPL 1',
                        child: Text(
                          'Lab Komputer RPL 1',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Studio Multimedia & DKV',
                        child: Text(
                          'Studio Multimedia & DKV',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Bengkel Praktik TKRO',
                        child: Text(
                          'Bengkel Praktik TKRO',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Ruang Gudang Sarpras Gedung A',
                        child: Text(
                          'Ruang Gudang Sarpras Gedung A',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                    onChanged: (val) => setModalState(() => room = val!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Harap masukkan nama aset!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Aset "${nameController.text}" berhasil didaftarkan ke $room! Barcode siap dicetak.',
                    ),
                    backgroundColor: const Color(0xFF16A34A),
                    action: SnackBarAction(
                      label: 'Buka Katalog',
                      textColor: Colors.white,
                      onPressed: () => setState(() => _selectedSidebarIndex = 4),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan ke Katalog'),
            ),
          ],
        ),
      ),
    );
  }

  // D. Modal Handover / Scan Barcode
  void _showHandoverScanDialog() {
    final manualCodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModal) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Row(
            children: [
              Icon(Icons.qr_code_scanner_rounded, color: _primaryBlue),
              SizedBox(width: 8),
              Text(
                'Penyerahan Barang & Scan Barcode',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pindai barcode pada fisik alat yang akan diserahkan kepada siswa peminjam di loket:',
                  style: TextStyle(fontSize: 11.5, color: _textSecondary),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white70,
                        size: 36,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Arahkan Barcode Alat ke Kamera',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white38),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        onPressed: () {
                          setModal(() {
                            manualCodeController.text = 'CAM-DKV-003';
                          });
                        },
                        icon: const Icon(Icons.flash_on_rounded, size: 14, color: Colors.amber),
                        label: const Text('Simulasi Scan: CAM-DKV-003', style: TextStyle(fontSize: 10.5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Atau Input Nomor Seri Unit Manual:',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: manualCodeController,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Contoh: CAM-DKV-003 atau EL-MLT-012',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: manualCodeController.text.isNotEmpty
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18)
                        : null,
                  ),
                  onChanged: (val) => setModal(() {}),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final code = manualCodeController.text.trim().isNotEmpty
                    ? manualCodeController.text.trim()
                    : 'UNIT-FISIK-001';
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Serah-terima unit $code berhasil diverifikasi! Status tiket berubah menjadi BORROWED.',
                    ),
                    backgroundColor: const Color(0xFF16A34A),
                    action: SnackBarAction(
                      label: 'Buka Loket Penyerahan',
                      textColor: Colors.white,
                      onPressed: () => setState(() => _selectedSidebarIndex = 2),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Konfirmasi Serah-Terima (Handover)'),
            ),
          ],
        ),
      ),
    );
  }

  // F. Modal Pengingat Masal
  void _showMassReminderDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Row(
          children: [
            Icon(Icons.notifications_active_outlined, color: _primaryBlue),
            SizedBox(width: 8),
            Text(
              'Kirim Pengingat Pengembalian Masal',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Sistem akan mengirimkan push notification dan broadcast pesan ke seluruh siswa & guru yang jadwal peminjamannya berakhir hari ini pukul 16:00 WIB.',
          style: TextStyle(fontSize: 12.5, height: 1.4),
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
                const SnackBar(
                  content: Text(
                    'Pengingat berhasil disiarkan ke 42 peminjam aktif!',
                  ),
                  backgroundColor: Color(0xFF16A34A),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kirim Pengingat Sekarang'),
          ),
        ],
      ),
    );
  }

  // H. Dialog Bantuan / Panduan
  void _showHelpGuideDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded, color: _primaryBlue),
            SizedBox(width: 8),
            Text(
              'Panduan Penggunaan Petugas Sarpras',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Persetujuan Peminjaman: Cek permohonan siswa maks 2 jam sebelum kedaluwarsa.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            SizedBox(height: 6),
            Text(
              '2. Serah-Terima (Handover): Wajib scan barcode unit fisik saat siswa mengambil barang di loket.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            SizedBox(height: 6),
            Text(
              '3. Pengembalian Fisik: Klik tombol "Terima" pada tabel untuk cek kondisi kelayakan alat.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            SizedBox(height: 6),
            Text(
              '4. Keluhan Fasilitas: Tanggapi kritik/laporan kerusakan lab dari siswa & guru.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Paham'),
          ),
        ],
      ),
    );
  }

  // I. Dropdown Notifikasi ala Facebook Desktop
  Widget _buildFacebookStyleNotificationDropdown(BuildContext ctx) {
    return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Dropdown
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
            child: Row(
              children: [
                const Text(
                  'Notifikasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                if (_unreadNotifCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_unreadNotifCount Baru',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _primaryBlue,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (_unreadNotifCount > 0)
                  TextButton(
                    onPressed: () {
                      setState(() => _unreadNotifCount = 0);
                      Navigator.pop(ctx);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Tandai dibaca',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: _primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

          // Daftar Item Notifikasi
          _buildNotificationDropdownItem(
            ctx: ctx,
            icon: Icons.timer_outlined,
            iconBg: const Color(0xFFFEF3C7),
            iconFg: const Color(0xFFD97706),
            title: 'Permohonan Pinjam Segera Kedaluwarsa',
            desc: 'Kamera Canon EOS 200D • Sisa respon 15 menit',
            time: '10 mnt lalu',
            isUnread: _unreadNotifCount > 0,
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _selectedSidebarIndex = 1);
            },
          ),
          _buildNotificationDropdownItem(
            ctx: ctx,
            icon: Icons.warning_amber_rounded,
            iconBg: const Color(0xFFFEF2F2),
            iconFg: const Color(0xFFDC2626),
            title: 'Unit Terlambat Kembali',
            desc: 'Proyektor Epson EB-X500 (Siti Aminah - Lewat 25 Mnt)',
            time: '25 mnt lalu',
            isUnread: _unreadNotifCount > 1,
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _selectedSidebarIndex = 3);
            },
          ),
          _buildNotificationDropdownItem(
            ctx: ctx,
            icon: Icons.inventory_2_outlined,
            iconBg: const Color(0xFFEFF6FF),
            iconFg: _primaryBlue,
            title: 'Stok BHP Menipis',
            desc: 'Konektor RJ45 Cat6 tersisa 4 pack di gudang',
            time: '1 jam lalu',
            isUnread: _unreadNotifCount > 2,
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _selectedSidebarIndex = 5);
            },
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

          // Footer Buka Riwayat Lengkap Sarpras
          InkWell(
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _selectedSidebarIndex = 8);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: _primaryBlue,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, size: 16, color: _primaryBlue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationDropdownItem({
    required BuildContext ctx,
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String title,
    required String desc,
    required String time,
    required bool isUnread,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: isUnread ? const Color(0xFFF8FAFC) : Colors.white,
          border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 17, color: iconFg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _textSecondary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primaryBlue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SaprasMetricData {
  final String title;
  final String value;
  final String caption;
  final String subCaption;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  _SaprasMetricData({
    required this.title,
    required this.value,
    required this.caption,
    required this.subCaption,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });
}
