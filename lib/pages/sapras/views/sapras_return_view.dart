import 'package:flutter/material.dart';

class SaprasReturnView extends StatefulWidget {
  final bool isDesktop;
  final double screenWidth;

  const SaprasReturnView({
    super.key,
    required this.isDesktop,
    required this.screenWidth,
  });

  @override
  State<SaprasReturnView> createState() => _SaprasReturnViewState();
}

class _SaprasReturnViewState extends State<SaprasReturnView> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedFilter = 0; // 0: Semua, 1: Perlu Diperiksa, 2: Selesai
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _returns = [
    {
      'id': 'TR-202611-0038',
      'applicant': 'Ahmad Fauzi',
      'class': 'XI TITL 2',
      'item': 'Multimeter Digital Fluke 115 True-RMS',
      'code': 'ELEC-TITL-018',
      'due': '11.30 WIB',
      'returnedAt': '11.24 WIB',
      'status': 'Perlu Diperiksa',
      'condition': 'Belum Diperiksa',
    },
    {
      'id': 'TR-202611-0035',
      'applicant': 'Bagus Prasetyo',
      'class': 'XII RPL 2',
      'item': 'Solder Station Weller WESD51',
      'code': 'RPL-DEV-009',
      'due': '11.00 WIB',
      'returnedAt': '11.15 WIB',
      'status': 'Perlu Diperiksa',
      'condition': 'Belum Diperiksa',
    },
    {
      'id': 'TR-202611-0031',
      'applicant': 'Safrizal Setya Wira',
      'class': 'XII RPL 1',
      'item': 'Kamera DSLR Canon EOS 200D',
      'code': 'CAM-RPL-004',
      'due': '10.00 WIB',
      'returnedAt': '09.55 WIB',
      'status': 'Selesai Dikembalikan',
      'condition': 'Kondisi Baik (Kembali ke Rak)',
    },
    {
      'id': 'TR-202611-0028',
      'applicant': 'Rizky Ramadhan',
      'class': 'XI TITL 1',
      'item': 'Multimeter Sanwa CD800a',
      'code': 'INS-SAN-001',
      'due': '09.30 WIB',
      'returnedAt': '09.25 WIB',
      'status': 'Selesai Dikembalikan',
      'condition': 'Kondisi Baik (Kembali ke Rak)',
    },
  ];

  List<Map<String, dynamic>> get _filteredReturns {
    return _returns.where((r) {
      if (_selectedFilter == 1 && r['status'] != 'Perlu Diperiksa') return false;
      if (_selectedFilter == 2 && r['status'] != 'Selesai Dikembalikan') return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = r['applicant'].toString().toLowerCase();
        final item = r['item'].toString().toLowerCase();
        final id = r['id'].toString().toLowerCase();
        return name.contains(q) || item.contains(q) || id.contains(q);
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _returns.where((r) => r['status'] == 'Perlu Diperiksa').length;
    final doneCount = _returns.where((r) => r['status'] == 'Selesai Dikembalikan').length;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isDesktop ? 32 : 16,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bersih & Responsif
          LayoutBuilder(
            builder: (context, constraints) {
              final isHeaderCompact = constraints.maxWidth < 650;
              final headerText = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Pemeriksaan Pengembalian Alat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Pemeriksaan dan penerimaan alat praktikum yang dikembalikan siswa setelah kegiatan praktik.',
                    style: TextStyle(fontSize: 13, color: _textSecondary),
                  ),
                ],
              );

              final scanBtn = ElevatedButton.icon(
                onPressed: () => _showScanBarcodeDialog(),
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                label: const Text('Scan Barcode Alat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              );

              if (isHeaderCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerText,
                    const SizedBox(height: 12),
                    scanBtn,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: headerText),
                  const SizedBox(width: 14),
                  scanBtn,
                ],
              );
            },
          ),
          const SizedBox(height: 18),

          // Search
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontSize: 12.5),
                    decoration: InputDecoration(
                      hintText: 'Cari nama siswa, nomor tiket, atau kode alat...',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF94A3B8)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 16),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Filter Chips
          Row(
            children: [
              _buildFilterChip('Semua (${_returns.length})', 0),
              const SizedBox(width: 8),
              _buildFilterChip('Perlu Diperiksa ($pendingCount)', 1),
              const SizedBox(width: 8),
              _buildFilterChip('Selesai ($doneCount)', 2),
            ],
          ),
          const SizedBox(height: 16),

          // Daftar Kartu Pengembalian
          if (_filteredReturns.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _borderColor),
              ),
              alignment: Alignment.center,
              child: const Text('Tidak ada data pengembalian yang sesuai.', style: TextStyle(color: _textSecondary, fontSize: 13)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredReturns.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final item = _filteredReturns[i];
                final isPending = item['status'] == 'Perlu Diperiksa';

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _borderColor),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCardCompact = constraints.maxWidth < 600;

                      final iconWidget = Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isPending ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isPending ? Icons.pending_actions_outlined : Icons.check_circle_rounded,
                          size: 20,
                          color: isPending ? const Color(0xFFD97706) : const Color(0xFF16A34A),
                        ),
                      );

                      final contentWidget = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item['item'] as String,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textPrimary),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['code'] as String,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _textSecondary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Peminjam: ${item['applicant']} • ${item['class']}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Jatuh Tempo: ${item['due']} • Dikembalikan: ${item['returnedAt']}',
                            style: const TextStyle(fontSize: 11.5, color: _textSecondary),
                          ),
                          if (!isPending) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Kondisi: ${item['condition']}',
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF15803D), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ],
                      );

                      final actionWidget = isPending
                          ? ElevatedButton.icon(
                              onPressed: () => _showInspectionDialog(item),
                              icon: const Icon(Icons.fact_check_outlined, size: 15),
                              label: const Text('Periksa & Terima'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('✓ Selesai', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                            );

                      if (isCardCompact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                iconWidget,
                                const SizedBox(width: 12),
                                Expanded(child: contentWidget),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(alignment: Alignment.centerRight, child: actionWidget),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          iconWidget,
                          const SizedBox(width: 14),
                          Expanded(child: contentWidget),
                          const SizedBox(width: 12),
                          actionWidget,
                        ],
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? _primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
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

  void _showInspectionDialog(Map<String, dynamic> item) {
    int conditionChoice = 0; // 0: Baik, 1: Perlu Servis
    final noteCtrl = TextEditingController(text: 'Kondisi unit lengkap dan normal.');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text('Pemeriksaan: ${item['item']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Peminjam: ${item['applicant']} (${item['class']})', style: const TextStyle(fontSize: 12, color: _textSecondary)),
              const SizedBox(height: 14),
              const Text('Kondisi Alat Saat Ini:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textPrimary)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setModal(() {
                        conditionChoice = 0;
                        noteCtrl.text = 'Kondisi unit lengkap dan normal.';
                      }),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: conditionChoice == 0 ? const Color(0xFFDCFCE7) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: conditionChoice == 0 ? const Color(0xFF16A34A) : _borderColor),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.check_circle_outline, size: 20, color: conditionChoice == 0 ? const Color(0xFF16A34A) : _textSecondary),
                            const SizedBox(height: 4),
                            Text(
                              'Layak / Baik',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: conditionChoice == 0 ? const Color(0xFF15803D) : _textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => setModal(() {
                        conditionChoice = 1;
                        noteCtrl.text = 'Perlu servis/perbaikan teknisi.';
                      }),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: conditionChoice == 1 ? const Color(0xFFFEF3C7) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: conditionChoice == 1 ? const Color(0xFFD97706) : _borderColor),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.build_outlined, size: 20, color: conditionChoice == 1 ? const Color(0xFFD97706) : _textSecondary),
                            const SizedBox(height: 4),
                            Text(
                              'Perlu Servis',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: conditionChoice == 1 ? const Color(0xFF92400E) : _textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: noteCtrl,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  labelText: 'Catatan Petugas',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue, elevation: 0),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  item['status'] = 'Selesai Dikembalikan';
                  item['condition'] = conditionChoice == 0 ? 'Kondisi Baik (Kembali ke Rak)' : 'Perlu Servis (Masuk Antrean)';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pengembalian ${item['item']} berhasil diselesaikan.'),
                    backgroundColor: const Color(0xFF16A34A),
                  ),
                );
              },
              child: const Text('Simpan Pengembalian', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showScanBarcodeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Scan Barcode Unit Masuk', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner_rounded, color: Colors.white70, size: 36),
                  SizedBox(height: 8),
                  Text('Arahkan Barcode Alat ke Kamera', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }
}
