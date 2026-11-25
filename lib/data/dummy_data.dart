class UserModel {
  final String id;
  final String name;
  final String identifier; // NIS / NUPTK / Username
  final String role; // 'Siswa' / 'Guru' / 'Sapras' / 'Admin'
  final String subInfo; // 'XI RPL 1' atau 'Guru Produktif TKJ'
  final String initials;
  final String password;
  final bool hasFaceRegistered;

  const UserModel({
    required this.id,
    required this.name,
    required this.identifier,
    required this.role,
    required this.subInfo,
    required this.initials,
    required this.password,
    this.hasFaceRegistered = true,
  });
}

enum ItemType { unit, consumable }

class CatalogItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final ItemType type;
  final int availableStock;
  final int totalStock;
  final String unit; // 'Unit', 'Pcs', 'Roll', 'Box', 'Meter'
  final String location;
  final String iconEmoji;

  const CatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.type,
    required this.availableStock,
    required this.totalStock,
    required this.unit,
    required this.location,
    required this.iconEmoji,
  });
}

class DummyData {
  // Daftar Akun Dummy Sesuai Peran di SMK Muhammadiyah Kramat
  static const List<UserModel> users = [
    // 1. Akun Siswa (Sesuai Desain Dashboard)
    UserModel(
      id: 'usr-001',
      name: 'Safrizal Setya Wira Budiman',
      identifier: '22090044', // NIS
      role: 'Siswa',
      subInfo: 'XI RPL 1',
      initials: 'SB',
      password: '123',
      hasFaceRegistered: true,
    ),

    // 2. Akun Guru
    UserModel(
      id: 'usr-002',
      name: 'Ahmad Fauzi, S.Kom.',
      identifier: '198705122010011003', // NUPTK
      role: 'Guru',
      subInfo: 'Guru Produktif RPL',
      initials: 'AF',
      password: '123',
      hasFaceRegistered: true,
    ),

    // 3. Akun Petugas Sapras
    UserModel(
      id: 'usr-003',
      name: 'Bambang Irawan, S.T.',
      identifier: 'sapras',
      role: 'Sapras',
      subInfo: 'Pengelola Aset & Alat',
      initials: 'BI',
      password: '123',
      hasFaceRegistered: true,
    ),

    // 4. Akun Administrator IT
    UserModel(
      id: 'usr-004',
      name: 'Admin IT Muhamka',
      identifier: 'admin',
      role: 'Admin',
      subInfo: 'Administrator Sistem',
      initials: 'AD',
      password: '123',
      hasFaceRegistered: true,
    ),
  ];

  // Daftar Kategori Barang di SMK Muhammadiyah Kramat
  static const List<String> categories = [
    'Semua',
    'Multimedia & Kamera',
    'Lab Komputer & RPL',
    'Jaringan & TKJ',
    'Alat Teknik & Praktik',
    'Bahan Habis Pakai',
  ];

