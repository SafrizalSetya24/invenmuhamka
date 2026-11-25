import 'package:flutter/material.dart';

class SaprasNotificationsView extends StatefulWidget {
  final bool isDesktop;
  final double screenWidth;
  final void Function(int tabIndex)? onNavigateTab;

  const SaprasNotificationsView({
    super.key,
    required this.isDesktop,
    required this.screenWidth,
    this.onNavigateTab,
  });

  @override
  State<SaprasNotificationsView> createState() => _SaprasNotificationsViewState();
}

class _SaprasNotificationsViewState extends State<SaprasNotificationsView> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedFilter = 0; // 0: Semua, 1: Belum Dibaca, 2: Sirkulasi, 3: Logistik & BHP, 4: Fasilitas

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif-1',
      'category': 'sirkulasi',
      'title': 'Permohonan Pinjam Kamera Segera Kedaluwarsa',
      'desc': 'Siswa Safrizal Setya Wira mengajukan Kamera DSLR Canon EOS 200D. Batas waktu respon tersisa 15 menit.',
      'time': '10 menit yang lalu',
      'isUnread': true,
      'targetTab': 1,
      'actionLabel': 'Buka Persetujuan',
      'icon': Icons.timer_outlined,
      'iconBg': Color(0xFFFEF3C7),
      'iconFg': Color(0xFFD97706),
    },
    {
      'id': 'notif-2',
      'category': 'sirkulasi',
      'title': 'Unit Proyektor Terlambat Kembali',
      'desc': 'Peminjaman LCD Projector Epson EB-X500 oleh Siti Aminah, M.Pd melewati batas waktu pengembalian (terlambat 25 menit).',
      'time': '25 menit yang lalu',
      'isUnread': true,
      'targetTab': 3,
      'actionLabel': 'Cek Pengembalian',
      'icon': Icons.warning_amber_rounded,
      'iconBg': Color(0xFFFEF2F2),
      'iconFg': Color(0xFFDC2626),
    },
    {
      'id': 'notif-3',
      'category': 'logistik',
      'title': 'Peringatan Stok BHP Kritis: Timah Solder',
      'desc': 'Stok Timah Solder Asahi 60/40 tersisa 3 Roll di Lemari TITL 01. Batas minimum pengadaan adalah 5 Roll.',
      'time': '1 jam yang lalu',
      'isUnread': true,
      'targetTab': 5,
      'actionLabel': 'Tambah Stok',
      'icon': Icons.inventory_2_outlined,
      'iconBg': Color(0xFFEFF6FF),
      'iconFg': _primaryBlue,
    },
    {
      'id': 'notif-4',
      'category': 'fasilitas',
      'title': 'Laporan Kerusakan Baru: Mesin Las Inverter',
      'desc': 'Pak Joko melaporkan Mesin Las Inverter Lakoni 160A (OTO-WLD-002) mengalami kendala kipas pendingin mati saat arus 120A.',
      'time': 'Kemarin • 14:15 WIB',
      'isUnread': false,
      'targetTab': 6,
      'actionLabel': 'Antrean Servis',
      'icon': Icons.build_circle_outlined,
      'iconBg': Color(0xFFF3E8FF),
      'iconFg': Color(0xFF9333EA),
    },
    {
      'id': 'notif-5',
      'category': 'fasilitas',
      'title': 'Keluhan Fasilitas Lab RPL 1 Masuk',
      'desc': 'Laporan dari siswa: Stopkontak di meja baris 3 kendor & sering timbul percikan saat tancap adaptor laptop.',
      'time': '24 Nov 2026 • 09:15 WIB',
      'isUnread': false,
      'targetTab': 7,
      'actionLabel': 'Lihat Keluhan',
      'icon': Icons.chat_bubble_outline_rounded,
      'iconBg': Color(0xFFF1F5F9),
      'iconFg': Color(0xFF475569),
    },
    {
      'id': 'notif-6',
      'category': 'sirkulasi',
      'title': 'Pengembalian Selesai: Multimeter Sanwa',
      'desc': 'Pemeriksaan fisik unit Multimeter Sanwa CD800a selesai dengan kondisi Baik dan telah dikembalikan ke Rak A-02.',
      'time': '23 Nov 2026 • 11:30 WIB',
      'isUnread': false,
      'targetTab': 4,
      'actionLabel': 'Katalog Unit',
      'icon': Icons.check_circle_outline_rounded,
      'iconBg': Color(0xFFDCFCE7),
      'iconFg': Color(0xFF16A34A),
    },
    {
      'id': 'notif-7',
      'category': 'logistik',
      'title': 'Restock Berhasil: Konektor RJ45 Cat6',
      'desc': 'Penambahan stok 10 Pack Konektor RJ45 Cat6 AMP telah dicatat ke inventaris gudang TKJ.',
      'time': '22 Nov 2026 • 15:00 WIB',
      'isUnread': false,
      'targetTab': 5,
      'actionLabel': 'Bahan Habis Pakai',
      'icon': Icons.add_box_outlined,
      'iconBg': Color(0xFFEFF6FF),
      'iconFg': _primaryBlue,
    },
  ];

  List<Map<String, dynamic>> get _filteredList {
    if (_selectedFilter == 1) {
      return _notifications.where((n) => n['isUnread'] as bool).toList();
    } else if (_selectedFilter == 2) {
      return _notifications.where((n) => n['category'] == 'sirkulasi').toList();
    } else if (_selectedFilter == 3) {
      return _notifications.where((n) => n['category'] == 'logistik').toList();
    } else if (_selectedFilter == 4) {
      return _notifications.where((n) => n['category'] == 'fasilitas').toList();
    }
    return _notifications;
  }

  int get _unreadCount => _notifications.where((n) => n['isUnread'] as bool).length;

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['isUnread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi telah ditandai sebagai dibaca.'),
        backgroundColor: Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredList;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isDesktop ? 36 : (widget.screenWidth < 500 ? 14 : 20),
        vertical: widget.screenWidth < 500 ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu Responsif
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 620;
                final headerText = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Notifikasi Sarpras',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Catatan lengkap peminjaman, pengembalian, status logistik, dan laporan fasilitas',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                );

                final markReadBtn = _unreadCount > 0
                    ? ElevatedButton.icon(
                        onPressed: _markAllAsRead,
                        icon: const Icon(Icons.done_all_rounded, size: 16),
                        label: const Text('Tandai Semua Dibaca'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      )
                    : null;

                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerText,
                      if (markReadBtn != null) ...[
                        const SizedBox(height: 12),
                        markReadBtn,
                      ],
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: headerText),
                    if (markReadBtn != null) ...[
                      const SizedBox(width: 14),
                      markReadBtn,
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Filter Tabs
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip(0, 'Semua (${_notifications.length})'),
                _buildFilterChip(1, 'Belum Dibaca ($_unreadCount)'),
                _buildFilterChip(2, 'Sirkulasi & Jatuh Tempo (${_notifications.where((n) => n['category'] == 'sirkulasi').length})'),
                _buildFilterChip(3, 'Logistik & BHP (${_notifications.where((n) => n['category'] == 'logistik').length})'),
                _buildFilterChip(4, 'Fasilitas & Servis (${_notifications.where((n) => n['category'] == 'fasilitas').length})'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Daftar Notifikasi
          if (list.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor),
              ),
              child: const Center(
                child: Text(
                  'Tidak ada notifikasi pada kategori ini.',
                  style: TextStyle(color: _textSecondary, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = list[index];
                final isUnread = item['isUnread'] as bool;
                final icon = item['icon'] as IconData;
                final iconBg = item['iconBg'] as Color;
                final iconFg = item['iconFg'] as Color;
                final targetTab = item['targetTab'] as int?;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUnread ? _primaryBlue.withValues(alpha: 0.35) : _borderColor,
                      width: isUnread ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: iconBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconFg, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                      color: _textPrimary,
                                    ),
                                  ),
                                ),
                                if (isUnread) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Baru',
                                      style: TextStyle(
                                        color: Color(0xFFDC2626),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['desc'] as String,
                              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.4),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.schedule_rounded, size: 13, color: Colors.grey.shade400),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['time'] as String,
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                    ),
                                  ],
                                ),
                                if (targetTab != null && widget.onNavigateTab != null)
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() => item['isUnread'] = false);
                                      widget.onNavigateTab!(targetTab);
                                    },
                                    icon: const Icon(Icons.arrow_forward_rounded, size: 13),
                                    label: Text(item['actionLabel'] as String, style: const TextStyle(fontSize: 11)),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: _primaryBlue,
                                      side: const BorderSide(color: Color(0xFFBFDBFE)),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                  ),
                              ],
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
    final isSelected = _selectedFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = index),
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
