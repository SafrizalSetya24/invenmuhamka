import 'package:flutter/material.dart';

class SaprasApprovalView extends StatefulWidget {
  final bool isDesktop;
  final double screenWidth;

  const SaprasApprovalView({
    super.key,
    required this.isDesktop,
    required this.screenWidth,
  });

  @override
  State<SaprasApprovalView> createState() => _SaprasApprovalViewState();
}

class _SaprasApprovalViewState extends State<SaprasApprovalView> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  int _selectedFilter = 0; // 0: Semua, 1: Menunggu, 2: Disetujui

  final List<Map<String, dynamic>> _loans = [
    {
      'id': 'TR-202611-0042',
      'applicant': 'Safrizal Setya Wira Budiman',
      'class': 'XII RPL 1',
      'item': 'Kamera DSLR Canon EOS 200D Kit',
      'purpose': 'Praktik Desain Media Interaktif - Video Dokumenter Sekolah',
      'date': '24 Nov 2026',
      'time': '08:00 - 12:00 WIB',
      'teacherApproval': 'Disetujui Guru (Hendra, S.Kom)',
      'status': 'Menunggu Loket',
    },
    {
      'id': 'TR-202611-0045',
      'applicant': 'Dimas Bagus Prasetyo',
      'class': 'XII TKJ 2',
      'item': '2 Unit Crimping Tool & LAN Tester Digital',
      'purpose': 'Simulasi UKK Setting VLAN & Trunking',
      'date': '24 Nov 2026',
      'time': '09:30 - 13:30 WIB',
      'teacherApproval': 'Disetujui Guru (Agus Supriyadi, S.T.)',
      'status': 'Menunggu Loket',
    },
    {
      'id': 'TR-202611-0048',
      'applicant': 'Ilham Kurniawan',
      'class': 'XI TBSM 1',
      'item': '1 Set Kunci T & Torque Wrench Snap-on',
      'purpose': 'Praktik Overhaul Mesin Motor Matic',
      'date': '24 Nov 2026',
      'time': '10:00 - 14:00 WIB',
      'teacherApproval': 'Disetujui Guru (Zainal Arifin, S.Pd.)',
      'status': 'Menunggu Loket',
    },
    {
      'id': 'TR-202611-0051',
      'applicant': 'Rizky Ramadhan',
      'class': 'XI TITL 2',
      'item': 'Megger Insulation Tester Hioki 5kV',
      'purpose': 'Uji Tahanan Isolasi Panel Listrik Gedung B',
      'date': '24 Nov 2026',
      'time': '13:00 - 15:30 WIB',
      'teacherApproval': 'Disetujui Guru (Ir. Bambang Tri)',
      'status': 'Menunggu Loket',
    },
  ];

  List<Map<String, dynamic>> get _filteredLoans {
    if (_selectedFilter == 1) {
      return _loans.where((l) => l['status'] == 'Menunggu Loket').toList();
    } else if (_selectedFilter == 2) {
      return _loans.where((l) => l['status'] == 'Disetujui Loket').toList();
    }
    return _loans;
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _loans.where((l) => l['status'] == 'Menunggu Loket').length;
    final approvedCount = _loans.where((l) => l['status'] == 'Disetujui Loket').length;

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
                    'Persetujuan Peminjaman Alat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Daftar permohonan pinjam alat praktikum dari siswa yang memerlukan konfirmasi loket sarpras.',
                    style: TextStyle(fontSize: 13, color: _textSecondary),
                  ),
                ],
              );

              final approveAllBtn = pendingCount > 0
                  ? ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          for (var l in _loans) {
                            if (l['status'] == 'Menunggu Loket') {
                              l['status'] = 'Disetujui Loket';
                            }
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Semua permohonan berhasil disetujui.'),
                            backgroundColor: Color(0xFF16A34A),
                          ),
                        );
                      },
                      icon: const Icon(Icons.done_all_rounded, size: 16),
                      label: const Text('Setujui Semua'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  : null;

              if (isHeaderCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerText,
                    if (approveAllBtn != null) ...[
                      const SizedBox(height: 12),
                      approveAllBtn,
                    ],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: headerText),
                  if (approveAllBtn != null) ...[
                    const SizedBox(width: 14),
                    approveAllBtn,
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 18),

          // Filter Sederhana
          Row(
            children: [
              _buildFilterChip('Semua (${_loans.length})', 0),
              const SizedBox(width: 8),
              _buildFilterChip('Menunggu ($pendingCount)', 1),
              const SizedBox(width: 8),
              _buildFilterChip('Disetujui ($approvedCount)', 2),
            ],
          ),
          const SizedBox(height: 14),

          // Card List Permohonan
          if (_filteredLoans.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _borderColor),
              ),
              alignment: Alignment.center,
              child: const Text('Tidak ada permohonan dalam kategori ini.', style: TextStyle(color: _textSecondary, fontSize: 13)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredLoans.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final item = _filteredLoans[i];
                final isApproved = item['status'] == 'Disetujui Loket';
                final isRejected = item['status'].toString().startsWith('Ditolak');

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
                            'Waktu: ${item['date']}, ${item['time']} • ${item['teacherApproval']}',
                            style: const TextStyle(fontSize: 11.5, color: _textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keperluan: ${item['purpose']}',
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569)),
                          ),
                        ],
                      );

                      final actionWidget = isApproved
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('✓ Disetujui', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                            )
                          : (isRejected
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(item['status'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFFFECACA)),
                                        backgroundColor: const Color(0xFFFEF2F2),
                                        foregroundColor: const Color(0xFFDC2626),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: () => _showRejectDialog(item),
                                      child: const Text('Tolak'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryBlue,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          item['status'] = 'Disetujui Loket';
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Permohonan ${item['applicant']} telah disetujui.'),
                                            backgroundColor: const Color(0xFF16A34A),
                                          ),
                                        );
                                      },
                                      child: const Text('Setujui'),
                                    ),
                                  ],
                                ));

                      final statusIcon = Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isApproved ? const Color(0xFFDCFCE7) : (isRejected ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isApproved ? Icons.check_circle_rounded : (isRejected ? Icons.cancel_outlined : Icons.schedule_rounded),
                          size: 20,
                          color: isApproved ? const Color(0xFF16A34A) : (isRejected ? const Color(0xFFDC2626) : _primaryBlue),
                        ),
                      );

                      if (isCardCompact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                statusIcon,
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
                          statusIcon,
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

  void _showRejectDialog(Map<String, dynamic> item) {
    String selectedReason = 'Jadwal Bentrok dengan Praktik Jurusan Lain';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text('Tolak Permohonan: ${item['applicant']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alat: ${item['item']}', style: const TextStyle(fontSize: 12, color: _textSecondary)),
              const SizedBox(height: 12),
              const Text('Alasan Penolakan:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textPrimary)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: selectedReason,
                isExpanded: true,
                items: [
                  'Jadwal Bentrok dengan Praktik Jurusan Lain',
                  'Unit Sedang Dalam Perbaikan',
                  'Stok Alat Tidak Mencukupi',
                  'Alasan Teknis Lainnya',
                ].map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 12)))).toList(),
                onChanged: (v) => setModal(() => selectedReason = v!),
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), elevation: 0),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  item['status'] = 'Ditolak: $selectedReason';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Permohonan ${item['id']} ditolak.'),
                    backgroundColor: const Color(0xFFDC2626),
                  ),
                );
              },
              child: const Text('Tolak Permohonan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
