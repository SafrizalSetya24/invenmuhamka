import 'package:flutter/material.dart';

class SaprasInventoryView extends StatefulWidget {
  final bool isDesktop;
  final double screenWidth;

  const SaprasInventoryView({
    super.key,
    required this.isDesktop,
    required this.screenWidth,
  });

  @override
  State<SaprasInventoryView> createState() => _SaprasInventoryViewState();
}

class _SaprasInventoryViewState extends State<SaprasInventoryView> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedDept = 0; // 0: Semua, 1: RPL, 2: TKJ, 3: TBSM, 4: TITL
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _assets = [
    {
      'code': 'CAM-RPL-004',
      'name': 'Kamera DSLR Canon EOS 200D Kit',
      'dept': 'RPL',
      'location': 'Rak L-01 (Lab Multimedia)',
      'stockCurrent': 3,
      'stockTotal': 4,
      'condition': 'Baik',
      'status': 'Tersedia di Loket',
    },
    {
      'code': 'NET-TKJ-012',
      'name': 'OTDR Optical Time-Domain Reflectometer',
      'dept': 'TKJ',
      'location': 'Lemari Fiber Optik (Gd. B)',
      'stockCurrent': 1,
      'stockTotal': 2,
      'condition': 'Baik',
      'status': 'Tersedia di Loket',
    },
    {
      'code': 'OTO-TBSM-055',
      'name': 'Diagnostic Scanner OBD-II Yamaha/Honda',
      'dept': 'TBSM',
      'location': 'Toolroom Bengkel Motor',
      'stockCurrent': 2,
      'stockTotal': 2,
      'condition': 'Baik',
      'status': 'Tersedia di Loket',
    },
    {
      'code': 'ELE-TITL-008',
      'name': 'Insulation Tester Hioki 3455 5kV',
      'dept': 'TITL',
      'location': 'Rak Alat Ukur Gd. C',
      'stockCurrent': 1,
      'stockTotal': 1,
      'condition': 'Baik',
      'status': 'Tersedia di Loket',
    },
    {
      'code': 'RPL-DEV-020',
      'name': 'Mikrokontroler ESP32 Complete Kit',
      'dept': 'RPL',
      'location': 'Rak Komponen Lab 3',
      'stockCurrent': 18,
      'stockTotal': 20,
      'condition': 'Baik',
      'status': 'Tersedia di Loket',
    },
    {
      'code': 'NET-TKJ-089',
      'name': 'Fusion Splicer Fiber Optik Sumitomo Z2C',
      'dept': 'TKJ',
      'location': 'Lemari Khusus Fiber TKJ',
      'stockCurrent': 0,
      'stockTotal': 1,
      'condition': 'Baik',
      'status': 'Sedang Dipinjam',
    },
    {
      'code': 'MSN-TBS-014',
      'name': 'Mesin Las Inverter Lakoni 160A',
      'dept': 'TBSM',
      'location': 'Bengkel Pengelasan',
      'stockCurrent': 0,
      'stockTotal': 2,
      'condition': 'Perlu Servis',
      'status': 'Dalam Perbaikan',
    },
  ];

  List<Map<String, dynamic>> get _filteredAssets {
    return _assets.where((a) {
      if (_selectedDept == 1 && a['dept'] != 'RPL') return false;
      if (_selectedDept == 2 && a['dept'] != 'TKJ') return false;
      if (_selectedDept == 3 && a['dept'] != 'TBSM') return false;
      if (_selectedDept == 4 && a['dept'] != 'TITL') return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = a['name'].toString().toLowerCase();
        final code = a['code'].toString().toLowerCase();
        final loc = a['location'].toString().toLowerCase();
        return name.contains(q) || code.contains(q) || loc.contains(q);
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
              final isCompact = constraints.maxWidth < 620;
              final headerText = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Katalog & Inventaris Alat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Daftar master alat praktik, lokasi penyimpanan, dan status ketersediaan unit.',
                    style: TextStyle(fontSize: 13, color: _textSecondary),
                  ),
                ],
              );

              final addBtn = ElevatedButton.icon(
                onPressed: () => _showAddAssetDialog(),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('+ Tambah Alat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerText,
                    const SizedBox(height: 12),
                    addBtn,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: headerText),
                  const SizedBox(width: 14),
                  addBtn,
                ],
              );
            },
          ),
          const SizedBox(height: 18),

          // Search Field
          Container(
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
                hintText: 'Cari nama alat, kode inventaris, atau lokasi rak...',
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
          const SizedBox(height: 12),

          // Jurusan Filter Chips
          Row(
            children: [
              _buildFilterChip('Semua Jurusan (${_assets.length})', 0),
              const SizedBox(width: 8),
              _buildFilterChip('RPL', 1),
              const SizedBox(width: 8),
              _buildFilterChip('TKJ', 2),
              const SizedBox(width: 8),
              _buildFilterChip('TBSM', 3),
              const SizedBox(width: 8),
              _buildFilterChip('TITL', 4),
            ],
          ),
          const SizedBox(height: 16),

          // Tabel Inventaris Bersih & Responsif
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: _filteredAssets.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text('Tidak ada alat yang sesuai kriteria pencarian.', style: TextStyle(color: _textSecondary, fontSize: 13)),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      const minTableWidth = 920.0;
                      final tableWidth = constraints.maxWidth > minTableWidth ? constraints.maxWidth : minTableWidth;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: tableWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header Baris
                              Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8FAFC),
                                  border: Border(bottom: BorderSide(color: _borderColor)),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(flex: 30, child: Text('KODE & NAMA ALAT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 10, child: Text('JURUSAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 22, child: Text('LOKASI SIMPAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 12, child: Text('STOK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 12, child: Text('KONDISI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 18, child: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    SizedBox(width: 72, child: Text('AKSI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                  ],
                                ),
                              ),

                              // Data Rows
                              ...List.generate(_filteredAssets.length, (index) {
                                final item = _filteredAssets[index];
                                final isGood = item['condition'] == 'Baik';
                                final isLast = index == _filteredAssets.length - 1;

                                Color statusBg = const Color(0xFFDCFCE7);
                                Color statusFg = const Color(0xFF15803D);

                                if (item['status'] == 'Sedang Dipinjam') {
                                  statusBg = const Color(0xFFFEF2F2);
                                  statusFg = const Color(0xFFDC2626);
                                } else if (item['status'] == 'Dalam Perbaikan') {
                                  statusBg = const Color(0xFFFEF2F2);
                                  statusFg = const Color(0xFFDC2626);
                                }

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: index.isOdd ? const Color(0xFFFAFAFA) : Colors.white,
                                    border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                                  ),
                                  child: Row(
                                    children: [
                                      // Kode & Nama
                                      Expanded(
                                        flex: 30,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(item['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textPrimary)),
                                            const SizedBox(height: 2),
                                            Text(item['code'] as String, style: const TextStyle(fontSize: 11, color: _textSecondary)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Jurusan
                                      Expanded(
                                        flex: 10,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEFF6FF),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(item['dept'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _primaryBlue)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Lokasi Simpan
                                      Expanded(
                                        flex: 22,
                                        child: Text(item['location'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                                      ),
                                      const SizedBox(width: 12),

                                      // Stok
                                      Expanded(
                                        flex: 12,
                                        child: Text('${item['stockCurrent']} / ${item['stockTotal']} Unit', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: _textPrimary)),
                                      ),
                                      const SizedBox(width: 12),

                                      // Kondisi
                                      Expanded(
                                        flex: 12,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(isGood ? Icons.check_circle : Icons.warning_amber_rounded, size: 14, color: isGood ? const Color(0xFF16A34A) : const Color(0xFFD97706)),
                                            const SizedBox(width: 4),
                                            Text(item['condition'] as String, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: isGood ? const Color(0xFF15803D) : const Color(0xFFB45309))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Status
                                      Expanded(
                                        flex: 18,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: statusBg,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item['status'] as String,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: statusFg,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Aksi
                                      SizedBox(
                                        width: 72,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit_outlined, size: 17, color: _primaryBlue),
                                              tooltip: 'Edit Alat',
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () => _showEditAssetDialog(item),
                                            ),
                                            const SizedBox(width: 12),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline_rounded, size: 17, color: Color(0xFFDC2626)),
                                              tooltip: 'Hapus Alat',
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () {
                                                setState(() {
                                                  _assets.remove(item);
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Alat ${item['name']} telah dihapus.')),
                                                );
                                              },
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

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedDept == index;
    return InkWell(
      onTap: () => setState(() => _selectedDept = index),
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

  void _showAddAssetDialog() {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final stockCtrl = TextEditingController(text: '1');
    String selectedDept = 'RPL';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Tambah Alat Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Kode Inventaris', hintText: 'Contoh: CAM-RPL-005', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Alat', hintText: 'Contoh: Kamera Sony Alpha A6000', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: selectedDept,
                  decoration: const InputDecoration(labelText: 'Kompetensi Keahlian (Jurusan)', border: OutlineInputBorder(), isDense: true),
                  items: ['RPL', 'TKJ', 'TBSM', 'TITL'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (v) => setModal(() => selectedDept = v!),
                ),
                const SizedBox(height: 10),
                TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Lokasi Simpan', hintText: 'Contoh: Rak L-02 Lab RPL', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah Unit Total', border: OutlineInputBorder(), isDense: true)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue, elevation: 0),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && codeCtrl.text.isNotEmpty) {
                  final total = int.tryParse(stockCtrl.text) ?? 1;
                  setState(() {
                    _assets.insert(0, {
                      'code': codeCtrl.text,
                      'name': nameCtrl.text,
                      'dept': selectedDept,
                      'location': locCtrl.text.isNotEmpty ? locCtrl.text : 'Gudang Sarpras',
                      'stockCurrent': total,
                      'stockTotal': total,
                      'condition': 'Baik',
                      'status': 'Tersedia di Loket',
                    });
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Alat ${nameCtrl.text} berhasil ditambahkan.')),
                  );
                }
              },
              child: const Text('Simpan Alat', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAssetDialog(Map<String, dynamic> item) {
    final nameCtrl = TextEditingController(text: item['name']);
    final locCtrl = TextEditingController(text: item['location']);
    final stockCtrl = TextEditingController(text: item['stockTotal'].toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Edit Alat: ${item['code']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Alat', border: OutlineInputBorder(), isDense: true)),
              const SizedBox(height: 10),
              TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Lokasi Simpan', border: OutlineInputBorder(), isDense: true)),
              const SizedBox(height: 10),
              TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah Total', border: OutlineInputBorder(), isDense: true)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue, elevation: 0),
            onPressed: () {
              setState(() {
                item['name'] = nameCtrl.text;
                item['location'] = locCtrl.text;
                item['stockTotal'] = int.tryParse(stockCtrl.text) ?? item['stockTotal'];
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data ${item['code']} diperbarui.')),
              );
            },
            child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
