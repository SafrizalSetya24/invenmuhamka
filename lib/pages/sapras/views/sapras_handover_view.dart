import 'package:flutter/material.dart';

class SaprasHandoverView extends StatefulWidget {
  final bool isDesktop;
  final double screenWidth;

  const SaprasHandoverView({
    super.key,
    required this.isDesktop,
    required this.screenWidth,
  });

  @override
  State<SaprasHandoverView> createState() => _SaprasHandoverViewState();
}

class _SaprasHandoverViewState extends State<SaprasHandoverView> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedFilter = 0; // 0: Semua, 1: Siap Diambil, 2: Sudah Diserahkan
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'TR-202611-0042',
      'applicant': 'Safrizal Setya Wira Budiman',
      'class': 'XII RPL 1',
      'item': '1 Unit Kamera DSLR Canon EOS 200D Kit',
      'location': 'Lab Multimedia 2',
      'time': '08.00 - 12.00 WIB',
      'teacher': 'Hendra, S.Kom',
      'status': 'Siap Diambil',
    },
    {
      'id': 'TR-202611-0045',
      'applicant': 'Dimas Bagus Prasetyo',
      'class': 'XII TKJ 2',
      'item': '2 Unit Crimping Tool & LAN Tester Digital',
      'location': 'Bengkel Jaringan TKJ',
      'time': '09.30 - 13.30 WIB',
      'teacher': 'Agus Supriyadi, S.T.',
      'status': 'Siap Diambil',
    },
    {
      'id': 'TR-202611-0048',
      'applicant': 'Ilham Kurniawan',
      'class': 'XI TBSM 1',
      'item': '1 Set Kunci T & Torque Wrench Snap-on',
      'location': 'Bengkel Otomotif 1',
      'time': '10.00 - 14.00 WIB',
      'teacher': 'Zainal Arifin, S.Pd.',
      'status': 'Siap Diambil',
    },
    {
      'id': 'TR-202611-0036',
      'applicant': 'Bagus Prasetyo',
      'class': 'XII RPL 2',
      'item': 'Solder Station Weller WESD51',
      'location': 'Lab IoT & Mikrokontroler',
      'time': '07.30 - 11.30 WIB',
      'teacher': 'Hendra, S.Kom',
      'status': 'Sudah Diserahkan',
    },
    {
      'id': 'TR-202611-0039',
      'applicant': 'Rizky Ramadhan',
      'class': 'XI TITL 2',
      'item': 'Multimeter Sanwa CD800a',
      'location': 'Bengkel Listrik TITL',
      'time': '07.45 - 11.45 WIB',
      'teacher': 'Ir. Bambang Tri',
      'status': 'Sudah Diserahkan',
    },
  ];

  List<Map<String, dynamic>> get _filteredTickets {
    return _tickets.where((t) {
      if (_selectedFilter == 1 && t['status'] != 'Siap Diambil') return false;
      if (_selectedFilter == 2 && t['status'] != 'Sudah Diserahkan') return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = t['applicant'].toString().toLowerCase();
        final item = t['item'].toString().toLowerCase();
        final id = t['id'].toString().toLowerCase();
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
    final readyCount = _tickets.where((t) => t['status'] == 'Siap Diambil').length;
    final handedCount = _tickets.where((t) => t['status'] == 'Sudah Diserahkan').length;

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
                    'Penyerahan Alat di Loket',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Verifikasi dan serahkan alat praktikum kepada siswa yang permohonannya telah disetujui.',
                    style: TextStyle(fontSize: 13, color: _textSecondary),
                  ),
                ],
              );

              final scanBtn = ElevatedButton.icon(
                onPressed: () => _showScanQRDialog(),
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                label: const Text('Scan QR Siswa'),
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

          // Search & Filter
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
                      hintText: 'Cari nama siswa, nomor tiket, atau nama alat...',
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
              _buildFilterChip('Semua (${_tickets.length})', 0),
              const SizedBox(width: 8),
              _buildFilterChip('Siap Diambil ($readyCount)', 1),
              const SizedBox(width: 8),
              _buildFilterChip('Sudah Diserahkan ($handedCount)', 2),
            ],
          ),
          const SizedBox(height: 16),

          // Daftar Kartu Penyerahan
          if (_filteredTickets.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _borderColor),
              ),
              alignment: Alignment.center,
              child: const Text('Tidak ada tiket penyerahan yang sesuai.', style: TextStyle(color: _textSecondary, fontSize: 13)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredTickets.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final item = _filteredTickets[i];
                final isReady = item['status'] == 'Siap Diambil';

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
                          color: isReady ? const Color(0xFFEFF6FF) : const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isReady ? Icons.inventory_2_outlined : Icons.check_circle_rounded,
                          size: 20,
                          color: isReady ? _primaryBlue : const Color(0xFF16A34A),
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
                                  item['id'] as String,
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
                            'Jadwal: ${item['time']} • Persetujuan: ${item['teacher']} • Lokasi: ${item['location']}',
                            style: const TextStyle(fontSize: 11.5, color: _textSecondary),
                          ),
                        ],
                      );

                      final actionWidget = isReady
                          ? ElevatedButton.icon(
                              onPressed: () => _confirmHandover(item),
                              icon: const Icon(Icons.handshake_outlined, size: 15),
                              label: const Text('Serahkan Alat'),
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
                              child: const Text('✓ Sudah Diserahkan', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
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

  void _confirmHandover(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Konfirmasi Penyerahan Alat', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Serahkan ${item['item']} kepada ${item['applicant']} (${item['class']})?'),
            const SizedBox(height: 10),
            const Text('Pastikan kondisi alat telah diperiksa bersama peminjam di loket.', style: TextStyle(fontSize: 11.5, color: _textSecondary)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue, elevation: 0),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                item['status'] = 'Sudah Diserahkan';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Alat ${item['item']} berhasil diserahkan kepada ${item['applicant']}.'),
                  backgroundColor: const Color(0xFF16A34A),
                ),
              );
            },
            child: const Text('Konfirmasi Serahkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showScanQRDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Scan QR Tiket Siswa', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                  Text('Arahkan QR Tiket Siswa ke Kamera', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
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
