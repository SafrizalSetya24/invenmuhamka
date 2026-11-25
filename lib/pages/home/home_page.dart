import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/dummy_data.dart';
import '../../utils/logout_helper.dart';
import '../../utils/nav_helper.dart';
import '../cart/cart_page.dart';
import '../feedback/feedback_page.dart';
import '../history/borrowing_history_page.dart';
import '../notification/notification_page.dart';

class HomePage extends StatefulWidget {
  final UserModel? user;

  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Palet Warna Resmi SMK Muhammadiyah Kramat & Senada dengan Sarpras
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _deepNavy = Color(0xFF061A40);
  static const Color _lightBg = Color(0xFFF3F6FC);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  // Tab Index: 0 = Beranda, 1 = Katalog, 2 = Tiket QR, 3 = Profil
  int _currentTabIndex = 0;
  String _catalogSearchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();
  int _unreadNotifCount = 2;
  late List<Map<String, dynamic>> _notificationsList;

  // State Peminjaman Berjalan & Status Lifecycle Tiket Backend
  // Status backend: WAITING_APPROVAL, APPROVED, HANDED_OVER, RETURNED
  String _currentLoanStatus = 'APPROVED';
  late Map<String, dynamic> _activeLoan;
  bool _hasActiveLoan = true;
  String _studentClass = 'XII RPL 1';
  String? _customProfilePhoto;

  // State Filter Katalog
  String _selectedCategory = 'Semua';

  // State Pengembalian
  int _returnRating = 5;
  bool _condFisikUtuh = true;
  bool _condAksesorisLengkap = true;
  bool _condFungsiNormal = true;
  final TextEditingController _returnNotesCtrl = TextEditingController();

  UserModel get _currentUser =>
      widget.user ?? DummyData.users.first; // Default Safrizal / Siswa

