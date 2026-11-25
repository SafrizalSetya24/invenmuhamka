import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dummy_data.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  static ApiService get instance => _instance;
  ApiService._internal();

  /// URL Backend. Mendukung localhost dan IP jaringan lokal LAN / Wi-Fi.
  static String baseUrl = 'http://localhost:3000';

  String? _token;
  String? get token => _token;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  /// Inisialisasi URL: Jika diakses lewat browser (misal dari HP ke IP laptop),
  /// otomatis gunakan IP browser tersebut sebagai host backend.
  Future<void> initBaseUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customUrl = prefs.getString('api_base_url');
      if (customUrl != null && customUrl.isNotEmpty) {
        baseUrl = customUrl;
        return;
      }

      if (kIsWeb) {
        final currentHost = Uri.base.host;
        if (currentHost.isNotEmpty && currentHost != 'localhost' && currentHost != '127.0.0.1') {
          baseUrl = 'http://$currentHost:3000';
          return;
        }
      }
    } catch (_) {}
  }

  /// Ubah URL Backend secara manual
  Future<void> setBaseUrl(String newUrl) async {
    baseUrl = newUrl.replaceAll(RegExp(r'/+$'), '');
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_base_url', baseUrl);
    } catch (_) {}
  }

  /// Cek koneksi ke backend
  Future<bool> checkConnection() async {
    await initBaseUrl();
    try {
      final res = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (_) {
      // Coba IP fallback LAN
      if (baseUrl.contains('localhost') || baseUrl.contains('127.0.0.1')) {
        try {
          const lanUrl = 'http://172.20.10.2:3000';
          final res2 = await http.get(Uri.parse(lanUrl)).timeout(const Duration(seconds: 2));
          if (res2.statusCode == 200) {
            baseUrl = lanUrl;
            return true;
          }
        } catch (_) {}
      }
      return false;
    }
  }

  /// Login ke backend API dan return UserModel
  Future<UserModel?> login(String identifier, String password) async {
    await initBaseUrl();
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'identifier': identifier, 'password': password}),
          )
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _token = data['accessToken'];
        final prefs = await SharedPreferences.getInstance();
        if (_token != null) {
          await prefs.setString('jwt_token', _token!);
        }

        final u = data['user'] ?? {};
        final profile = u['profile'] ?? {};
        final roleStr = u['role']?.toString().toUpperCase() ?? 'SISWA';

        String mappedRole = 'Siswa';
        if (roleStr == 'ADMIN') mappedRole = 'Admin';
        if (roleStr == 'SAPRAS') mappedRole = 'Sapras';
        if (roleStr == 'GURU') mappedRole = 'Guru';

        String subInfo = profile['className'] ?? profile['subject'] ?? 'SMK Muhammadiyah Kramat';
        if (mappedRole == 'Admin') subInfo = 'Administrator Sistem';
        if (mappedRole == 'Sapras') subInfo = 'Pengelola Aset & Alat';

        final name = u['name'] ?? 'Pengguna Muhamka';
        final initials = name.split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join('').toUpperCase();

        return UserModel(
          id: u['id'] ?? 'usr-api',
          name: name,
          identifier: identifier,
          role: mappedRole,
          subInfo: subInfo,
          initials: initials.isEmpty ? 'MK' : initials,
          password: password,
          hasFaceRegistered: data['hasFaceProfile'] ?? true,
        );
      }
    } catch (e) {
      debugPrint('Backend login error: $e. Fallback ke DummyData');
    }

    // Fallback ke dummy data jika backend tidak terjangkau atau gagal
    return DummyData.authenticate(identifier, password);
  }

  /// Logout dari backend dan hapus token lokal
  Future<void> logout() async {
    try {
      if (_token != null) {
        final url = Uri.parse('$baseUrl/auth/logout');
        await http.post(url, headers: _headers).timeout(const Duration(seconds: 3));
      }
    } catch (_) {}
    _token = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
    } catch (_) {}
  }

  /// Ambil data katalog barang dari backend (GET /inventory-units)
  Future<List<CatalogItem>> fetchCatalogItems() async {
    try {
      final url = Uri.parse('$baseUrl/inventory-units?limit=100');
      final res = await http.get(url, headers: _headers).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List items = decoded['data'] ?? [];

        if (items.isNotEmpty) {
          final Map<String, List<dynamic>> grouped = {};
          for (final u in items) {
            final typeId = u['itemTypeId'] ?? u['itemType']?['id'] ?? 'unknown';
            grouped.putIfAbsent(typeId, () => []).add(u);
          }

          final List<CatalogItem> list = [];
          grouped.forEach((typeId, unitList) {
            final first = unitList.first;
            final itemType = first['itemType'] ?? {};
            final location = first['location'] ?? {};

            final total = unitList.length;
            final tersedia = unitList.where((u) => u['availabilityStatus'] == 'AVAILABLE').length;

            list.add(
              CatalogItem(
                id: typeId,
                name: itemType['name'] ?? 'Barang',
                category: itemType['category']?['name'] ?? 'Umum',
                description: itemType['description'] ?? 'Peralatan praktik sekolah',
                type: itemType['itemClass'] == 'CONSUMABLE' ? ItemType.consumable : ItemType.unit,
                availableStock: tersedia,
                totalStock: total,
                unit: itemType['unitName'] ?? 'Unit',
                location: location['name'] ?? 'Gudang Sarpras',
                iconEmoji: _tebakEmoji(itemType['name'] ?? ''),
              ),
            );
          });

          // Lengkapi dengan dummy data bila barang di DB masih sedikit
          for (final d in DummyData.catalogItems) {
            if (!list.any((b) => b.name.toLowerCase() == d.name.toLowerCase())) {
              list.add(d);
            }
          }
          return list;
        }
      }
    } catch (e) {
      debugPrint('Error fetchCatalogItems: $e');
    }
    return List.from(DummyData.catalogItems);
  }

  String _tebakEmoji(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('kamera') || lower.contains('canon')) return '📷';
    if (lower.contains('proyektor')) return '📽️';
    if (lower.contains('tripod')) return '📐';
    if (lower.contains('kursi')) return '🪑';
    if (lower.contains('meja')) return '🛋️';
    if (lower.contains('laptop') || lower.contains('komputer')) return '💻';
    if (lower.contains('kabel') || lower.contains('lan')) return '🔌';
    return '📦';
  }
}
