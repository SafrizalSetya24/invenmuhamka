# inventarisMuhamka

Sistem Inventaris dan Peminjaman Barang Sekolah — **Flutter Web & Mobile** (satu codebase) untuk **Student, Teacher, Sapras, dan Admin**.

| | |
|---|---|
| Platform | Flutter — satu codebase untuk Web dan Mobile |
| Lingkup | Satu sekolah (tanpa konsep multi-tenant / `school_id`) |
| Jenis barang | Barang Per Unit + Barang Habis Pakai |
| Verifikasi | Face Registration setelah login; Face Verification sebelum submit request |

---

## Struktur Folder

Seluruh halaman berada di `lib/pages/`, dipisah per role.

### Student / Teacher — `lib/pages/`

```
lib/pages/
├── auth/
│   └── login_page.dart
│
├── face/
│   └── face_registration_page.dart
│
├── home/
│   └── home_page.dart
│
├── catalog/
│   ├── item_category_page.dart
│   └── item_detail_page.dart
│
├── cart/
│   └── cart_page.dart
│
├── borrowing/
│   ├── borrowing_detail_page.dart
│   ├── face_verification_page.dart
│   └── borrowing_success_page.dart
│
├── history/
│   ├── borrowing_history_page.dart
│   └── borrowing_detail_history_page.dart
│
├── notification/
│   └── notification_page.dart
│
└── profile/
    └── profile_page.dart
```

### Sapras — `lib/pages/sapras/`

```
lib/pages/sapras/
├── dashboard/
│   └── dashboard_page.dart
│
├── borrowing/
│   ├── borrowing_list_page.dart
│   ├── borrowing_detail_page.dart
│   └── approval_page.dart
│
├── handover/
│   ├── handover_page.dart
│   ├── barcode_scanner_page.dart
│   └── manual_unit_selection_page.dart
│
├── inventory/
│   ├── inventory_list_page.dart
│   ├── inventory_detail_page.dart
│   └── inventory_form_page.dart
│
├── consumables/
│   ├── consumable_list_page.dart
│   └── stock_page.dart
│
├── repair/
│   ├── repair_list_page.dart
│   └── repair_detail_page.dart
│
├── return/
│   ├── return_list_page.dart
│   └── return_inspection_page.dart
│
├── feedback/
│   ├── feedback_list_page.dart
│   └── feedback_detail_page.dart
│
└── notifications/
    └── notification_page.dart
```

### Admin — `lib/pages/admin/`

```
lib/pages/admin/
├── dashboard/
│   └── dashboard_page.dart
│
├── users/
│   ├── user_list_page.dart
│   ├── student_form_page.dart
│   └── teacher_form_page.dart
│
├── roles/
│   └── role_page.dart
│
├── categories/
│   └── category_page.dart
│
├── item_types/
│   └── item_type_page.dart
│
├── locations/
│   └── location_page.dart
│
└── audit_logs/
    └── audit_log_page.dart
```

---

## Hak Akses per Role

| Student | Teacher | Sapras | Admin |
|---|---|---|---|
| Login NIS | Login NUPTK | Approval / Reject | Kelola User |
| Face Registration | Face Registration | Handover | Kelola Role |
| Katalog & Cart | Katalog & Cart | Inventaris | Kategori Barang |
| Ajukan Peminjaman | Ajukan Peminjaman | Pengembalian | Jenis/Model Barang |
| Status & Riwayat | Status & Riwayat | Perbaikan | Lokasi |
| Notifikasi & Profil | Notifikasi & Profil | Stok Habis Pakai | Audit Log |
| Kritik & Saran | Kritik & Saran | Kelola Kritik & Saran | - |

---

## Alur Singkat Peminjaman

```
Login → (Face Registration jika belum ada) → Home → Pinjam Barang
→ Pilih Barang → Cart → Detail Peminjaman → Cek Ketersediaan
→ Review → Face Verification → WAITING_APPROVAL (maks. 2 jam)
→ Sapras: APPROVED / REJECTED / EXPIRED
→ Handover (scan barcode / manual / input jumlah) → Sedang Dipinjam
→ Return per unit + Inspection → AVAILABLE / REPAIR → COMPLETED
```

### Status Request

`WAITING_APPROVAL` → `APPROVED` → `HANDED_OVER` → `COMPLETED`
Cabang lain: `REJECTED`, `EXPIRED` (tidak dikonfirmasi dalam 2 jam; booking dilepas).

### Kondisi vs Status Ketersediaan (dipisahkan)

- **Condition:** `LAYAK_PAKAI`, `PERLU_DIPERBAIKI`, `RUSAK_TOTAL`
- **Availability Status:** `AVAILABLE`, `BOOKED`, `BORROWED`, `REPAIR`, `UNAVAILABLE`

---

## Prinsip Penting Frontend

1. Tidak ada Register akun untuk Student/Teacher — akun dibuat oleh Admin.
2. Login memakai NIS (Student) / NUPTK (Teacher) + password.
3. Face Registration ≠ Register akun; dilakukan setelah login jika belum punya Face Profile.
4. Face Verification dilakukan sekali per request, sebelum dikirim ke Sapras.
5. Satu cart = satu Borrow Request; boleh berisi barang per unit dan habis pakai sekaligus.
6. User memilih jenis/model dan jumlah, **bukan** barcode fisik. Unit fisik ditentukan Sapras saat handover.
7. Barcode hanya dipakai Sapras; manual selection menjadi fallback.
8. Status unit/stok berubah hanya setelah **Konfirmasi Penyerahan** (bukan saat scan/pilih, bukan saat request dibuat).
9. Barang per unit wajib dikembalikan; barang habis pakai tidak.
10. Batas approval 2 jam bukan durasi peminjaman.
11. Student/Teacher tidak melihat barcode, kondisi, repair, atau unit fisik — itu informasi internal Sapras/Admin.
12. Frontend responsive (Web & Mobile); backend tetap sumber kebenaran untuk validasi stok, booking, approval, dan handover.
