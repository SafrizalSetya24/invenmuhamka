import 'package:flutter/material.dart';

class SaprasConsumablesView extends StatefulWidget {
  final bool isDesktop;
  final double screenWidth;

  const SaprasConsumablesView({
    super.key,
    required this.isDesktop,
    required this.screenWidth,
  });

  @override
  State<SaprasConsumablesView> createState() => _SaprasConsumablesViewState();
}

class _SaprasConsumablesViewState extends State<SaprasConsumablesView> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedJurusanFilter = 0; // 0: Semua, 1: TKJ, 2: RPL, 3: TBSM, 4: TITL
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _consumables = [
    {
      'id': 'BHP-001',
      'name': 'Konektor RJ45 Cat6 AMP',
      'spec': 'Pack isi 50 pcs - Emas 50u',
      'jurusan': 'TKJ',
      'stock': 4,
      'unit': 'Pack',
      'minStock': 10,
      'location': 'Rak TKJ 02',
    },
    {
      'id': 'BHP-002',
      'name': 'Timah Solder Asahi 60/40 0.8mm',
      'spec': 'Roll 250 gram - Praktikum Elektronika',
      'jurusan': 'TITL',
      'stock': 3,
      'unit': 'Roll',
      'minStock': 5,
      'location': 'Lemari TITL 01',
    },
    {
      'id': 'BHP-003',
      'name': 'Kabel UTP Cat6 Belden',
      'spec': 'Dus isi 305 meter (1000 ft)',
      'jurusan': 'TKJ',
      'stock': 12,
      'unit': 'Dus',
      'minStock': 5,
      'location': 'Gudang Jaringan',
    },
    {
      'id': 'BHP-004',
      'name': 'Kawat Las Nikko Steel RD-260',
      'spec': 'Dus isi 5 kg diameter 2.0mm',
      'jurusan': 'TBSM',
      'stock': 5,
      'unit': 'Dus',
      'minStock': 8,
      'location': 'Toolroom Bengkel',
    },
    {
      'id': 'BHP-005',
      'name': 'Oli Mesin Praktik Pertamina Enduro 4T',
      'spec': 'Botol 1 Liter SAE 20W-40',
      'jurusan': 'TBSM',
      'stock': 24,
      'unit': 'Botol',
      'minStock': 10,
      'location': 'Gudang Pelumas',
    },
    {
      'id': 'BHP-006',
      'name': 'ESP32 NodeMCU Module',
      'spec': 'Modul WiFi & Bluetooth IoT praktikum',
      'jurusan': 'RPL',
      'stock': 18,
      'unit': 'Pcs',
      'minStock': 10,
      'location': 'Lab RPL 1',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredConsumables {
    final query = _searchController.text.toLowerCase().trim();
    return _consumables.where((item) {
      final name = (item['name'] as String).toLowerCase();
      final spec = (item['spec'] as String).toLowerCase();
      final jurusan = (item['jurusan'] as String);

      final matchQuery = query.isEmpty || name.contains(query) || spec.contains(query);

      bool matchJurusan = true;
      if (_selectedJurusanFilter == 1) matchJurusan = jurusan == 'TKJ';
      if (_selectedJurusanFilter == 2) matchJurusan = jurusan == 'RPL';
      if (_selectedJurusanFilter == 3) matchJurusan = jurusan == 'TBSM';
      if (_selectedJurusanFilter == 4) matchJurusan = jurusan == 'TITL';

      return matchQuery && matchJurusan;
    }).toList();
  }

  void _showAddBhpDialog() {
    final nameCtrl = TextEditingController();
    final specCtrl = TextEditingController();
    final stockCtrl = TextEditingController(text: '10');
    final unitCtrl = TextEditingController(text: 'Pcs');
    final locCtrl = TextEditingController();
    String selectedJurusan = 'RPL';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: _primaryBlue),
              SizedBox(width: 8),
              Text(
                'Tambah Bahan Habis Pakai',
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
                  const Text('Nama Bahan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Konektor RJ45 Cat6',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Spesifikasi / Keterangan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: specCtrl,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Pack isi 50 pcs',
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
                            const Text('Stok Awal', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: stockCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Satuan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: unitCtrl,
                              decoration: InputDecoration(
                                hintText: 'Pcs / Box / Dus / Roll',
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Lokasi Simpan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: locCtrl,
                              decoration: InputDecoration(
                                hintText: 'Contoh: Rak B-02',
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
                  _consumables.add({
                    'id': 'BHP-00${_consumables.length + 1}',
                    'name': nameCtrl.text.trim(),
                    'spec': specCtrl.text.trim(),
                    'jurusan': selectedJurusan,
                    'stock': int.tryParse(stockCtrl.text.trim()) ?? 1,
                    'unit': unitCtrl.text.trim().isEmpty ? 'Pcs' : unitCtrl.text.trim(),
                    'minStock': 5,
                    'location': locCtrl.text.trim().isEmpty ? 'Gudang Sarpras' : locCtrl.text.trim(),
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bahan habis pakai baru berhasil ditambahkan!'),
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

  void _showRestockDialog(Map<String, dynamic> item) {
    final qtyCtrl = TextEditingController(text: '10');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Tambah Stok: ${item['name']}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stok saat ini: ${item['stock']} ${item['unit']}',
              style: const TextStyle(fontSize: 13, color: _textSecondary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jumlah Stok Masuk',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                suffixText: item['unit'] as String,
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _borderColor)),
              ),
            ),
          ],
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
              final added = int.tryParse(qtyCtrl.text.trim()) ?? 0;
              if (added > 0) {
                setState(() {
                  item['stock'] = (item['stock'] as int) + added;
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Stok ${item['name']} berhasil ditambah $added ${item['unit']}.'),
                    backgroundColor: const Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Tambah Stok'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Bahan?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text('Yakin ingin menghapus ${item['name']} dari daftar bahan habis pakai?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                _consumables.remove(item);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bahan berhasil dihapus.'),
                  backgroundColor: Color(0xFF64748B),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredConsumables;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isDesktop ? 36 : (widget.screenWidth < 500 ? 14 : 20),
        vertical: widget.screenWidth < 500 ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Sederhana & Tombol Aksi
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 620;
                final headerText = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bahan Habis Pakai (BHP)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Daftar stok bahan praktikum laboratorium & bengkel kejuruan',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                );

                final addBtn = ElevatedButton.icon(
                  onPressed: _showAddBhpDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Bahan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          ),
          const SizedBox(height: 16),

          // Bar Pencarian & Filter Kejuruan
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
                    hintText: 'Cari nama bahan, spesifikasi...',
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
                    _buildFilterChip(0, 'Semua Kejuruan'),
                    _buildFilterChip(1, 'TKJ'),
                    _buildFilterChip(2, 'RPL'),
                    _buildFilterChip(3, 'TBSM'),
                    _buildFilterChip(4, 'TITL'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tabel Bersih & Responsif Bahan Habis Pakai
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'Tidak ada bahan habis pakai yang sesuai filter.',
                        style: TextStyle(color: _textSecondary, fontSize: 14),
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      const minTableWidth = 880.0;
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
                                    Expanded(flex: 30, child: Text('NAMA BAHAN & SPESIFIKASI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 12, child: Text('KEJURUAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 14, child: Text('SISA STOK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 14, child: Text('STATUS STOK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    Expanded(flex: 20, child: Text('LOKASI SIMPAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                    SizedBox(width: 12),
                                    SizedBox(width: 140, child: Text('AKSI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textSecondary))),
                                  ],
                                ),
                              ),

                              // Data Rows
                              ...List.generate(filtered.length, (index) {
                                final item = filtered[index];
                                final stock = item['stock'] as int;
                                final minStock = item['minStock'] as int;
                                final isLow = stock <= minStock;
                                final isCritical = stock <= (minStock / 2);
                                final isLast = index == filtered.length - 1;

                                Color statusBg = const Color(0xFFDCFCE7);
                                Color statusFg = const Color(0xFF16A34A);
                                String statusText = 'Aman';

                                if (isCritical) {
                                  statusBg = const Color(0xFFFEF2F2);
                                  statusFg = const Color(0xFFDC2626);
                                  statusText = 'Kritis';
                                } else if (isLow) {
                                  statusBg = const Color(0xFFFEF3C7);
                                  statusFg = const Color(0xFFD97706);
                                  statusText = 'Menipis';
                                }

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: index.isOdd ? const Color(0xFFFAFAFA) : Colors.white,
                                    border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                                  ),
                                  child: Row(
                                    children: [
                                      // Nama & Spesifikasi
                                      Expanded(
                                        flex: 30,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item['name'] as String,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _textPrimary),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              item['spec'] as String,
                                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Kejuruan
                                      Expanded(
                                        flex: 12,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(4),
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
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Sisa Stok
                                      Expanded(
                                        flex: 14,
                                        child: Text(
                                          '$stock ${item['unit']}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _textPrimary),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Status Stok
                                      Expanded(
                                        flex: 14,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: statusBg,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              statusText,
                                              style: TextStyle(
                                                color: statusFg,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Lokasi Simpan
                                      Expanded(
                                        flex: 20,
                                        child: Text(
                                          item['location'] as String,
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Aksi
                                      SizedBox(
                                        width: 140,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () => _showRestockDialog(item),
                                              icon: const Icon(Icons.add, size: 13),
                                              label: const Text('Tambah', style: TextStyle(fontSize: 11)),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: _primaryBlue,
                                                side: const BorderSide(color: _primaryBlue),
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                              tooltip: 'Hapus',
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () => _showDeleteConfirm(item),
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

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedJurusanFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedJurusanFilter = index),
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
