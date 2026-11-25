import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../pages/home/home_page.dart';
import '../pages/sapras/dashboard/dashboard_page.dart';
import '../pages/admin/dashboard/dashboard_page.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();
  final PageController _pageController = PageController();

  bool _rememberMe = true;
  bool _obscurePassword = true;
  bool _isLoading = false;
  int _currentDotIndex = 0;
  Timer? _autoSlideTimer;

  // Warna brand utama SMK Muhammadiyah Kramat
  static const Color _primaryBlue = Color(0xFF0038A8);
  static const Color _bgColor = Color(0xFFEFF3FA);

  // Informasi slide di sisi kiri
  final List<_HeroSlide> _heroSlides = const [
    _HeroSlide(
      title: 'Inventaris Laboratorium & Bengkel Kejuruan',
      description:
          'Pengelolaan sarana dan prasarana praktik kejuruan RPL, Multimedia, dan Teknik secara terdata dan terpusat.',
    ),
    _HeroSlide(
      title: 'Peminjaman Alat Praktik Terintegrasi',
      description:
          'Kemudahan pengajuan peminjaman alat dan bahan praktik untuk siswa dan guru SMK Muhammadiyah Kramat.',
    ),
    _HeroSlide(
      title: 'Pelayanan Sarana Prasarana Sekolah',
      description:
          'Pemantauan status peminjaman, kelaikan unit, dan pengembalian barang secara akurat dan transparan.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final next = (_currentDotIndex + 1) % _heroSlides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    _pageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // Responsif: 2 kolom aktif pada layar lebar (tablet landscape & desktop)
          // dan memiliki tinggi minimal yang memadai
          final bool isTwoColumn = screenWidth >= 840 && screenHeight >= 500;
          final bool isCompact = isTwoColumn && screenHeight < 660;

          // Hitung tinggi card desktop agar selalu pas di viewport tanpa scroll
          final double? cardHeight = isTwoColumn
              ? math.min(580.0, screenHeight - (isCompact ? 20.0 : 40.0))
              : null;

          // Batas lebar card yang adaptif
          final double cardMaxWidth = isTwoColumn
              ? (screenWidth > 1200 ? 1040.0 : (screenWidth * 0.88).clamp(820.0, 1000.0))
              : 460.0;

          return Center(
            child: SingleChildScrollView(
              physics: isTwoColumn
                  ? const ClampingScrollPhysics()
                  : const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 500 ? 12 : 20,
                vertical: isTwoColumn
                    ? (isCompact ? 10 : 18)
                    : (screenWidth < 500 ? 16 : 24),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: cardMaxWidth,
                ),
                child: Container(
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth < 500 ? 20 : 26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.10),
                        blurRadius: 40,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth < 500 ? 20 : 26),
                    child: isTwoColumn
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 11,
                                child: _buildLeftHeroPanel(
                                  isTwoColumn: true,
                                  isCompact: isCompact,
                                ),
                              ),
                              Expanded(
                                flex: 11,
                                child: _buildRightFormPanel(
                                  isTwoColumn: true,
                                  isCompact: isCompact,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: screenWidth < 500 ? 190 : 230,
                                child: _buildLeftHeroPanel(
                                  isTwoColumn: false,
                                  isCompact: false,
                                ),
                              ),
                              _buildRightFormPanel(
                                isTwoColumn: false,
                                isCompact: false,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── LEFT HERO PANEL (FOTO GEDUNG DENGAN TEKS OVERLAY) ─────────────────────
  Widget _buildLeftHeroPanel({
    required bool isTwoColumn,
    required bool isCompact,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Foto Gedung SMK Muhammadiyah Kramat
        AnimatedScale(
          scale: 1.02 + (_currentDotIndex * 0.015),
          duration: const Duration(seconds: 4),
          curve: Curves.easeInOut,
          child: Image.asset(
            'assets/images/gedung_muhamka.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: _primaryBlue,
                child: const Center(
                  child: Icon(Icons.school, size: 50, color: Colors.white30),
                ),
              );
            },
          ),
        ),

        // Semi-transparent gradient overlay untuk keterbacaan teks maksimal
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.42),
                Colors.black.withValues(alpha: 0.16),
                Colors.black.withValues(alpha: 0.72),
                Colors.black.withValues(alpha: 0.92),
              ],
              stops: const [0.0, 0.35, 0.70, 1.0],
            ),
          ),
        ),

        // Konten Teks & Header
        Padding(
          padding: EdgeInsets.all(isTwoColumn ? (isCompact ? 24 : 32) : 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Logo & Nama Sekolah
              _buildLeftHeader(isTwoColumn: isTwoColumn),

              const Spacer(),

              // Teks Headline & Deskripsi (Swipeable Carousel)
              if (isTwoColumn) ...[
                SizedBox(
                  height: isCompact ? 95 : 115,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _heroSlides.length,
                    onPageChanged: (idx) {
                      setState(() => _currentDotIndex = idx);
                    },
                    itemBuilder: (context, index) {
                      final slide = _heroSlides[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            slide.title,
                            style: TextStyle(
                              fontSize: isCompact ? 19 : 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.25,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            slide.description,
                            style: TextStyle(
                              fontSize: isCompact ? 11.5 : 12.5,
                              color: Colors.white.withValues(alpha: 0.88),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _buildDotsIndicator(),
              ] else ...[
                // Di mode mobile (vertikal), tampilkan slogan ringkas
                Text(
                  _heroSlides[_currentDotIndex].title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _buildDotsIndicator(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeftHeader({required bool isTwoColumn}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo Resmi Bundar SMK Muhammadiyah Kramat
        SizedBox(
          width: isTwoColumn ? 42 : 36,
          height: isTwoColumn ? 42 : 36,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: const BoxDecoration(
                  color: _primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'M',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'INVENMUHAMKA',
              style: TextStyle(
                color: Colors.white,
                fontSize: isTwoColumn ? 16 : 14.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'SMK Muhammadiyah Kramat',
              style: TextStyle(
                color: Colors.white,
                fontSize: isTwoColumn ? 12 : 11,
                fontWeight: FontWeight.w400,
                height: 1.15,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      children: List.generate(_heroSlides.length, (i) {
        final isActive = i == _currentDotIndex;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 6),
              width: isActive ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─── RIGHT FORM PANEL ──────────────────────────────────────────────────────
  Widget _buildRightFormPanel({
    required bool isTwoColumn,
    required bool isCompact,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isTwoColumn ? (isCompact ? 32 : 40) : 22,
        vertical: isTwoColumn ? (isCompact ? 18 : 24) : 22,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Masuk ke Akun Anda',
                  style: TextStyle(
                    fontSize: isCompact ? 21 : 23,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Sistem Informasi Inventaris & Sarana Prasarana',
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 12.5,
                    color: const Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
                SizedBox(height: isCompact ? 14 : 18),

                // Field Identifier (NIS / NUPTK / Username)
                const Text(
                  'NIS / NUPTK / Username',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 5),
                _buildInputField(
                  controller: _identityController,
                  hintText: 'Masukkan NIS Siswa atau NUPTK Guru',
                  prefixIcon: Icons.badge_outlined,
                  isCompact: isCompact,
                  onSubmitted: (_) => _handleLogin(),
                ),
                SizedBox(height: isCompact ? 9 : 12),

                // Field Kata Sandi
                const Text(
                  'Kata Sandi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 5),
                _buildInputField(
                  controller: _passwordController,
                  hintText: 'Masukkan kata sandi akun',
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  isCompact: isCompact,
                  obscureText: _obscurePassword,
                  onSubmitted: (_) => _handleLogin(),
                  onToggleVisibility: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                SizedBox(height: isCompact ? 8 : 12),

                // Row: Ingat saya & Lupa kata sandi?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _rememberMe = !_rememberMe);
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: _primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFCBD5E1),
                                  width: 1.4,
                                ),
                                onChanged: (val) {
                                  setState(() => _rememberMe = val ?? false);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Ingat saya',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Silakan hubungi staf Admin/Sapras sekolah untuk reset kata sandi.',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: _primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Lupa kata sandi?',
                          style: TextStyle(
                            fontSize: 12,
                            color: _primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isCompact ? 14 : 18),

                // Tombol Interaktif "Masuk Sekarang →"
                _buildInteractiveLoginButton(isCompact: isCompact),
                SizedBox(height: isCompact ? 10 : 13),

                // Footer: Belum memiliki hak akses? Hubungi Admin IT
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Belum memiliki hak akses? ',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Silakan hubungi Bagian Sarpras/IT SMK Muhammadiyah Kramat.',
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: _primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Hubungi Admin IT',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: _primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isCompact ? 8 : 10),

                // Akun Demo Pengujian Cepat
                _buildQuickDemoSelector(isCompact: isCompact),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── SHORTCUT AKUN DEMO PENGUJIAN ──────────────────────────────────────────
  Widget _buildQuickDemoSelector({required bool isCompact}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: isCompact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.touch_app_outlined, size: 13, color: _primaryBlue),
              const SizedBox(width: 4),
              Text(
                'Akun Demo (Klik untuk auto-fill):',
                style: TextStyle(
                  fontSize: isCompact ? 10 : 10.5,
                  fontWeight: FontWeight.bold,
                  color: _primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 4 : 6),
          Wrap(
            spacing: 5,
            runSpacing: 4,
            children: DummyData.users.map((u) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _identityController.text = u.identifier;
                      _passwordController.text = u.password;
                    });
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Text(
                      u.role == 'Siswa'
                          ? 'Siswa (NIS: ${u.identifier})'
                          : u.role == 'Guru'
                              ? 'Guru (NUPTK: ${u.identifier})'
                              : '${u.role}: ${u.identifier}',
                      style: TextStyle(
                        fontSize: isCompact ? 9.5 : 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── TOMBOL LOGIN INTERAKTIF DENGAN HOVER & LOADING STATE ───────────────────
  Widget _buildInteractiveLoginButton({required bool isCompact}) {
    return _HoverButton(
      isLoading: _isLoading,
      onPressed: _isLoading ? null : _handleLogin,
      primaryColor: _primaryBlue,
      height: isCompact ? 44 : 48,
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    bool obscureText = false,
    bool isCompact = false,
    VoidCallback? onToggleVisibility,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      onFieldSubmitted: onSubmitted,
      style: TextStyle(
        fontSize: isCompact ? 13 : 13.5,
        color: const Color(0xFF1E293B),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: isCompact ? 12.5 : 13,
          color: const Color(0xFF94A3B8),
        ),
        prefixIcon: Icon(
          prefixIcon,
          size: isCompact ? 18 : 19,
          color: const Color(0xFF94A3B8),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: isCompact ? 18 : 19,
                  color: const Color(0xFF94A3B8),
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: isCompact ? 10 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: _primaryBlue, width: 1.6),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_isLoading) return;

    final inputId = _identityController.text.trim();
    final inputPass = _passwordController.text.trim();

    if (inputId.isEmpty || inputPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Silakan masukkan NIS (Siswa) atau NUPTK (Guru) dan Kata Sandi',
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Otomatis autentikasi via Backend API (dengan fallback mulus ke DummyData)
    final matchedUser = await ApiService.instance.login(inputId, inputPass);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (matchedUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login berhasil! Terdeteksi sebagai ${matchedUser.role}: ${matchedUser.name}',
          ),
          backgroundColor: _primaryBlue,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1400),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      Widget targetPage = HomePage(user: matchedUser);
      if (matchedUser.role == 'Sapras') {
        targetPage = SaprasDashboardPage(user: matchedUser);
      } else if (matchedUser.role == 'Admin') {
        targetPage = AdminDashboardPage(user: matchedUser);
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Akun tidak ditemukan atau kata sandi salah!'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}

// ─── TOMBOL HOVER INTERAKTIF UNTUK WEB ───────────────────────────────────────
class _HoverButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color primaryColor;
  final double height;

  const _HoverButton({
    required this.isLoading,
    required this.onPressed,
    required this.primaryColor,
    this.height = 48,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.isLoading
          ? SystemMouseCursors.wait
          : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: widget.primaryColor
                  .withValues(alpha: _isHovered ? 0.40 : 0.25),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Masuk Sekarang',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded,
                            size: 17, color: Colors.white),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSlide {
  final String title;
  final String description;

  const _HeroSlide({
    required this.title,
    required this.description,
  });
}
