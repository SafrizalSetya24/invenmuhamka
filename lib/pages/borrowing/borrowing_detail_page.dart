import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../cart/cart_page.dart';
import 'face_verification_page.dart';

class BorrowingDetailPage extends StatefulWidget {
  final UserModel? user;
  final List<CartItemModel> cartItems;

  const BorrowingDetailPage({
    super.key,
    this.user,
    required this.cartItems,
  });

  @override
  State<BorrowingDetailPage> createState() => _BorrowingDetailPageState();
}

class _BorrowingDetailPageState extends State<BorrowingDetailPage> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _lightBg = Color(0xFFF3F6FC);

  UserModel get _currentUser => widget.user ?? DummyData.users.first;

  final TextEditingController _keperluanController = TextEditingController(
    text: 'Praktikum mata pelajaran Pemrograman Mobile di Lab RPL 1',
  );
  String _selectedDuration = '4 Jam (Hari ini)';

  @override
  void dispose() {
    _keperluanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 500;

    return Scaffold(
      backgroundColor: _lightBg,
      appBar: AppBar(
        title: const Text('Detail Peminjaman & Keperluan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.withValues(alpha: 0.15), height: 1),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 14 : 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 720),
            padding: EdgeInsets.all(isMobile ? 18 : 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Peminjam (Responsive Wrap/Row)
                if (isMobile) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _primaryBlue,
                        child: Text(_currentUser.initials,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_currentUser.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(
                                '${_currentUser.role} • ${_currentUser.identifier}',
                                style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Bebas Tanggungan',
                        style: TextStyle(
                            color: Color(0xFF15803D),
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold)),
                  ),
                ] else ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _primaryBlue,
                        child: Text(_currentUser.initials,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_currentUser.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(
                                '${_currentUser.role} • ${_currentUser.identifier} • ${_currentUser.subInfo}',
                                style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Bebas Tanggungan',
                            style: TextStyle(
                                color: Color(0xFF15803D),
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
                const Divider(height: 32),

                // Daftar Barang yang Diajukan
                const Text('Daftar Barang dalam Permohonan:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...widget.cartItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 16, color: _primaryBlue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(item.name,
                              style: const TextStyle(fontSize: 13)),
                        ),
                        Text('${item.quantity} ${item.unit}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  );
                }),
                const Divider(height: 32),

                // Form Keperluan
                const Text('Keperluan Peminjaman / Kegiatan Praktik:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _keperluanController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 18),

                // Estimasi Durasi
                const Text('Rencana Durasi Peminjaman:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDuration,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: '2 Jam', child: Text('2 Jam (Sesi Praktik)')),
                    DropdownMenuItem(value: '4 Jam (Hari ini)', child: Text('4 Jam (Hari ini)')),
                    DropdownMenuItem(value: '1 Hari Penuh', child: Text('1 Hari Penuh')),
                    DropdownMenuItem(value: '3 Hari (Kegiatan Sekolah)', child: Text('3 Hari (Kegiatan Sekolah)')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDuration = val);
                  },
                ),
                const SizedBox(height: 24),

                // Catatan Aturan SOP
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 18, color: Color(0xFFB45309)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Setelah verifikasi wajah, permohonan akan berstatus "WAITING_APPROVAL". Petugas Sapras memiliki batas waktu maks. 2 jam untuk menyetujui sebelum booking kedaluwarsa.',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF92400E)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Tombol Lanjut ke Face Verification
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FaceVerificationPage(
                            user: _currentUser,
                            cartItems: widget.cartItems,
                            keperluan: _keperluanController.text,
                            durasi: _selectedDuration,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt_outlined, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            isMobile
                                ? 'Verifikasi Wajah Biometrik →'
                                : 'Lanjut ke Verifikasi Wajah (Face Biometric) →',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