  // Data Katalog Alat Realistis Sekolah (Sesuai Skema Backend: itemClass PER_UNIT vs CONSUMABLE)
  final List<Map<String, dynamic>> _catalogItems = [
    {
      'id': 'CAM-RPL-004',
      'name': 'Kamera DSLR Canon EOS 200D Kit',
      'category': 'Multimedia & DKV',
      'itemClass': 'PER_UNIT', // Wajib dikembalikan fisik
      'condition': 'LAYAK_PAKAI',
      'specs': 'Lensa 18-55mm IS STM, 24.2 MP, Dual Pixel AF, Tas & Baterai Cadangan',
      'stock': 3,
      'total': 4,
      'location': 'Studio Multimedia Gedung A',
      'icon': Icons.camera_alt_outlined,
      'isAvailable': true,
    },
    {
      'id': 'EL-RPL-001',
      'name': 'Toolkit Solder Digital Atten 936D',
      'category': 'Elektronika & IoT',
      'itemClass': 'PER_UNIT',
      'condition': 'LAYAK_PAKAI',
      'specs': 'Suhu Presisi 200-480°C, ESD Safe, Stand Solder, Timah & Desoldering Pump',
      'stock': 8,
      'total': 10,
      'location': 'Lab IoT & Hardware Lt. 2',
      'icon': Icons.precision_manufacturing_outlined,
      'isAvailable': true,
    },
    {
      'id': 'TKR-MES-002',
      'name': 'Multimeter Digital Sanwa CD800A',
      'category': 'Otomotif & Listrik',
      'itemClass': 'PER_UNIT',
      'condition': 'LAYAK_PAKAI',
      'specs': 'Auto-range, True RMS, Uji Kontinuitas Buzzer, Akurasi Tinggi',
      'stock': 5,
      'total': 6,
      'location': 'Bengkel Kelistrikan TKRO',
      'icon': Icons.speed_outlined,
      'isAvailable': true,
    },
    {
      'id': 'LAS-FAB-003',
      'name': 'Mesin Las Inverter Lakoni Falcon 120e',
      'category': 'Pengelasan & Fabrikasi',
      'itemClass': 'PER_UNIT',
      'condition': 'LAYAK_PAKAI',
      'specs': 'Daya 900 Watt, Ampere 10-120A, Dilengkapi Kedok Las & Tang Jepit',
      'stock': 2,
      'total': 3,
      'location': 'Bengkel Fabrikasi Gedung C',
      'icon': Icons.build_circle_outlined,
      'isAvailable': true,
    },
    {
      'id': 'IT-RPL-005',
      'name': 'Laptop Asus Vivobook 14 (Core i5)',
      'category': 'Komputer & IT',
      'itemClass': 'PER_UNIT',
      'condition': 'LAYAK_PAKAI',
      'specs': 'RAM 16GB, SSD 512GB, Terpasang Android Studio, VS Code, Cisco Packet Tracer',
      'stock': 4,
      'total': 5,
      'location': 'Lab Komputer RPL 1',
      'icon': Icons.laptop_mac_outlined,
      'isAvailable': true,
    },
    {
      'id': 'BHP-EL-006',
      'name': 'Starter Pack ESP32 & Modul Sensor',
      'category': 'Elektronika & IoT',
      'itemClass': 'CONSUMABLE', // Bahan habis pakai (stok berkurang, tidak perlu kembali)
      'condition': 'LAYAK_PAKAI',
      'specs': 'ESP32 Wi-Fi + Bluetooth, 12 Sensor, Breadboard, Kabel Jumper (Habis Pakai)',
      'stock': 12,
      'total': 15,
      'location': 'Ruang Sarpras Gedung B',
      'icon': Icons.memory_outlined,
      'isAvailable': true,
    },
    {
      'id': 'BHP-DKV-007',
      'name': 'Kertas Foto Glossy A4 & Tinta Pigment',
      'category': 'Multimedia & DKV',
      'itemClass': 'CONSUMABLE',
      'condition': 'LAYAK_PAKAI',
      'specs': 'Pack 20 Lembar 210 gsm, Tinta Cetak Studio DKV (Bahan Habis Pakai Praktikum)',
      'stock': 24,
      'total': 30,
      'location': 'Studio Multimedia Gedung A',
      'icon': Icons.photo_size_select_actual_outlined,
      'isAvailable': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _notificationsList = [
      {
        'id': 'notif-1',
        'title': 'Permohonan Peminjaman Disetujui',
        'desc': 'Petugas Sapras telah menyetujui permohonan 1 unit Kamera Canon EOS 200D Kit. Silakan ambil unit di loket Sarpras dalam batas waktu 30 menit.',
        'time': '10 menit yang lalu',
        'category': 'peminjaman',
        'isUnread': true,
        'icon': Icons.check_circle_outline_rounded,
        'color': const Color(0xFF16A34A),
        'action': 'ticket',
      },
      {
        'id': 'notif-2',
        'title': 'Batas Waktu Pengembalian Mendekati',
        'desc': 'Peminjaman Kamera Canon EOS 200D Kit berakhir hari ini pukul 15.30 WIB. Harap segera melakukan serah terima kembali ke petugas loket Sarpras.',
        'time': '1 jam yang lalu',
        'category': 'peminjaman',
        'isUnread': true,
        'icon': Icons.access_time_rounded,
        'color': const Color(0xFFEA580C),
        'action': 'return',
      },
      {
        'id': 'notif-3',
        'title': 'Profil Wajah Berhasil Didaftarkan',
        'desc': 'Verifikasi wajah Anda telah terdaftar untuk kemudahan serah terima inventaris tanpa tanda tangan manual.',
        'time': 'Kemarin',
        'category': 'sistem',
        'isUnread': false,
        'icon': Icons.verified_user_outlined,
        'color': _primaryBlue,
        'action': null,
      },
    ];
    _activeLoan = {
      'requestId': 'REQ-2026-0891',
      'ticketCode': 'TKT-2026-0891',
      'itemName': 'Kamera DSLR Canon EOS 200D Kit',
      'itemClass': 'PER_UNIT',
      'assignedUnitId': 'CAM-RPL-004-U1',
      'unitCondition': 'LAYAK_PAKAI',
      'category': 'Multimedia & DKV',
      'borrowDate': 'Hari Ini, 08:30 WIB',
      'dueDate': '15:30 WIB',
      'noShowDeadline': '09:00 WIB',
      'approvalDeadline': '10:30 WIB',
      'teacher': 'Bpk. Hendra, S.Kom (Kepala Lab RPL)',
      'purpose': 'Praktikum Pembuatan Video Profil Sekolah',
      'pickupLocation': 'Gudang Sarpras Gedung B (Lt. 1)',
      'officer': 'Bpk. Ahmad Dahlan (Petugas Loket)',
      'quantity': 1,
    };
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _returnNotesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 650;

    final Widget mobileApp = Scaffold(
      backgroundColor: _lightBg,
      appBar: _buildTopAppBar(),
      body: _buildCurrentTab(),
      bottomNavigationBar: _buildBottomNav(),
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
            child: mobileApp,
          ),
        ),
      );
    }

    return mobileApp;
  }

  Widget _buildCurrentTab() {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildCatalogTab();
      case 2:
        return _buildTicketTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  // ─── TOP APP BAR (1-TO-1 DENGAN MOCKUP GAMBAR USER) ───────────────────────
  PreferredSizeWidget _buildTopAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(66),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: _borderColor)),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              // Avatar Kotak Rounded Biru dengan Inisial (MR / SB)
              InkWell(
                onTap: () => setState(() => _currentTabIndex = 3),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: _customProfilePhoto == null
                        ? const LinearGradient(
                            colors: [_primaryBlue, Color(0xFF1D4ED8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    image: _customProfilePhoto != null
                        ? DecorationImage(
                            image: NetworkImage(_customProfilePhoto!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryBlue.withValues(alpha: 0.28),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: _customProfilePhoto == null
                      ? Text(
                          _currentUser.initials,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: -0.5,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),

              // Nama Siswa & Identitas Kelas/NIS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentUser.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _currentUser.role == 'Siswa'
                          ? 'NIS: ${_currentUser.identifier} • XII RPL 1'
                          : 'NUPTK: ${_currentUser.identifier} • Guru Produktif',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Bell Notifikasi dengan Badge Merah
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: _textPrimary, size: 24),
                    tooltip: 'Notifikasi',
                    onPressed: _showNotificationBottomSheet,
                  ),
                  if (_unreadNotifCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDC2626),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── BOTTOM NAVIGATION BAR (MENEMPEL DI BAWAH SCREEN TANPA CENTER) ────────
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _borderColor)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (idx) => setState(() => _currentTabIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primaryBlue,
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 11,
        unselectedFontSize: 10.5,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        elevation: 0,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.qr_code_2_rounded),
                if (_hasActiveLoan)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Tiket QR',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 0: BERANDA (PERSIS 1-TO-1 DENGAN GAMBAR USER)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Banner "Selamat Belajar, Muhammad Rizky" dengan Badge Hijau
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEBF3FE), Color(0xFFF6FAFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: _primaryBlue.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Belajar,\n${_currentUser.name}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                    height: 1.3,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF16A34A)),
                      const SizedBox(width: 4),
                      Text(
                        _currentUser.role == 'Siswa' ? 'Siswa Aktif' : 'Guru Aktif',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF15803D),
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Card "Peminjaman Berjalan"
          if (_hasActiveLoan) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Peminjaman Berjalan',
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Thumbnail Kamera / Alat
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 30, color: _primaryBlue),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeLoan['itemName'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: _textPrimary,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Badge Status Lifecycle Backend
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _currentLoanStatus == 'APPROVED'
                                    ? const Color(0xFFDCFCE7)
                                    : (_currentLoanStatus == 'HANDED_OVER' ? const Color(0xFFDBEAFE) : const Color(0xFFFEF3C7)),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _currentLoanStatus == 'APPROVED'
                                      ? const Color(0xFF86EFAC)
                                      : (_currentLoanStatus == 'HANDED_OVER' ? const Color(0xFF93C5FD) : const Color(0xFFFDE68A)),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: _currentLoanStatus == 'APPROVED'
                                          ? const Color(0xFF16A34A)
                                          : (_currentLoanStatus == 'HANDED_OVER' ? _primaryBlue : const Color(0xFFD97706)),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _currentLoanStatus == 'APPROVED'
                                        ? 'Siap Diambil di Loket'
                                        : (_currentLoanStatus == 'HANDED_OVER' ? 'Sedang Digunakan' : 'Menunggu Persetujuan'),
                                    style: GoogleFonts.poppins(
                                      color: _currentLoanStatus == 'APPROVED'
                                          ? const Color(0xFF15803D)
                                          : (_currentLoanStatus == 'HANDED_OVER' ? _primaryBlue : const Color(0xFFB45309)),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Keterangan Deadline Sesuai Backend
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      _currentLoanStatus == 'APPROVED'
                          ? 'Batas Pengambilan: ${_activeLoan['noShowDeadline']} (Loket Gudang Sarpras B)'
                          : (_currentLoanStatus == 'HANDED_OVER'
                              ? 'Harus Dikembalikan Sebelum: ${_activeLoan['dueDate']} (Unit: ${_activeLoan['assignedUnitId']})'
                              : 'Batas Review Petugas Sapras: 2 Jam sejak dibuat (${_activeLoan['approvalDeadline']})'),
                      style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dua Tombol Sesuai Lifecycle Backend
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _currentTabIndex = 2), // Ke Tiket QR
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            _currentLoanStatus == 'APPROVED' ? 'Buka Tiket Loket' : (_currentLoanStatus == 'HANDED_OVER' ? 'Lihat Tiket' : 'Status Permohonan'),
                            style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            if (_currentLoanStatus == 'HANDED_OVER') {
                              _showReturnInspectionDialog();
                            } else {
                              _showCancelLoanDialog();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _currentLoanStatus == 'HANDED_OVER' ? _textPrimary : const Color(0xFFDC2626),
                            side: BorderSide(color: _currentLoanStatus == 'HANDED_OVER' ? const Color(0xFFCBD5E1) : const Color(0xFFFCA5A5), width: 1.2),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            _currentLoanStatus == 'HANDED_OVER' ? 'Panduan Kembali' : 'Batalkan Pinjam',
                            style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 3. 4 Tombol Aksi Cepat (Scan Barcode, Katalog, Tiket, Riwayat)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickSquareAction(
                icon: Icons.qr_code_scanner_rounded,
                label: 'Scan Barcode',
                onTap: _showScanBarcodeQuickDialog,
              ),
              _buildQuickSquareAction(
                icon: Icons.grid_view_rounded,
                label: 'Katalog',
                onTap: () => setState(() => _currentTabIndex = 1),
              ),
              _buildQuickSquareAction(
                icon: Icons.confirmation_number_outlined,
                label: 'Tiket',
                onTap: () => setState(() => _currentTabIndex = 2),
              ),
              _buildQuickSquareAction(
                icon: Icons.history_rounded,
                label: 'Riwayat',
                onTap: () => NavHelper.navigateTo(context, BorrowingHistoryPage(user: _currentUser)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. 4 Kartu Metrik Ringkas (2x2 Grid Persis Mockup)
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: 'Alat Dipinjam:',
                  value: _hasActiveLoan ? '1 Unit' : '0 Unit',
                  onTap: () => setState(() => _currentTabIndex = 2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  title: 'Status Tiket:',
                  value: _hasActiveLoan ? 'Siap Diambil' : '0 Tiket',
                  onTap: () => setState(() => _currentTabIndex = 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: 'Keranjang:',
                  value: '0',
                  onTap: () => NavHelper.navigateTo(context, CartPage(user: _currentUser)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  title: 'Riwayat:',
                  value: '14',
                  onTap: () => NavHelper.navigateTo(context, BorrowingHistoryPage(user: _currentUser)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickSquareAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF334155), size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: _textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 1: KATALOG ALAT & FORM PENGAJUAN PINJAM (SESUAI BACKEND)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCatalogTab() {
    final categories = [
      'Semua',
      'Peralatan Praktik',
      'Bahan Praktik',
      'Multimedia & DKV',
      'Elektronika & IoT',
      'Otomotif & Listrik',
      'Pengelasan & Fabrikasi',
      'Komputer & IT',
    ];

    final filteredItems = _catalogItems.where((item) {
      bool matchesCat = true;
      if (_selectedCategory == 'Semua') {
        matchesCat = true;
      } else if (_selectedCategory == 'Peralatan Praktik') {
        matchesCat = item['itemClass'] == 'PER_UNIT';
      } else if (_selectedCategory == 'Bahan Praktik') {
        matchesCat = item['itemClass'] == 'CONSUMABLE';
      } else {
        matchesCat = item['category'] == _selectedCategory;
      }

      final q = _catalogSearchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          (item['name'] as String).toLowerCase().contains(q) ||
          (item['id'] as String).toLowerCase().contains(q);
      return matchesCat && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Box Mobile
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _borderColor),
            ),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) => setState(() => _catalogSearchQuery = val),
              style: GoogleFonts.poppins(fontSize: 12.5, color: _textPrimary),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Cari alat praktik, no seri...',
                hintStyle: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF94A3B8)),
                suffixIcon: _catalogSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 16),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _catalogSearchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.only(right: 12),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Category Chips Horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                    selectedColor: const Color(0xFFDBEAFE),
                    checkmarkColor: _primaryBlue,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? _primaryBlue : const Color(0xFF475569),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: isSelected ? _primaryBlue : _borderColor),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'Daftar Alat Praktik (${filteredItems.length} Tersedia)',
            style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.bold, color: _textPrimary),
          ),
          const SizedBox(height: 8),

          ...filteredItems.map((item) => _buildCatalogItemCard(item)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCatalogItemCard(Map<String, dynamic> item) {
    final stock = item['stock'] as int;
    final total = item['total'] as int;
    final isAvailable = stock > 0;
    final isPerUnit = item['itemClass'] == 'PER_UNIT';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isPerUnit ? const Color(0xFFF1F5F9) : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item['icon'] as IconData, color: isPerUnit ? _primaryBlue : const Color(0xFFD97706), size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: _textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        // Badge itemClass Backend (PER_UNIT vs CONSUMABLE)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: isPerUnit ? const Color(0xFFEFF6FF) : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isPerUnit ? 'Unit Fisik' : 'Bahan Praktik',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isPerUnit ? _primaryBlue : const Color(0xFFB45309),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${item['id']} • ${item['category']}',
                          style: GoogleFonts.poppins(fontSize: 10, color: _textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isAvailable ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isAvailable ? (isPerUnit ? '$stock/$total Unit' : 'Sisa $stock Pcs') : 'Habis',
                  style: GoogleFonts.poppins(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item['specs'] as String,
            style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF475569)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item['location'] as String,
                  style: GoogleFonts.poppins(fontSize: 10, color: _textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: isAvailable ? () => _showBorrowBottomSheet(item) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    isAvailable ? (isPerUnit ? '+ Pinjam Unit' : '+ Ambil Bahan') : 'Dipakai',
                    style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 2: TIKET DIGITAL SERAH TERIMA LOKET (SINKRON STATUS BACKEND)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTicketTab() {
    if (!_hasActiveLoan) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.confirmation_number_outlined, size: 60, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 12),
              Text('Tidak Ada Tiket Aktif', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Pilih barang di menu Katalog untuk mengajukan peminjaman baru.', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => setState(() => _currentTabIndex = 1),
                style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue),
                child: Text('Buka Katalog Alat', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector Simulasi Lifecycle Status Backend
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 14, color: _primaryBlue),
                    const SizedBox(width: 6),
                    Text(
                      'Pilihan Status Peminjaman:',
                      style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.bold, color: _textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusChip('APPROVED', 'Siap di Loket', const Color(0xFF16A34A)),
                    const SizedBox(width: 6),
                    _buildStatusChip('HANDED_OVER', 'Sedang Dipinjam', _primaryBlue),
                    const SizedBox(width: 6),
                    _buildStatusChip('WAITING_APPROVAL', 'Menunggu', const Color(0xFFD97706)),
                  ],
                ),
              ],
            ),
          ),

          // Kartu Tiket
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              children: [
                // Header Tiket
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _currentLoanStatus == 'APPROVED'
                          ? const [_primaryBlue, _deepNavy]
                          : (_currentLoanStatus == 'HANDED_OVER' ? const [Color(0xFF1E3A8A), Color(0xFF0F172A)] : const [Color(0xFFB45309), Color(0xFF78350F)]),
                    ),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/images/logo.png', width: 28, height: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentLoanStatus == 'APPROVED'
                                  ? 'TIKET SERAH TERIMA LOKET'
                                  : (_currentLoanStatus == 'HANDED_OVER' ? 'TIKET PEMINJAMAN AKTIF' : 'STATUS PENGAJUAN PINJAM'),
                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text('SMK Muhammadiyah Kramat', style: GoogleFonts.poppins(color: const Color(0xFFBFDBFE), fontSize: 9.5)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: _currentLoanStatus == 'APPROVED'
                              ? const Color(0xFF16A34A)
                              : (_currentLoanStatus == 'HANDED_OVER' ? _primaryBlue : const Color(0xFFEA580C)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _currentLoanStatus == 'APPROVED'
                              ? 'DISETUJUI'
                              : (_currentLoanStatus == 'HANDED_OVER' ? 'AKTIF DIPINJAM' : 'MENUNGGU'),
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Isi Tiket
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Banner Peringatan Sesuai Status Backend
                      if (_currentLoanStatus == 'APPROVED') ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.alarm_on_rounded, size: 18, color: Color(0xFFD97706)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Batas Waktu Pengambilan:\nAmbil alat di Gudang Sarpras sebelum pukul ${_activeLoan['noShowDeadline']} (maksimal 30 menit dari jadwal). Tiket akan hangus otomatis jika tidak diambil tepat waktu.',
                                  style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF92400E), height: 1.35, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Kotak QR Code Loket
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _borderColor),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.qr_code_2_rounded, size: 130, color: _textPrimary),
                              const SizedBox(height: 4),
                              Text(
                                _activeLoan['ticketCode'] as String,
                                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: _deepNavy),
                              ),
                              Text(
                                'Tunjukkan QR ini ke Petugas Loket Sarpras',
                                style: GoogleFonts.poppins(fontSize: 10, color: _textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_currentLoanStatus == 'HANDED_OVER') ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, size: 18, color: _primaryBlue),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Barang Fisik Telah Diserahkan',
                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: _primaryBlue),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Unit fisik ${_activeLoan['assignedUnitId']} telah diserahkan oleh ${_activeLoan['officer']}. Harap jaga kondisi barang tetap utuh.',
                                style: GoogleFonts.poppins(fontSize: 10.5, color: const Color(0xFF1E3A8A)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFED7AA)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule_rounded, size: 20, color: Color(0xFFEA580C)),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Batas Pengembalian Loket:', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF9A3412))),
                                  Text('${_activeLoan['dueDate']} (Hari Ini)', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFEA580C))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.hourglass_top_rounded, size: 18, color: Color(0xFFD97706)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Menunggu Persetujuan Sapras',
                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFB45309)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Permohonan Anda sedang dalam antrean persetujuan petugas Sarpras. Harap menunggu maksimal 2 jam sejak diajukan.',
                                style: GoogleFonts.poppins(fontSize: 10.5, color: const Color(0xFF92400E)),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 14),

                      // Rincian Data Tiket
                      _buildTicketDetailRow('No. Permohonan', _activeLoan['requestId'] as String),
                      _buildTicketDetailRow('Nama Peminjam', _currentUser.name),
                      _buildTicketDetailRow('NIS / Kelas', '${_currentUser.identifier} • $_studentClass'),
                      _buildTicketDetailRow('Alat Praktik', '${_activeLoan['itemName']} • ${_activeLoan['itemClass'] == 'PER_UNIT' ? 'Peralatan' : 'Bahan Praktik'}'),
                      _buildTicketDetailRow('Kode Unit Barang', '${_activeLoan['assignedUnitId']} (Kondisi Baik)'),
                      _buildTicketDetailRow('Loket Pengambilan', _activeLoan['pickupLocation'] as String),
                      _buildTicketDetailRow('Guru Pembimbing', _activeLoan['teacher'] as String),
                      _buildTicketDetailRow('Keperluan Praktik', _activeLoan['purpose'] as String),
                      _buildTicketDetailRow('Verifikasi Siswa', 'Wajah Terverifikasi'),

                      const SizedBox(height: 16),

                      // Tombol Aksi
                      if (_currentLoanStatus == 'APPROVED') ...[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _showCancelLoanDialog,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              side: const BorderSide(color: Color(0xFFFCA5A5)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              'Batalkan Permohonan',
                              style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ] else if (_currentLoanStatus == 'HANDED_OVER') ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _showReturnInspectionDialog,
                            icon: const Icon(Icons.assignment_turned_in_rounded, size: 16),
                            label: Text('Panduan & Checklist Pengembalian', style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _showCancelLoanDialog,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              side: const BorderSide(color: Color(0xFFFCA5A5)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              'Batalkan Permohonan Pinjam',
                              style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String statusCode, String label, Color color) {
    final isSelected = _currentLoanStatus == statusCode;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentLoanStatus = statusCode),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? color : _borderColor),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTicketDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 125, child: Text(label, style: GoogleFonts.poppins(fontSize: 11, color: _textSecondary))),
          const Text(': ', style: TextStyle(color: Color(0xFFCBD5E1))),
          Expanded(
            child: Text(value, style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: _textPrimary)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODAL BOTTOM SHEET: UBAH FOTO PROFIL
  // ═══════════════════════════════════════════════════════════════════════════
  void _showEditPhotoBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 14),
            Text('Ubah Foto Profil', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _textPrimary)),
            const SizedBox(height: 4),
            Text('Pilih foto profil yang ingin Anda gunakan untuk akun ini.', style: GoogleFonts.poppins(fontSize: 11, color: _textSecondary)),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.camera_alt_outlined, color: _primaryBlue),
              ),
              title: Text('Ambil Foto Kamera', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600)),
              subtitle: Text('Gunakan kamera ponsel untuk mengambil foto langsung', style: GoogleFonts.poppins(fontSize: 10.5, color: _textSecondary)),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _customProfilePhoto = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Foto profil berhasil diperbarui dari kamera!', style: GoogleFonts.poppins()), backgroundColor: const Color(0xFF16A34A)),
                );
              },
            ),
            const Divider(height: 1),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.photo_library_outlined, color: _primaryBlue),
              ),
              title: Text('Pilih dari Galeri', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600)),
              subtitle: Text('Unggah foto yang tersimpan di memori perangkat', style: GoogleFonts.poppins(fontSize: 10.5, color: _textSecondary)),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _customProfilePhoto = 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Foto profil berhasil dipilih dari galeri!', style: GoogleFonts.poppins()), backgroundColor: const Color(0xFF16A34A)),
                );
              },
            ),
            const Divider(height: 1),

            if (_customProfilePhoto != null) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFDC2626)),
                ),
                title: Text('Hapus Foto (Gunakan Inisial)', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFFDC2626))),
                subtitle: Text('Kembali ke tampilan inisial nama default', style: GoogleFonts.poppins(fontSize: 10.5, color: _textSecondary)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _customProfilePhoto = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Foto profil dihapus, kembali ke inisial.', style: GoogleFonts.poppins())),
                  );
                },
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 3: PROFIL SISWA & PENGATURAN AKUN (FOKUS: NAMA, KELAS, NIS/NUPTK, FOTO)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildProfileTab() {
    final idLabel = _currentUser.role == 'Siswa' ? 'Nomor Induk Siswa (NIS)' : 'NUPTK';

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Kartu Utama Profil & Foto
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar dengan tombol edit foto kamera melayang
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _customProfilePhoto == null
                            ? const LinearGradient(
                                colors: [_primaryBlue, Color(0xFF1D4ED8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        image: _customProfilePhoto != null
                            ? DecorationImage(
                                image: NetworkImage(_customProfilePhoto!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        border: Border.all(color: const Color(0xFFDBEAFE), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryBlue.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: _customProfilePhoto == null
                          ? Text(
                              _currentUser.initials,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    // Tombol Edit Kamera Melayang
                    InkWell(
                      onTap: _showEditPhotoBottomSheet,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: _primaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tombol Ubah Foto Profil
                InkWell(
                  onTap: _showEditPhotoBottomSheet,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo_camera_back_outlined, size: 13, color: _primaryBlue),
                        const SizedBox(width: 5),
                        Text(
                          'Ubah Foto Profil',
                          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: _primaryBlue),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Nama Siswa
                Text(
                  _currentUser.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: _textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_currentUser.role} Aktif • SMK Muhammadiyah Kramat',
                  style: GoogleFonts.poppins(fontSize: 11, color: _textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Kartu Rincian Data Diri (Nama, Kelas, NIS/NUPTK Saja)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Text(
                    'Data Identitas',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: _textPrimary),
                  ),
                ),
                const Divider(height: 1),

                // 1. Nama Lengkap
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.person_outline_rounded, color: _primaryBlue, size: 20),
                  ),
                  title: Text('Nama Lengkap', style: GoogleFonts.poppins(fontSize: 10.5, color: _textSecondary)),
                  subtitle: Text(_currentUser.name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: _textPrimary)),
                ),
                const Divider(height: 1, indent: 56),

                // 2. Kelas
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.school_outlined, color: _primaryBlue, size: 20),
                  ),
                  title: Text('Kelas', style: GoogleFonts.poppins(fontSize: 10.5, color: _textSecondary)),
                  subtitle: Text(_studentClass, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: _primaryBlue)),
                  trailing: InkWell(
                    onTap: _showChangeClassDialog,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit_outlined, size: 12, color: Color(0xFF475569)),
                          const SizedBox(width: 4),
                          Text('Ubah', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 56),

                // 3. NIS / NUPTK
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.badge_outlined, color: _primaryBlue, size: 20),
                  ),
                  title: Text(idLabel, style: GoogleFonts.poppins(fontSize: 10.5, color: _textSecondary)),
                  subtitle: Text(_currentUser.identifier, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: _textPrimary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Menu Cepat Riwayat & Bantuan
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history_rounded, color: _primaryBlue),
                  title: Text('Riwayat Peminjaman', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                  onTap: () => NavHelper.navigateTo(context, BorrowingHistoryPage(user: _currentUser)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline_rounded, color: _primaryBlue),
                  title: Text('Keluhan & Aspirasi Sarpras', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                  onTap: () => NavHelper.navigateTo(context, FeedbackPage(user: _currentUser)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Tombol Keluar Akun
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => LogoutHelper.confirmLogout(context),
              icon: const Icon(Icons.logout_rounded, size: 16),
              label: Text('Keluar dari Akun', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                side: const BorderSide(color: Color(0xFFFCA5A5)),
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODAL BOTTOM SHEET: PENGAJUAN PINJAM ALAT (SESUAI DTO BACKEND)
  // ═══════════════════════════════════════════════════════════════════════════
  void _showBorrowBottomSheet(Map<String, dynamic> item) {
    final isPerUnit = item['itemClass'] == 'PER_UNIT';
    String selectedPurpose = 'Praktikum Produktif Kejuruan';
    String selectedTeacher = 'Bpk. Hendra, S.Kom (Kepala Lab RPL)';
    DateTime selectedDate = DateTime.now();
    TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 30);
    TimeOfDay endTime = const TimeOfDay(hour: 15, minute: 30);
    int selectedQty = 1;

    String formatTimeStr(TimeOfDay t) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return '$h:$m WIB';
    }

    String formatDateStr(DateTime d) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
      return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 14),

              // Header Barang
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isPerUnit ? const Color(0xFFEFF6FF) : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item['icon'] as IconData, color: isPerUnit ? _primaryBlue : const Color(0xFFD97706), size: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'] as String, style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: isPerUnit ? const Color(0xFFDBEAFE) : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isPerUnit ? 'Peralatan Praktik' : 'Bahan Praktik',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: isPerUnit ? _primaryBlue : const Color(0xFFB45309),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('${item['id']} • ${item['location']}', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 18),

              // Form Field Keperluan
              DropdownButtonFormField<String>(
                initialValue: selectedPurpose,
                style: GoogleFonts.poppins(fontSize: 11.5, color: _textPrimary),
                decoration: InputDecoration(
                  labelText: 'Keperluan Praktik',
                  labelStyle: GoogleFonts.poppins(fontSize: 12),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  'Praktikum Produktif Kejuruan',
                  'Tugas Akhir / UKK (Uji Kompetensi)',
                  'Ekskul Robotik & Multimedia',
                  'Persiapan Lomba Kompetensi Siswa (LKS)',
                ].map((p) => DropdownMenuItem(value: p, child: Text(p, style: GoogleFonts.poppins(fontSize: 11.5, color: _textPrimary)))).toList(),
                onChanged: (val) => setModal(() => selectedPurpose = val!),
              ),
              const SizedBox(height: 10),

              // Form Field Guru Pembimbing
              DropdownButtonFormField<String>(
                initialValue: selectedTeacher,
                style: GoogleFonts.poppins(fontSize: 11.5, color: _textPrimary),
                decoration: InputDecoration(
                  labelText: 'Guru Pembimbing Praktikum',
                  labelStyle: GoogleFonts.poppins(fontSize: 12),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  'Bpk. Hendra, S.Kom (Kepala Lab RPL)',
                  'Bpk. Budi Santoso, S.T. (Produktif TKRO)',
                  'Ibu Siti Aminah, M.Pd (Multimedia & DKV)',
                  'Bpk. Eko Prasetyo, S.Pd (Pengelasan)',
                ].map((t) => DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.poppins(fontSize: 11.5, color: _textPrimary)))).toList(),
                onChanged: (val) => setModal(() => selectedTeacher = val!),
              ),
              const SizedBox(height: 10),

              // Jadwal Rentang Waktu Bebas (startAt & endAt di backend)
              Text('Jadwal Praktik (Bebas Atur Waktu)', style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold, color: _textPrimary)),
              const SizedBox(height: 6),

              // Baris Tanggal Praktik
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                  );
                  if (picked != null) {
                    setModal(() => selectedDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, size: 18, color: _primaryBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tanggal Praktik', style: GoogleFonts.poppins(fontSize: 9.5, color: _textSecondary)),
                            Text(
                              formatDateStr(selectedDate),
                              style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: _textPrimary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Ganti Tgl', style: GoogleFonts.poppins(fontSize: 9.5, color: _primaryBlue, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Baris Jam Mulai (startAt) & Jam Selesai (endAt)
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: ctx,
                          initialTime: startTime,
                        );
                        if (picked != null) {
                          setModal(() => startTime = picked);
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.play_circle_outline_rounded, size: 14, color: _primaryBlue),
                                const SizedBox(width: 4),
                                Text('Jam Mulai', style: GoogleFonts.poppins(fontSize: 9.5, color: _textSecondary)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(formatTimeStr(startTime), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: _textPrimary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: ctx,
                          initialTime: endTime,
                        );
                        if (picked != null) {
                          setModal(() => endTime = picked);
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.stop_circle_outlined, size: 14, color: Color(0xFFDC2626)),
                                const SizedBox(width: 4),
                                Text('Jam Selesai', style: GoogleFonts.poppins(fontSize: 9.5, color: _textSecondary)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(formatTimeStr(endTime), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: _textPrimary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Preset Cepat Opsional
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text('Preset: ', style: GoogleFonts.poppins(fontSize: 9.5, color: _textSecondary)),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => setModal(() {
                        startTime = const TimeOfDay(hour: 8, minute: 30);
                        endTime = const TimeOfDay(hour: 10, minute: 0);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Text('1.5 Jam', style: GoogleFonts.poppins(fontSize: 9.5, color: _textPrimary)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => setModal(() {
                        startTime = const TimeOfDay(hour: 8, minute: 30);
                        endTime = const TimeOfDay(hour: 12, minute: 0);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Text('Sesi Pagi', style: GoogleFonts.poppins(fontSize: 9.5, color: _textPrimary)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => setModal(() {
                        startTime = const TimeOfDay(hour: 8, minute: 30);
                        endTime = const TimeOfDay(hour: 15, minute: 30);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Text('Seharian (15:30)', style: GoogleFonts.poppins(fontSize: 9.5, color: _textPrimary)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Jika CONSUMABLE, bisa pilih jumlah (qty)
              if (!isPerUnit) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jumlah Bahan (Qty):', style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold)),
                        Text('Bahan habis pakai dipotong dari stok loket', style: GoogleFonts.poppins(fontSize: 9.5, color: _textSecondary)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 20, color: _primaryBlue),
                          onPressed: selectedQty > 1 ? () => setModal(() => selectedQty--) : null,
                        ),
                        Text('$selectedQty Pcs', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 20, color: _primaryBlue),
                          onPressed: selectedQty < (item['stock'] as int) ? () => setModal(() => selectedQty++) : null,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],

              // Notice Biometrik Wajah Backend
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 16, color: Color(0xFF16A34A)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Verifikasi wajah otomatis disertakan untuk mempercepat proses persetujuan oleh petugas Sarpras.',
                        style: GoogleFonts.poppins(fontSize: 9.5, color: const Color(0xFF475569)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _hasActiveLoan = true;
                      _currentLoanStatus = 'WAITING_APPROVAL'; // Permohonan baru berstatus WAITING_APPROVAL
                      _activeLoan = {
                        'requestId': 'REQ-2026-${1000 + (item['stock'] as int) * 123}',
                        'ticketCode': 'TKT-2026-${1000 + (item['stock'] as int) * 123}',
                        'itemName': item['name'],
                        'itemClass': item['itemClass'],
                        'assignedUnitId': isPerUnit ? '${item['id']}-U1' : 'STOK-${item['id']}',
                        'unitCondition': 'LAYAK_PAKAI',
                        'category': item['category'],
                        'borrowDate': '${formatDateStr(selectedDate)}, ${formatTimeStr(startTime)}',
                        'dueDate': formatTimeStr(endTime),
                        'noShowDeadline': formatTimeStr(TimeOfDay(
                          hour: (startTime.hour + (startTime.minute + 30) ~/ 60) % 24,
                          minute: (startTime.minute + 30) % 60,
                        )),
                        'approvalDeadline': '2 Jam ke depan',
                        'teacher': selectedTeacher,
                        'purpose': selectedPurpose,
                        'pickupLocation': item['location'],
                        'officer': 'Petugas Loket Gudang B',
                        'quantity': selectedQty,
                      };
                      _currentTabIndex = 2; // Pindah otomatis ke Tiket QR
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Permohonan berhasil diajukan! Menunggu persetujuan Sarpras.', style: GoogleFonts.poppins()),
                        backgroundColor: const Color(0xFF16A34A),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Konfirmasi & Ajukan Pinjam',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOG PEMBATALAN PEMINJAMAN (POST /borrow-requests/:id/cancel)
  // ═══════════════════════════════════════════════════════════════════════════
  void _showCancelLoanDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Batalkan Peminjaman?', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
        content: Text(
          'Apakah Anda yakin ingin membatalkan permohonan peminjaman ini? Barang akan kembali tersedia untuk siswa lain.',
          style: GoogleFonts.poppins(fontSize: 11.5, color: const Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Tutup', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _hasActiveLoan = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Permohonan peminjaman berhasil dibatalkan.', style: GoogleFonts.poppins()),
                  backgroundColor: const Color(0xFFDC2626),
                ),
              );
            },
            child: Text('Ya, Batalkan Pinjam', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOG UBAH KELAS SISWA
  // ═══════════════════════════════════════════════════════════════════════════
  void _showChangeClassDialog() {
    String tempClass = _studentClass;
    final availableClasses = ['XII RPL 1', 'XII RPL 2', 'XII TKRO 1', 'XII TKRO 2', 'XII DKV 1', 'XII TPM 1'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Ubah Kelas Siswa', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih kelas aktif Anda saat ini agar data peminjaman inventaris terdata sesuai rombongan belajar.',
                style: GoogleFonts.poppins(fontSize: 11, color: _textSecondary),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: tempClass,
                decoration: const InputDecoration(
                  labelText: 'Pilih Kelas',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: availableClasses
                    .map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins(fontSize: 12))))
                    .toList(),
                onChanged: (val) => setDialog(() => tempClass = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Batal', style: GoogleFonts.poppins(fontSize: 12)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _studentClass = tempClass);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Kelas berhasil diperbarui menjadi $_studentClass!', style: GoogleFonts.poppins()),
                    backgroundColor: const Color(0xFF16A34A),
                  ),
                );
              },
              child: Text('Simpan Perubahan', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODAL BOTTOM SHEET: FORM PEMERIKSAAN PENGEMBALIAN ALAT
  // ═══════════════════════════════════════════════════════════════════════════
  void _showReturnInspectionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 14),
              Text('Form Pengembalian Alat', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Periksa kondisi fisik barang bersama petugas loket Sarpras Gedung B.', style: GoogleFonts.poppins(fontSize: 11, color: _textSecondary)),
              const SizedBox(height: 12),

              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: _condFisikUtuh,
                activeColor: _primaryBlue,
                title: Text('Fisik Utuh & Bersih (Tanpa Retak)', style: GoogleFonts.poppins(fontSize: 11.5)),
                onChanged: (val) => setModal(() => _condFisikUtuh = val ?? true),
              ),
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: _condAksesorisLengkap,
                activeColor: _primaryBlue,
                title: Text('Aksesoris & Kabel Lengkap', style: GoogleFonts.poppins(fontSize: 11.5)),
                onChanged: (val) => setModal(() => _condAksesorisLengkap = val ?? true),
              ),
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: _condFungsiNormal,
                activeColor: _primaryBlue,
                title: Text('Fungsi Elektronik / Mesin Normal', style: GoogleFonts.poppins(fontSize: 11.5)),
                onChanged: (val) => setModal(() => _condFungsiNormal = val ?? true),
              ),
              const SizedBox(height: 10),

              Text('Rating Kondisi Alat:', style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _returnRating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 28,
                    ),
                    onPressed: () => setModal(() => _returnRating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _hasActiveLoan = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Alat berhasil dikembalikan ke Loket Sarpras!', style: GoogleFonts.poppins()),
                        backgroundColor: const Color(0xFF16A34A),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: Text('Konfirmasi Selesai Dikembalikan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOG SCAN BARCODE
  // ═══════════════════════════════════════════════════════════════════════════
  void _showScanBarcodeQuickDialog() {
    final barcodeCtrl = TextEditingController(text: 'CAM-RPL-004');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Scan QR / Barcode Alat', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Icon(Icons.qr_code_scanner_rounded, size: 70, color: Colors.white70)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: barcodeCtrl,
              style: GoogleFonts.poppins(fontSize: 12),
              decoration: InputDecoration(
                labelText: 'Kode Seri Alat',
                labelStyle: GoogleFonts.poppins(fontSize: 12),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Tutup', style: GoogleFonts.poppins())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue),
            onPressed: () {
              Navigator.pop(ctx);
              final code = barcodeCtrl.text.trim();
              final match = _catalogItems.firstWhere(
                (i) => (i['id'] as String).toLowerCase() == code.toLowerCase(),
                orElse: () => _catalogItems.first,
              );
              _showBorrowBottomSheet(match);
            },
            child: Text('Identifikasi', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MODAL BOTTOM SHEET: NOTIFIKASI MOBILE (FLOW SINKRON DENGAN SARPRAS)
  // ═══════════════════════════════════════════════════════════════════════════
  void _showNotificationBottomSheet() {
    int activeFilter = 0; // 0: Semua, 1: Belum Dibaca, 2: Peminjaman

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) {
          final filteredList = _notificationsList.where((n) {
            if (activeFilter == 1) return n['isUnread'] as bool;
            if (activeFilter == 2) return n['category'] == 'peminjaman';
            return true;
          }).toList();

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.82,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Header Notifikasi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications_active_rounded, color: _primaryBlue, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Notifikasi',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_unreadNotifCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$_unreadNotifCount Baru',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (_unreadNotifCount > 0)
                        TextButton(
                          onPressed: () {
                            setModal(() {
                              for (var item in _notificationsList) {
                                item['isUnread'] = false;
                              }
                            });
                            setState(() {
                              _unreadNotifCount = 0;
                            });
                          },
                          child: Text(
                            'Tandai Dibaca',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: _primaryBlue,
                            ),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF64748B)),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Filter Tabs (Semua, Belum Dibaca, Peminjaman)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildNotifFilterChip('Semua (${_notificationsList.length})', 0, activeFilter, (idx) => setModal(() => activeFilter = idx)),
                      const SizedBox(width: 6),
                      _buildNotifFilterChip('Belum Dibaca ($_unreadNotifCount)', 1, activeFilter, (idx) => setModal(() => activeFilter = idx)),
                      const SizedBox(width: 6),
                      _buildNotifFilterChip('Peminjaman', 2, activeFilter, (idx) => setModal(() => activeFilter = idx)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: _borderColor),

                // Daftar Notifikasi
                Flexible(
                  child: filteredList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.notifications_off_outlined, size: 48, color: Color(0xFFCBD5E1)),
                              const SizedBox(height: 8),
                              Text(
                                'Tidak ada notifikasi',
                                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: filteredList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (ctx, i) {
                            final notif = filteredList[i];
                            final isUnread = notif['isUnread'] as bool;
                            final action = notif['action'] as String?;

                            return InkWell(
                              onTap: () {
                                if (isUnread) {
                                  setModal(() => notif['isUnread'] = false);
                                  setState(() {
                                    _unreadNotifCount = _notificationsList.where((n) => n['isUnread'] as bool).length;
                                  });
                                }
                                if (action == 'ticket') {
                                  Navigator.pop(ctx);
                                  setState(() => _currentTabIndex = 2);
                                } else if (action == 'return') {
                                  Navigator.pop(ctx);
                                  _showReturnInspectionDialog();
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isUnread ? const Color(0xFFF8FAFC) : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isUnread ? const Color(0xFFBFDBFE) : _borderColor,
                                    width: isUnread ? 1.2 : 1.0,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: (notif['color'] as Color).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(notif['icon'] as IconData, color: notif['color'] as Color, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notif['title'] as String,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12.5,
                                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                                    color: _textPrimary,
                                                  ),
                                                ),
                                              ),
                                              if (isUnread)
                                                Container(
                                                  width: 7,
                                                  height: 7,
                                                  margin: const EdgeInsets.only(left: 6),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFFDC2626),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notif['desc'] as String,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: const Color(0xFF64748B),
                                              height: 1.35,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                notif['time'] as String,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  color: const Color(0xFF94A3B8),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              if (action == 'ticket')
                                                Text(
                                                  'Buka Tiket QR →',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.bold,
                                                    color: _primaryBlue,
                                                  ),
                                                )
                                              else if (action == 'return')
                                                Text(
                                                  'Kembalikan →',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(0xFFEA580C),
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
                        ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        NavHelper.navigateTo(context, NotificationPage(user: _currentUser));
                      },
                      child: Text(
                        'Buka Halaman Lengkap Notifikasi',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: _primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotifFilterChip(String label, int index, int activeIndex, ValueChanged<int> onSelect) {
    final isSelected = index == activeIndex;
    return InkWell(
      onTap: () => onSelect(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? _primaryBlue : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
