import 'package:flutter/material.dart';

class SaprasRepairView extends StatefulWidget {
  final bool isDesktop;
  final double screenWidth;

  const SaprasRepairView({
    super.key,
    required this.isDesktop,
    required this.screenWidth,
  });

  @override
  State<SaprasRepairView> createState() => _SaprasRepairViewState();
}

class _SaprasRepairViewState extends State<SaprasRepairView> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedStatusFilter = 0; // 0: Semua, 1: Menunggu Servis, 2: Sedang Dikerjakan, 3: Selesai
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _repairItems = [
    {
      'id': 'REP-001',
      'code': 'OTO-WLD-002',
      'name': 'Mesin Las Inverter Lakoni 160A',
      'jurusan': 'TBSM',
      'damage': 'Api las tidak stabil, kipas pendingin mati mendadak saat arus 120A.',
      'reportedBy': 'Pak Joko (Guru TBSM)',
      'technician': 'Bambang Irawan',
      'date': '24 Nov 2026',
      'status': 'Menunggu Servis', // Menunggu Servis, Sedang Dikerjakan, Selesai
    },
    {
      'id': 'REP-002',
      'code': 'NET-TKJ-015',
      'name': 'Router MikroTik CCR1009',
      'jurusan': 'TKJ',
      'damage': 'Port SFP nomor 2 tidak terdeteksi link, kabel DAC tidak terbaca.',
      'reportedBy': 'Fajar (Teknisi Lab TKJ)',
      'technician': 'Bambang Irawan',
      'date': '23 Nov 2026',
      'status': 'Menunggu Servis',
    },
    {
      'id': 'REP-003',
      'code': 'TRN-TBSM-008',
      'name': 'Trainer Kelistrikan Body Honda Beat',
      'jurusan': 'TBSM',
      'damage': 'Pemasangan relay lampu sein & rewiring kabel body harness utama terbakar.',
      'reportedBy': 'Pak Joko (Guru TBSM)',
      'technician': 'Tim Teknisi Otomotif',
      'date': '22 Nov 2026',
      'status': 'Sedang Dikerjakan',
    },
    {
      'id': 'REP-004',
      'code': 'PC-RPL-011',
      'name': 'PC Desktop Lab RPL (Core i5)',
      'jurusan': 'RPL',
      'damage': 'Sering blue-screen saat compile Android Studio, RAM slot 2 kotor.',
      'reportedBy': 'Siswa Prakerin',
      'technician': 'M. Ridwan',
      'date': '21 Nov 2026',
      'status': 'Sedang Dikerjakan',
    },
    {
      'id': 'REP-005',
      'code': 'INS-SAN-001',
      'name': 'Multimeter Sanwa CD800a',
      'jurusan': 'TITL',
      'damage': 'Penggantian fuse fast-blow 500mA dan kalibrasi akurasi tegangan DC.',
      'reportedBy': 'Pak Bambang I.',
      'technician': 'Bambang Irawan',
      'date': '20 Nov 2026',
      'status': 'Selesai',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredItems {
    final query = _searchController.text.toLowerCase().trim();
    return _repairItems.where((item) {
      final name = (item['name'] as String).toLowerCase();
      final code = (item['code'] as String).toLowerCase();
      final damage = (item['damage'] as String).toLowerCase();
      final status = item['status'] as String;

      final matchQuery = query.isEmpty ||
          name.contains(query) ||
          code.contains(query) ||
          damage.contains(query);

      bool matchStatus = true;
      if (_selectedStatusFilter == 1) matchStatus = status == 'Menunggu Servis';
      if (_selectedStatusFilter == 2) matchStatus = status == 'Sedang Dikerjakan';
      if (_selectedStatusFilter == 3) matchStatus = status == 'Selesai';

      return matchQuery && matchStatus;
    }).toList();
  }

  void _showAddRepairDialog() {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final damageCtrl = TextEditingController();
    final reporterCtrl = TextEditingController();
    final techCtrl = TextEditingController(text: 'Bambang Irawan');
    String selectedJurusan = 'TBSM';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.build_circle_outlined, color: _primaryBlue),
              SizedBox(width: 8),
              Text(
                'Catat Alat Rusak / Perbaikan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textPrimary),
              ),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kode Aset / Unit', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: codeCtrl,
                    decoration: InputDecoration(
                      hintText: 'Contoh: OTO-WLD-005',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Nama Alat', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Mesin Bor Duduk 13mm',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Kejuruan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: selectedJurusan,
                              items: const [
                                DropdownMenuItem(value: 'RPL', child: Text('RPL')),
                                DropdownMenuItem(value: 'TKJ', child: Text('TKJ')),
                                DropdownMenuItem(value: 'TBSM', child: Text('TBSM')),
                                DropdownMenuItem(value: 'TITL', child: Text('TITL')),
                              ],
                              onChanged: (val) {
                                if (val != null) setModalState(() => selectedJurusan = val);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dilaporkan Oleh', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: reporterCtrl,
                              decoration: InputDecoration(
                                hintText: 'Nama guru/siswa',
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
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Deskripsi Kerusakan / Kendala', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: damageCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Jelaskan gejala kerusakan fisik atau fungsi...',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Teknisi Penanggung Jawab', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: techCtrl,
                    decoration: InputDecoration(
                      hintText: 'Nama staf sarpras / teknisi',
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
                if (nameCtrl.text.trim().isEmpty) return;
                setState(() {
                  _repairItems.insert(0, {
                    'id': 'REP-00${_repairItems.length + 1}',
                    'code': codeCtrl.text.trim().isEmpty ? 'ALAT-${_repairItems.length + 1}' : codeCtrl.text.trim(),
                    'name': nameCtrl.text.trim(),
                    'jurusan': selectedJurusan,
                    'damage': damageCtrl.text.trim().isEmpty ? 'Perlu pengecekan berkala' : damageCtrl.text.trim(),
                    'reportedBy': reporterCtrl.text.trim().isEmpty ? 'Staf Sarpras' : reporterCtrl.text.trim(),
                    'technician': techCtrl.text.trim().isEmpty ? 'Bambang Irawan' : techCtrl.text.trim(),
                    'date': 'Hari Ini',
                    'status': 'Menunggu Servis',
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Alat rusak berhasil dicatat ke antrean perbaikan!'),
                    backgroundColor: Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(Map<String, dynamic> item, String newStatus) {
    setState(() {
      item['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status ${item['name']} diubah menjadi: $newStatus'),
        backgroundColor: newStatus == 'Selesai' ? const Color(0xFF16A34A) : _primaryBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isDesktop ? 36 : (widget.screenWidth < 500 ? 14 : 20),
        vertical: widget.screenWidth < 500 ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Tombol Tambah
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
                        'Perbaikan Alat Praktik',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daftar alat dan fasilitas bengkel/lab yang sedang dalam proses perbaikan',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddRepairDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Catat Alat Rusak'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Pencarian & Filter Tab
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
                    hintText: 'Cari alat, kode aset, kerusakan...',
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
                    _buildFilterChip(0, 'Semua Status (${_repairItems.length})'),
                    _buildFilterChip(1, 'Menunggu Servis (${_repairItems.where((e) => e['status'] == 'Menunggu Servis').length})'),
                    _buildFilterChip(2, 'Sedang Dikerjakan (${_repairItems.where((e) => e['status'] == 'Sedang Dikerjakan').length})'),
                    _buildFilterChip(3, 'Selesai (${_repairItems.where((e) => e['status'] == 'Selesai').length})'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Daftar Kartu Perbaikan Sederhana
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
                  'Tidak ada alat dalam antrean perbaikan.',
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

                if (status == 'Menunggu Servis') {
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
                      // Baris Atas: Kode, Nama & Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item['jurusan'] as String,
                                        style: const TextStyle(
                                          color: _primaryBlue,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['code'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _textPrimary,
                                  ),
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
                      const SizedBox(height: 12),

                      // Box Kerusakan
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.report_problem_outlined, size: 16, color: Color(0xFFD97706)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item['damage'] as String,
                                style: const TextStyle(fontSize: 13, color: _textPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Footer Info & Tombol Aksi Responsif
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isCompact = constraints.maxWidth < 620;

                          final infoWidget = Wrap(
                            spacing: 16,
                            runSpacing: 4,
                            children: [
                              Text(
                                'Dilaporkan: ${item['reportedBy']}',
                                style: const TextStyle(fontSize: 12, color: _textSecondary),
                              ),
                              Text(
                                'Teknisi: ${item['technician']}',
                                style: const TextStyle(fontSize: 12, color: _textSecondary),
                              ),
                              Text(
                                'Tgl: ${item['date']}',
                                style: const TextStyle(fontSize: 12, color: _textSecondary),
                              ),
                            ],
                          );

                          final actionWidget = status == 'Menunggu Servis'
                              ? ElevatedButton.icon(
                                  onPressed: () => _updateStatus(item, 'Sedang Dikerjakan'),
                                  icon: const Icon(Icons.play_arrow, size: 16),
                                  label: const Text('Mulai Servis'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                )
                              : (status == 'Sedang Dikerjakan'
                                  ? ElevatedButton.icon(
                                      onPressed: () => _updateStatus(item, 'Selesai'),
                                      icon: const Icon(Icons.check, size: 16),
                                      label: const Text('Selesai & Masukkan ke Rak'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF16A34A),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check_circle, size: 14, color: Color(0xFF16A34A)),
                                          SizedBox(width: 4),
                                          Text(
                                            'Tersedia di Rak',
                                            style: TextStyle(
                                              color: Color(0xFF16A34A),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));

                          if (isCompact) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                infoWidget,
                                const SizedBox(height: 12),
                                Align(alignment: Alignment.centerRight, child: actionWidget),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(child: infoWidget),
                              actionWidget,
                            ],
                          );
                        },
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
