// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Financely';

  @override
  String get navDashboard => 'Dasbor';

  @override
  String get navTransactions => 'Transaksi';

  @override
  String get navAccounts => 'Akun';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get addExpense => 'Tambah Transaksi';

  @override
  String get filterAllTime => 'Semua waktu';

  @override
  String get filterThisMonth => 'Bulan ini';

  @override
  String get filterLast30Days => '30 hari terakhir';

  @override
  String get filterClear => 'Hapus filter';

  @override
  String get filterNoResults => 'Tidak ada transaksi pada rentang ini';

  @override
  String get filterDateRange => 'Rentang tanggal';

  @override
  String get balanceTotalBalance => 'Total Saldo';

  @override
  String get balanceIncome => 'Pemasukan';

  @override
  String get balanceSpent => 'Pengeluaran';

  @override
  String get hideBalance => 'Sembunyikan saldo';

  @override
  String get showBalance => 'Tampilkan saldo';

  @override
  String get budgetMonthlyBudget => 'Anggaran Bulanan';

  @override
  String budgetSpent(String amount) {
    return '$amount terpakai';
  }

  @override
  String budgetOver(String amount) {
    return '$amount melebihi';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount tersisa';
  }

  @override
  String get topCategories => 'Kategori Teratas';

  @override
  String get thisMonth => 'Bulan ini';

  @override
  String get noSpendingThisMonth => 'Belum ada pengeluaran bulan ini';

  @override
  String get spendingTrend => 'Tren Pengeluaran';

  @override
  String lastMonths(int count) {
    return '$count bulan terakhir';
  }

  @override
  String get recentActivity => 'Aktivitas Terbaru';

  @override
  String get seeAll => 'Lihat semua';

  @override
  String get noActivityYet => 'Belum ada aktivitas';

  @override
  String get noTransactionsYet => 'Belum ada transaksi';

  @override
  String get tapToLogFirst => 'Ketuk + untuk mencatat yang pertama';

  @override
  String get editTransaction => 'Ubah Transaksi';

  @override
  String get addTransaction => 'Tambah Transaksi';

  @override
  String get delete => 'Hapus';

  @override
  String get description => 'Deskripsi';

  @override
  String get descriptionHint => 'mis. Belanja bulanan';

  @override
  String get enterDescription => 'Masukkan deskripsi';

  @override
  String get category => 'Kategori';

  @override
  String get customCategoryName => 'Nama kategori khusus';

  @override
  String get customCategoryHint => 'mis. Usaha sampingan';

  @override
  String get date => 'Tanggal';

  @override
  String get paymentMethod => 'Metode pembayaran';

  @override
  String get fromAccount => 'Dari akun';

  @override
  String get account => 'Akun';

  @override
  String get toAccount => 'Ke akun';

  @override
  String get noteOptional => 'Catatan (opsional)';

  @override
  String get noAccountsAddFromTab =>
      'Belum ada akun — tambahkan dari tab Akun.';

  @override
  String get createAccountFirst =>
      'Buat akun terlebih dahulu, lalu tambahkan transaksi';

  @override
  String get addSecondAccountTransfer =>
      'Tambahkan akun kedua untuk melakukan transfer';

  @override
  String get chooseTwoDifferentAccounts =>
      'Pilih dua akun berbeda untuk transfer';

  @override
  String get deleteTransactionQuestion => 'Hapus transaksi?';

  @override
  String willBeRemovedPermanently(String title) {
    return '\"$title\" akan dihapus permanen.';
  }

  @override
  String get cancel => 'Batal';

  @override
  String get undo => 'Urungkan';

  @override
  String get transactionDeleted => 'Transaksi dihapus';

  @override
  String get enterAmount => 'Masukkan jumlah';

  @override
  String get enterValidAmount => 'Masukkan jumlah yang valid';

  @override
  String typeUpdated(String type) {
    return '$type diperbarui';
  }

  @override
  String typeAdded(String type) {
    return '$type ditambahkan';
  }

  @override
  String get saveChanges => 'Simpan perubahan';

  @override
  String get saveTransaction => 'Simpan transaksi';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get saveChangesQuestion => 'Simpan perubahan?';

  @override
  String get addAccountQuestion => 'Tambah akun?';

  @override
  String addAccountConfirm(String name) {
    return 'Tambahkan \"$name\" ke akun Anda?';
  }

  @override
  String saveAccountConfirm(String name) {
    return 'Simpan perubahan pada \"$name\"?';
  }

  @override
  String get addTransactionQuestion => 'Tambah transaksi?';

  @override
  String get addTransactionConfirm => 'Tambahkan transaksi ini?';

  @override
  String get saveTransactionConfirm => 'Simpan perubahan pada transaksi ini?';

  @override
  String get editAccount => 'Ubah Akun';

  @override
  String get newAccountTitle => 'Akun Baru';

  @override
  String get accountName => 'Nama akun';

  @override
  String get accountNameHint => 'mis. Tunai, BCA, Visa';

  @override
  String get enterName => 'Masukkan nama';

  @override
  String get openingBalance => 'Saldo awal';

  @override
  String get icon => 'Ikon';

  @override
  String get color => 'Warna';

  @override
  String get deleteAccountQuestion => 'Hapus akun?';

  @override
  String accountWillBeRemoved(String name) {
    return '\"$name\" akan dihapus. Transaksi yang ada tetap disimpan tetapi tidak lagi terkait dengan akun.';
  }

  @override
  String get accountUpdated => 'Akun diperbarui';

  @override
  String get accountAdded => 'Akun ditambahkan';

  @override
  String get accountDeleted => 'Akun dihapus';

  @override
  String get createAccount => 'Buat akun';

  @override
  String get totalAcrossAccounts => 'Total seluruh akun';

  @override
  String get newAccount => 'Akun baru';

  @override
  String get noAccountsYet => 'Belum ada akun';

  @override
  String get addOneToStart => 'Tambahkan satu untuk mulai melacak saldo';

  @override
  String opening(String amount) {
    return 'Saldo awal $amount';
  }

  @override
  String get appearance => 'Tampilan';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get dynamicColor => 'Warna dinamis';

  @override
  String get dynamicColorSubtitle => 'Gunakan warna dari wallpaper perangkat';

  @override
  String get font => 'Font';

  @override
  String get accentColor => 'Warna aksen';

  @override
  String get accentDynamicHint => 'Pilih warna untuk mematikan tema dinamis';

  @override
  String get accentPickHint => 'Pilih warna merek Material You Anda';

  @override
  String get budgetAndCurrency => 'Anggaran & Mata Uang';

  @override
  String get monthlyBudget => 'Anggaran bulanan';

  @override
  String get amount => 'Jumlah';

  @override
  String get save => 'Simpan';

  @override
  String get currency => 'Mata uang';

  @override
  String get language => 'Bahasa';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get security => 'Keamanan';

  @override
  String get appPasscode => 'Kode sandi aplikasi';

  @override
  String get appPasscodeSubtitle =>
      'Perlukan PIN 6 digit untuk membuka aplikasi';

  @override
  String get changePasscode => 'Ubah kode sandi';

  @override
  String get biometricUnlock => 'Buka dengan biometrik';

  @override
  String get biometricSubtitle => 'Gunakan sidik jari atau Face ID';

  @override
  String get removePasscodeQuestion => 'Hapus kode sandi?';

  @override
  String get removePasscodeContent =>
      'Aplikasi tidak akan terkunci lagi. Buka dengan biometrik juga dinonaktifkan.';

  @override
  String get remove => 'Hapus';

  @override
  String get couldNotEnableBiometric =>
      'Tidak dapat mengaktifkan buka dengan biometrik.';

  @override
  String get dataAndSync => 'Data & Sinkronisasi';

  @override
  String get exportToCsv => 'Ekspor ke CSV';

  @override
  String get exportSubtitle => 'Bagikan riwayat transaksi Anda';

  @override
  String get exportUnavailable => 'Ekspor tidak tersedia di perangkat ini';

  @override
  String get cloudSync => 'Sinkronisasi cloud';

  @override
  String get cloudSyncSubtitle => 'Cadangkan ke cloud (demo)';

  @override
  String get about => 'Tentang';

  @override
  String get version => 'Versi 1.0.0';

  @override
  String get enterPasscode => 'Masukkan kode sandi';

  @override
  String get unlockToContinue => 'Buka Financely untuk melanjutkan';

  @override
  String tooManyAttempts(String time) {
    return 'Terlalu banyak percobaan. Coba lagi dalam $time';
  }

  @override
  String get forgotPasscode => 'Lupa kode sandi?';

  @override
  String get forgotPasscodeContent =>
      'Kode sandi lokal tidak dapat dipulihkan. Untuk mendapatkan akses kembali, Financely akan menghapus kode sandi serta semua transaksi dan akun di perangkat ini. Tindakan ini tidak dapat dibatalkan.';

  @override
  String get eraseAndReset => 'Hapus & atur ulang';

  @override
  String get passcodeRemovedErased => 'Kode sandi dihapus dan data dihapus.';

  @override
  String get setPasscode => 'Atur kode sandi';

  @override
  String get confirmPasscode => 'Konfirmasi kode sandi';

  @override
  String get createPasscode => 'Buat kode sandi';

  @override
  String get chooseSixDigit => 'Pilih kode sandi 6 digit';

  @override
  String get reenterSixDigit => 'Masukkan ulang kode sandi 6 digit Anda';

  @override
  String get pinsDidNotMatch => 'PIN tidak cocok. Coba lagi.';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get typeExpense => 'Pengeluaran';

  @override
  String get typeIncome => 'Pemasukan';

  @override
  String get typeTransfer => 'Transfer';

  @override
  String get paymentCash => 'Tunai';

  @override
  String get paymentCard => 'Kartu';

  @override
  String get paymentBank => 'Bank';

  @override
  String get catFood => 'Makanan & Minuman';

  @override
  String get catGroceries => 'Kebutuhan Pokok';

  @override
  String get catTransport => 'Transportasi';

  @override
  String get catShopping => 'Belanja';

  @override
  String get catBills => 'Tagihan';

  @override
  String get catEntertainment => 'Hiburan';

  @override
  String get catHealth => 'Kesehatan';

  @override
  String get catHousing => 'Tempat Tinggal';

  @override
  String get catTravel => 'Perjalanan';

  @override
  String get catEducation => 'Pendidikan';

  @override
  String get catSalary => 'Gaji';

  @override
  String get catInvestment => 'Investasi';

  @override
  String get catGift => 'Hadiah';

  @override
  String get catOther => 'Lainnya';

  @override
  String get catTransfer => 'Transfer';
}
