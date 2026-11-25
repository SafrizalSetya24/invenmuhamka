import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../utils/logout_helper.dart';
import '../../utils/nav_helper.dart';
import '../../widgets/top_bar_actions.dart';
import '../cart/cart_page.dart';
import '../catalog/item_category_page.dart';
import '../history/borrowing_history_page.dart';
import '../home/home_page.dart';
import '../notification/notification_page.dart';
import '../profile/profile_page.dart';

class FeedbackItemModel {
  final String id;
  final String date;
  final String type; // 'Kritik', 'Saran', 'Apresiasi'
  final int rating; // 1 to 5
  final String category;
  final String title;
  final String content;
  final String urgency;
  final String status; // 'DITERIMA', 'DITINDAKLANJUTI', 'SELESAI'
  final String? response;

  FeedbackItemModel({
    required this.id,
    required this.date,
    this.type = 'Saran',
    this.rating = 4,
    required this.category,
    required this.title,
    required this.content,
    required this.urgency,
    required this.status,
    this.response,
  });
}

class FeedbackPage extends StatefulWidget {
  final UserModel? user;

  const FeedbackPage({super.key, this.user});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _lightBg = Color(0xFFF3F6FC);

  UserModel get _currentUser => widget.user ?? DummyData.users.first;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String _selectedType = 'Saran'; // 'Kritik', 'Saran', 'Apresiasi'
  int _selectedRating = 4; // 1 to 5
  String _selectedCategory = 'Ketersediaan Alat & Komponen Praktik';
  String _selectedUrgency = 'Sedang (Perbaikan Alat Belajar)';
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Ketersediaan Alat & Komponen Praktik',
    'Fasilitas Lab Komputer / RPL',
    'Kondisi & Kelaikan Barang (Rusak / Servis)',
    'Prosedur Peminjaman & Pengembalian',
    'Pelayanan Petugas Sarpras',
    'Lainnya',
  ];

  final List<String> _urgencies = [
    'Rendah (Saran Fasilitas Jangka Panjang)',
    'Sedang (Perbaikan Alat Belajar)',
    'Mendesak (Kendala KBM Berlangsung)',
  ];

  late List<FeedbackItemModel> _myFeedbacks;

  @override
  void initState() {
    super.initState();
    _myFeedbacks = [
      FeedbackItemModel(
        id: 'FB-20261110-01',
        date: '10 Nov 2026',
        type: 'Saran',
        rating: 4,
        category: 'Ketersediaan Alat & Komponen Praktik',
        title: 'Penambahan stok Crimping Tool & Lan Tester di Lab RPL',
        content:
            'Saat praktikum pengkabelan minggu lalu, jumlah tang crimping hanya ada 3 unit yang presisi untuk 36 siswa. Mohon pertimbangan penambahan unit agar tidak antre terlalu lama.',
        urgency: 'Sedang (Perbaikan Alat Belajar)',
        status: 'DITINDAKLANJUTI',
        response:
            'Terima kasih masukannya. Bagian Sarpras sudah mengajukan pengadaan 5 set crimping tool baru ke bagian keuangan sekolah.',
      ),
      FeedbackItemModel(
        id: 'FB-20261025-04',
        date: '25 Okt 2026',
        type: 'Kritik',
        rating: 2,
        category: 'Kondisi & Kelaikan Barang (Rusak / Servis)',
        title: 'Baterai kamera Canon EOS 200D cepat drop',
        content:
            'Salah satu unit kamera DSLR baterainya hanya bertahan kurang dari 30 menit saat dipakai praktik outdoor multimedia.',
        urgency: 'Sedang (Perbaikan Alat Belajar)',
        status: 'SELESAI',
        response:
            'Unit baterai LP-E17 yang drop telah diganti dengan baterai cadangan baru oleh teknisi Sarpras.',
      ),
      FeedbackItemModel(
        id: 'FB-20261012-02',
        date: '12 Okt 2026',
        type: 'Apresiasi',
        rating: 5,
        category: 'Pelayanan Petugas Sarpras',
        title: 'Pelayanan peminjaman proyektor LCD sangat cepat dan ramah',
        content:
            'Petugas sarpras sangat responsif menyiapkan kabel HDMI dan tripod saat kelas kami presentasi tugas akhir.',
        urgency: 'Rendah (Saran Fasilitas Jangka Panjang)',
        status: 'SELESAI',
        response:
            'Terima kasih atas apresiasinya! Tim Sarpras selalu berusaha memberikan pelayanan terbaik untuk kelancaran pembelajaran.',
      ),
    ];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap masukkan judul atau perihal masukan'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    if (content.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi kritik atau saran minimal 10 karakter'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      final newFeedback = FeedbackItemModel(
        id:
            'FB-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-${_myFeedbacks.length + 1}',
        date: 'Hari ini',
        type: _selectedType,
        rating: _selectedRating,
        category: _selectedCategory,
        title: title,
        content: content,
        urgency: _selectedUrgency,
        status: 'DITERIMA',
        response: null,
      );

      setState(() {
        _myFeedbacks.insert(0, newFeedback);
        _isSubmitting = false;
        _titleController.clear();
        _contentController.clear();
      });

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)),
              const SizedBox(width: 10),
              Text(
                '$_selectedType Terkirim',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          content: Text(
            _selectedType == 'Apresiasi'
                ? 'Terima kasih banyak atas apresiasi Anda! Semangat dan kepuasan siswa menjadi motivasi utama tim Sarpras dan sekolah.'
                : 'Terima kasih atas masukan Anda. Tim Sarpras dan pihak sekolah akan meninjau dan menindaklanjuti demi peningkatan kualitas fasilitas pembelajaran.',
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('OK, Mengerti'),
            ),
          ],
        ),
      );
    });
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
          // Sidebar Menu (Desktop)
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
                      vertical: 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 880),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleRow(),
                            const SizedBox(height: 20),
                            _buildBannerInfo(),
                            const SizedBox(height: 24),
                            _buildFeedbackFormCard(screenWidth),
                            const SizedBox(height: 32),
                            _buildFeedbackHistorySection(),
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
            'Kritik & Saran',
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
          'Layanan Aspirasi & Pengaduan Sarpras',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Saluran resmi penyampaian kendala fasilitas, kelaikan alat praktik, dan usulan sarana pembelajaran SMK Muhammadiyah Kramat.',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // ─── 3. BANNER INFO ────────────────────────────────────────────────────────
  Widget _buildBannerInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF475569), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Laporan kerusakan alat atau kebutuhan bahan praktik akan ditindaklanjuti oleh teknisi Sarpras dan Kepala Program Keahlian. Tersedia opsi pengirim anonim untuk menjaga privasi.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF334155),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return '1/5 • Sangat Kurang';
      case 2:
        return '2/5 • Kurang Puas';
      case 3:
        return '3/5 • Cukup Baik';
      case 4:
        return '4/5 • Puas & Bagus';
      case 5:
        return '5/5 • Sangat Memuaskan!';
      default:
        return '$rating/5';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return const Color(0xFFDC2626);
      case 2:
        return const Color(0xFFEA580C);
      case 3:
        return const Color(0xFFD97706);
      case 4:
        return const Color(0xFF0284C7);
      case 5:
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFF0038A8);
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Kritik':
        return const Color(0xFFEA580C);
      case 'Apresiasi':
        return const Color(0xFF16A34A);
      case 'Saran':
      default:
        return _primaryBlue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Kritik':
        return Icons.report_problem_rounded;
      case 'Apresiasi':
        return Icons.thumb_up_alt_rounded;
      case 'Saran':
      default:
        return Icons.lightbulb_rounded;
    }
  }

  String get _titleHint {
    switch (_selectedType) {
      case 'Kritik':
        return 'Contoh: Stopkontak Lab RPL 1 banyak yang kendor / mati';
      case 'Apresiasi':
        return 'Contoh: Pelayanan petugas Sarpras sangat cepat tanggap saat peminjaman LCD';
      case 'Saran':
      default:
        return 'Contoh: Penambahan kabel LAN & crimping tool di Lab RPL';
    }
  }

  String get _contentHint {
    switch (_selectedType) {
      case 'Kritik':
        return 'Jelaskan kendala fasilitas atau alat rusak yang Anda temukan beserta lokasi/lab...';
      case 'Apresiasi':
        return 'Sampaikan hal positif atau pelayanan petugas Sarpras yang menurut Anda sangat memuaskan...';
      case 'Saran':
      default:
        return 'Tuliskan usulan fasilitas atau alat yang Anda butuhkan untuk kelancaran praktik...';
    }
  }

  Widget _buildTypeSelector(
    String type,
    IconData icon,
    Color activeColor,
    String subtitle,
  ) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.08)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? activeColor
                  : Colors.grey.withValues(alpha: 0.2),
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 17,
                    color: isSelected ? activeColor : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? activeColor : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.85)
                      : Colors.grey[500],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 4. FORM CARD ──────────────────────────────────────────────────────────
  Widget _buildFeedbackFormCard(double screenWidth) {
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Identitas Pengirim Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.18)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: _isAnonymous ? Colors.grey : _primaryBlue,
                  child: Icon(
                    _isAnonymous ? Icons.visibility_off_rounded : Icons.person,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _isAnonymous
                        ? 'Pengirim: Anonim (Nama Dirahasiakan)'
                        : 'Pengirim: ${_currentUser.name} (${_currentUser.role} • ${_currentUser.identifier})',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: _isAnonymous
                          ? Colors.grey[700]
                          : const Color(0xFF1E293B),
                    ),
                  ),
                ),
                Switch(
                  value: _isAnonymous,
                  activeThumbColor: _primaryBlue,
                  onChanged: (val) => setState(() => _isAnonymous = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pilihan Jenis Masukan (Kritik, Saran, Apresiasi)
          const Text(
            'Jenis Masukan:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildTypeSelector(
                'Kritik',
                Icons.report_problem_outlined,
                const Color(0xFFEA580C),
                'Kendala / Rusak',
              ),
              const SizedBox(width: 8),
              _buildTypeSelector(
                'Saran',
                Icons.lightbulb_outline_rounded,
                _primaryBlue,
                'Usulan / Ide Baru',
              ),
              const SizedBox(width: 8),
              _buildTypeSelector(
                'Apresiasi',
                Icons.thumb_up_alt_outlined,
                const Color(0xFF16A34A),
                'Pujian / Layanan',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Rating Bintang Kepuasan Layanan Sarpras
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tingkat Kepuasan Layanan Sarpras:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _getRatingColor(_selectedRating)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getRatingLabel(_selectedRating),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: _getRatingColor(_selectedRating),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    final star = index + 1;
                    final isSelected = star <= _selectedRating;
                    return InkWell(
                      onTap: () => setState(() => _selectedRating = star),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Icon(
                          isSelected
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 30,
                          color: isSelected
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Kategori Masukan
          const Text(
            'Kategori Masukan / Fasilitas:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.25),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
            style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
            items: _categories.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text(c, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
          ),
          const SizedBox(height: 18),

          // Judul / Perihal
          const Text(
            'Judul / Perihal Singkat:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: const TextStyle(fontSize: 13.5),
            decoration: InputDecoration(
              hintText: _titleHint,
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.25),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
          ),
          const SizedBox(height: 18),

          // Isi Masukan
          Text(
            'Uraian $_selectedType:',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contentController,
            maxLines: 4,
            style: const TextStyle(fontSize: 13.5),
            decoration: InputDecoration(
              hintText: _contentHint,
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.25),
                ),
              ),
              contentPadding: const EdgeInsets.all(14),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
          ),
          const SizedBox(height: 18),

          // Tingkat Urgensi
          const Text(
            'Tingkat Urgensi:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedUrgency,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.25),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
            style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
            items: _urgencies.map((u) {
              return DropdownMenuItem(
                value: u,
                child: Text(u, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedUrgency = val);
            },
          ),
          const SizedBox(height: 24),

          // Tombol Kirim
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitFeedback,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(
                _isSubmitting
                    ? 'Mengirimkan Masukan...'
                    : 'Kirim $_selectedType Sekarang',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getTypeColor(_selectedType),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 5. RIWAYAT KRITIK & SARAN ─────────────────────────────────────────────
  Widget _buildFeedbackHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Masukan & Tindak Lanjut Sekolah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pantau status respon dari bagian Sarpras dan pihak sekolah atas masukan Anda.',
          style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _myFeedbacks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final fb = _myFeedbacks[index];

            Color statusColor;
            Color statusBg;
            String statusLabel;

            if (fb.status == 'SELESAI') {
              statusColor = const Color(0xFF15803D);
              statusBg = const Color(0xFFDCFCE7);
              statusLabel = 'Selesai / Diakomodasi';
            } else if (fb.status == 'DITINDAKLANJUTI') {
              statusColor = const Color(0xFF0369A1);
              statusBg = const Color(0xFFE0F2FE);
              statusLabel = 'Sedang Ditindaklanjuti';
            } else {
              statusColor = const Color(0xFFB45309);
              statusBg = const Color(0xFFFEF3C7);
              statusLabel = 'Diterima Tim Sarpras';
            }

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${fb.id} • ${fb.date}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Type Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor(fb.type)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getTypeIcon(fb.type),
                                  size: 13,
                                  color: _getTypeColor(fb.type),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  fb.type,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _getTypeColor(fb.type),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Star Rating
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (starIdx) {
                              return Icon(
                                starIdx < fb.rating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 14,
                                color: starIdx < fb.rating
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFFCBD5E1),
                              );
                            }),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    fb.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kategori: ${fb.category} • Urgensi: ${fb.urgency}',
                    style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fb.content,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),

                  // Respon dari Sarpras (Jika ada)
                  if (fb.response != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF86EFAC).withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.reply_rounded,
                            size: 16,
                            color: Color(0xFF15803D),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tanggapan Resmi Petugas Sarpras:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF15803D),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  fb.response!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF166534),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── 6. SIDEBAR MENU ───────────────────────────────────────────────────────
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
          // Logo
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
            () {},
            isSelected: true,
            hasIndicator: true,
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
