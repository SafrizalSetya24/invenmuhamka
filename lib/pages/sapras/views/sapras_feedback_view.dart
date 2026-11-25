import 'package:flutter/material.dart';

class SaprasFeedbackView extends StatefulWidget {
  final bool isDesktop;
  final double screenWidth;

  const SaprasFeedbackView({
    super.key,
    required this.isDesktop,
    required this.screenWidth,
  });

  @override
  State<SaprasFeedbackView> createState() => _SaprasFeedbackViewState();
}

class _SaprasFeedbackViewState extends State<SaprasFeedbackView> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedStatusFilter = 0; // 0: Semua, 1: Baru Masuk, 2: Diproses, 3: Selesai
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _feedbacks = [
    {
      'id': 'KLH-001',
      'user': 'Safrizal Setya Wira',
      'role': 'Siswa (XII RPL 1)',
      'date': '24 Nov 2026 • 09.15 WIB',
      'location': 'Lab RPL 1 - Meja Baris 3',
      'title': 'Stopkontak di meja baris 3 kendor & sering timbul percikan',
      'desc':
          'Kabel adaptor laptop sering kendor saat tersenggol saat praktikum web. Mohon modul stopkontak tanamnya diperiksa atau diganti.',
      'status': 'Baru Masuk', // Baru Masuk, Sedang Diproses, Selesai
      'response': null,
    },
    {
      'id': 'KLH-002',
      'user': 'Ahmad Fauzi, S.Kom.',
      'role': 'Guru Produktif TKJ',
      'date': '23 Nov 2026 • 13.40 WIB',
      'location': 'Bengkel TKJ Gedung B',
      'title': 'Kebutuhan crimping tool tambahan untuk persiapan Ujikom',
      'desc':
          'Terdapat 3 crimping tool yang mata potongnya sudah tumpul dan konektor RJ45 tinggal sedikit. Mohon dicek untuk kelancaran asesmen.',
      'status': 'Sedang Diproses',
      'response': 'Sudah dimasukkan ke jadwal pengadaan BHP minggu ini oleh Staf Sarpras.',
    },
    {
      'id': 'KLH-003',
      'user': 'Dedi Prasetyo',
      'role': 'Siswa (XII TBSM 2)',
      'date': '22 Nov 2026 • 10.20 WIB',
      'location': 'Bengkel Otomotif',
      'title': 'Kran kompresor angin bocor di sambungan nomor 2',
      'desc':
          'Tekanan angin turun saat menggunakan impact wrench untuk bongkar ban roda sepeda motor praktik.',
      'status': 'Selesai',
      'response': 'Seal selang spiral dan kran kuningan sudah diganti oleh teknisi sarpras pada 22 Nov 2026.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredFeedbacks {
    final query = _searchController.text.toLowerCase().trim();
    return _feedbacks.where((item) {
      final user = (item['user'] as String).toLowerCase();
      final title = (item['title'] as String).toLowerCase();
      final loc = (item['location'] as String).toLowerCase();
      final status = item['status'] as String;

      final matchQuery = query.isEmpty ||
          user.contains(query) ||
          title.contains(query) ||
          loc.contains(query);

      bool matchStatus = true;
      if (_selectedStatusFilter == 1) matchStatus = status == 'Baru Masuk';
      if (_selectedStatusFilter == 2) matchStatus = status == 'Sedang Diproses';
      if (_selectedStatusFilter == 3) matchStatus = status == 'Selesai';

      return matchQuery && matchStatus;
    }).toList();
  }

  void _showRespondDialog(Map<String, dynamic> item) {
    final respCtrl = TextEditingController(text: item['response'] ?? '');
    String targetStatus = item['status'] == 'Baru Masuk' ? 'Sedang Diproses' : item['status'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.reply_outlined, color: _primaryBlue),
              SizedBox(width: 8),
              Text(
                'Tanggapi Keluhan / Laporan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textPrimary),
              ),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Laporan dari: ${item['user']} (${item['role']})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  item['title'] as String,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 14),
                const Text('Ubah Status Menjadi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: targetStatus,
                  items: const [
                    DropdownMenuItem(value: 'Baru Masuk', child: Text('Baru Masuk')),
                    DropdownMenuItem(value: 'Sedang Diproses', child: Text('Sedang Diproses')),
                    DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                  ],
                  onChanged: (val) {
                    if (val != null) setModalState(() => targetStatus = val);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Catatan / Tindak Lanjut Petugas', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                const SizedBox(height: 6),
                TextField(
                  controller: respCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tuliskan tindakan atau jawaban untuk pelapor...',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: _textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                setState(() {
                  item['response'] = respCtrl.text.trim().isEmpty ? null : respCtrl.text.trim();
                  item['status'] = targetStatus;
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tanggapan berhasil disimpan!'),
                    backgroundColor: Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Simpan Tanggapan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredFeedbacks;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isDesktop ? 36 : (widget.screenWidth < 500 ? 14 : 20),
        vertical: widget.screenWidth < 500 ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Sederhana
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Keluhan & Saran Fasilitas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Aspirasi dan laporan kendala sarana prasarana sekolah dari guru & siswa',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Pencarian & Filter Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari pelapor, lokasi, atau isi keluhan...',
                    prefixIcon: const Icon(Icons.search, size: 20, color: _textSecondary),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _borderColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFilterChip(0, 'Semua (${_feedbacks.length})'),
                    _buildFilterChip(1, 'Baru Masuk (${_feedbacks.where((e) => e['status'] == 'Baru Masuk').length})'),
                    _buildFilterChip(2, 'Sedang Diproses (${_feedbacks.where((e) => e['status'] == 'Sedang Diproses').length})'),
                    _buildFilterChip(3, 'Selesai (${_feedbacks.where((e) => e['status'] == 'Selesai').length})'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Daftar Kartu Keluhan Bersih & Manusiawi
          if (filtered.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
              ),
              child: const Center(
                child: Text(
                  'Tidak ada laporan keluhan yang sesuai filter.',
                  style: TextStyle(color: _textSecondary, fontSize: 14),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = filtered[index];
                final status = item['status'] as String;

                Color statusBg = const Color(0xFFEFF6FF);
                Color statusFg = _primaryBlue;

                if (status == 'Sedang Diproses') {
                  statusBg = const Color(0xFFFEF3C7);
                  statusFg = const Color(0xFFD97706);
                } else if (status == 'Selesai') {
                  statusBg = const Color(0xFFDCFCE7);
                  statusFg = const Color(0xFF16A34A);
                }

                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Kartu: Pelapor & Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue.shade50,
                            child: const Icon(Icons.person_outline, color: _primaryBlue, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['user'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: _textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item['role']} • ${item['date']}',
                                  style: const TextStyle(fontSize: 12, color: _textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusFg,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Lokasi & Judul Laporan
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.place_outlined, size: 14, color: _textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              item['location'] as String,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['desc'] as String,
                        style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey.shade800),
                      ),
                      const SizedBox(height: 14),

                      // Box Tanggapan Staf jika ada
                      if (item['response'] != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle_outline, size: 14, color: _primaryBlue),
                                  SizedBox(width: 6),
                                  Text(
                                    'Tindak Lanjut Petugas Sarpras:',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _primaryBlue),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['response'] as String,
                                style: const TextStyle(fontSize: 12, color: _textPrimary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Tombol Aksi Responsif
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showRespondDialog(item),
                              icon: const Icon(Icons.reply, size: 16),
                              label: Text(item['response'] == null ? 'Tanggapi' : 'Edit Tanggapan'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _primaryBlue,
                                side: const BorderSide(color: _primaryBlue),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            if (status != 'Selesai')
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    item['status'] = 'Selesai';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Laporan ditandai selesai!'),
                                      backgroundColor: Color(0xFF16A34A),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Tandai Selesai'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF16A34A),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedStatusFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedStatusFilter = index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryBlue : _borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : _textSecondary,
          ),
        ),
      ),
    );
  }
}
