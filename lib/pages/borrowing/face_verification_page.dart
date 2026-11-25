import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../cart/cart_page.dart';
import 'borrowing_success_page.dart';

class FaceVerificationPage extends StatefulWidget {
  final UserModel? user;
  final List<CartItemModel> cartItems;
  final String keperluan;
  final String durasi;

  const FaceVerificationPage({
    super.key,
    this.user,
    required this.cartItems,
    required this.keperluan,
    required this.durasi,
  });

  @override
  State<FaceVerificationPage> createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage> {
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _lightBg = Color(0xFFF3F6FC);

  UserModel get _currentUser => widget.user ?? DummyData.users.first;
  bool _isVerifying = false;
  bool _isVerified = false;

  void _verifyFace() {
    setState(() => _isVerifying = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        _isVerified = true;
      });

      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BorrowingSuccessPage(
              user: _currentUser,
              cartItems: widget.cartItems,
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBg,
      appBar: AppBar(
        title: const Text('Verifikasi Wajah Sebelum Pengajuan',
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
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Info user
                Text(
                  _currentUser.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Text(
                  '${_currentUser.role} • ${_currentUser.identifier}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Biometric Scan Frame
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isVerified
                          ? const Color(0xFF22C55E)
                          : _primaryBlue,
                      width: 2.5,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        _isVerified
                            ? Icons.verified_user_rounded
                            : Icons.face_retouching_natural_rounded,
                        size: 90,
                        color: _isVerified
                            ? const Color(0xFF22C55E)
                            : Colors.white70,
                      ),
                      if (_isVerifying)
                        const Positioned.fill(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  _isVerified
                      ? 'Wajah Terverifikasi Cocok!'
                      : _isVerifying
                          ? 'Mencocokkan Biometrik dengan Face Profile...'
                          : 'Verifikasi Kehadiran Peminjam',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isVerified
                        ? const Color(0xFF15803D)
                        : const Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isVerified
                      ? 'Identitas telah tervalidasi. Mengirimkan permohonan ke petugas Sapras...'
                      : 'Sesuai SOP inventaris sekolah, peminjam wajib melakukan verifikasi wajah sebelum permohonan diteruskan ke petugas Sapras.',
                  style: TextStyle(fontSize: 12.5, color: Colors.grey[600], height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _isVerifying || _isVerified ? null : _verifyFace,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      _isVerifying
                          ? 'Memverifikasi...'
                          : _isVerified
                              ? 'Berhasil! Mengalihkan...'
                              : 'Mulai Verifikasi Wajah',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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