  // Data Barang Katalog Sekolah
  static const List<CatalogItem> catalogItems = [
    CatalogItem(
      id: 'ITM-001',
      name: 'Canon EOS 200D Kit 18-55mm',
      category: 'Multimedia & Kamera',
      description: 'Kamera DSLR kompak untuk praktik fotografi, liputan sekolah, dan pembuatan media jurusan.',
      type: ItemType.unit,
      availableStock: 3,
      totalStock: 5,
      unit: 'Unit',
      location: 'Lemari Multimedia A-1',
      iconEmoji: '📷',
    ),
    CatalogItem(
      id: 'ITM-002',
      name: 'Tripod Takara ECO-193A',
      category: 'Multimedia & Kamera',
      description: 'Tripod aluminium dengan pan head fluida ringan untuk kamera DSLR/Mirrorless.',
      type: ItemType.unit,
      availableStock: 6,
      totalStock: 8,
      unit: 'Unit',
      location: 'Rak Multimedia A-2',
      iconEmoji: '📐',
    ),
    CatalogItem(
      id: 'ITM-003',
      name: 'Laptop ASUS VivoBook Core i5 (Lab RPL)',
      category: 'Lab Komputer & RPL',
      description: 'Laptop pemrograman mobile & web untuk ujian sertifikasi dan praktik lab.',
      type: ItemType.unit,
      availableStock: 8,
      totalStock: 15,
      unit: 'Unit',
      location: 'Lab RPL 1 - Rak Laptop',
      iconEmoji: '💻',
    ),
    CatalogItem(
      id: 'ITM-004',
      name: 'Crimping Tool RJ45 Proskit',
      category: 'Jaringan & TKJ',
      description: 'Tang crimping kabel UTP Cat5e/Cat6 untuk instalasi jaringan lab komputer.',
      type: ItemType.unit,
      availableStock: 12,
      totalStock: 15,
      unit: 'Pcs',
      location: 'Lab TKJ - Toolbox 3',
      iconEmoji: '🔧',
    ),
    CatalogItem(
      id: 'ITM-005',
      name: 'Konektor RJ45 Cat6 Belden (Habis Pakai)',
      category: 'Bahan Habis Pakai',
      description: 'Kepala konektor LAN RJ45 gold plated. Barang habis pakai (tidak perlu dikembalikan).',
      type: ItemType.consumable,
      availableStock: 85,
      totalStock: 100,
      unit: 'Pcs',
      location: 'Gudang Bahan TKJ',
      iconEmoji: '🔌',
    ),
    CatalogItem(
      id: 'ITM-006',
      name: 'Kabel UTP Cat6 Spectra (Per Meter)',
      category: 'Bahan Habis Pakai',
      description: 'Kabel jaringan high-speed untuk praktik pengkabelan LAN siswa.',
      type: ItemType.consumable,
      availableStock: 140,
      totalStock: 305,
      unit: 'Meter',
      location: 'Gudang Bahan TKJ - Roll 2',
      iconEmoji: '🧵',
    ),
    CatalogItem(
      id: 'ITM-007',
      name: 'Digital Multimeter Sanwa CD800a',
      category: 'Alat Teknik & Praktik',
      description: 'Multitester digital presisi tinggi untuk pengukuran arus, tegangan, dan resistansi.',
      type: ItemType.unit,
      availableStock: 5,
      totalStock: 10,
      unit: 'Unit',
      location: 'Lab Teknik Listrik Rak B',
      iconEmoji: '📟',
    ),
    CatalogItem(
      id: 'ITM-008',
      name: 'Proyektor Epson EB-E500',
      category: 'Multimedia & Kamera',
      description: 'Proyektor 3300 Lumens resolusi XGA HDMI untuk presentasi kelas dan seminar.',
      type: ItemType.unit,
      availableStock: 2,
      totalStock: 4,
      unit: 'Unit',
      location: 'Ruang Sapras Lemari P-1',
      iconEmoji: '📽️',
    ),
    CatalogItem(
      id: 'ITM-009',
      name: 'Solder Listrik Goot KX-40R 40W',
      category: 'Alat Teknik & Praktik',
      description: 'Solder pemanas mata tembaga awet untuk perakitan komponen elektronika & robotik.',
      type: ItemType.unit,
      availableStock: 10,
      totalStock: 12,
      unit: 'Unit',
      location: 'Lab Otomasi Industri',
      iconEmoji: '🔥',
    ),
    CatalogItem(
      id: 'ITM-010',
      name: 'Timah Solder Asahi 60/40 0.8mm',
      category: 'Bahan Habis Pakai',
      description: 'Timah gulung kawat solder berkualitas tinggi dengan resin flux. (Habis Pakai)',
      type: ItemType.consumable,
      availableStock: 18,
      totalStock: 20,
      unit: 'Roll',
      location: 'Gudang Bahan Praktik',
      iconEmoji: '🔘',
    ),
  ];

  /// Fungsi autentikasi pencocokan akun dummy
  static UserModel? authenticate(String identifier, String password) {
    final cleanId = identifier.trim().toLowerCase();
    final cleanPass = password.trim();

    for (final user in users) {
      if ((user.identifier.toLowerCase() == cleanId ||
              user.name.toLowerCase() == cleanId) &&
          user.password == cleanPass) {
        return user;
      }
    }
    return null;
  }
}
