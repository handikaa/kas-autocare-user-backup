import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';

import '../../data/datasource/local/auth_local_data_source.dart';

class ShareMethod {
  static Future<Position?> getCurrentUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      // iOS precise
      if (Platform.isIOS) {
        try {
          await Geolocator.requestTemporaryFullAccuracy(
            purposeKey: 'PickupPreciseLocation',
          );
        } catch (_) {}
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      return null;
    }
  }

  static int? parseToInt(dynamic value) {
    if (value == null) return null;

    // Jika numeric string seperti "1000.00"
    if (value is String) {
      double? d = double.tryParse(value.trim());
      if (d != null) return d.toInt();
      return null;
    }

    // Jika tipe double
    if (value is double) {
      return value.toInt();
    }

    // Jika tipe int langsung return
    if (value is int) {
      return value;
    }

    // Jika tipe lain: null
    return null;
  }

  static Color getHistoryIconColor(String type) {
    switch (type) {
      case "package":
        return AppColors.common.appblue;

      case "package_variant":
        return AppColors.common.appblue;

      case "service":
        return AppColors.common.appblue;

      case "product":
        return AppColors.common.appTeal;

      case "membership":
        return AppColors.common.appOrange;

      default:
        return AppColors.common.grey400;
    }
  }

  static IconData getHistoryIcon(String type) {
    switch (type) {
      case "package":
        return Icons.local_car_wash;

      case "package_variant":
        return Icons.local_car_wash;

      case "service":
        return Icons.local_car_wash;

      case "product":
        return Icons.shopping_bag;

      default:
        return Icons.question_mark_outlined;
    }
  }

  static String getTitle(String type) {
    switch (type) {
      case "package":
        return "Layanan Cuci";

      case "package_variant":
        return "Layanan Cuci";

      case "service":
        return "Layanan Cuci";

      case "product":
        return "Produk";

      default:
        return "History";
    }
  }

  static Color getTextColor(String type) {
    switch (type) {
      case "process_payment":
        return AppColors.common.appblue;

      case "payment_success":
        return AppColors.common.appblue;

      case "cancelled":
        return AppColors.light.error;

      case "expired":
        return AppColors.light.error;

      case "rejected":
        return AppColors.light.error;

      case "in_progress":
        return AppColors.common.lightOrange;

      case "pending":
        return AppColors.common.lightOrange;

      case "completed":
        return AppColors.light.success40;

      case "accepted":
        return AppColors.light.success40;

      default:
        return AppColors.common.grey400;
    }
  }

  static String getStatus(String type) {
    switch (type) {
      case "process_payment":
        return "Pembayaran";

      case "payment_success":
        return "Pembayaran Berhasil";

      case "cancelled":
        return "Gagal";

      case "in_progress":
        return "Sedang di Proses";

      case "completed":
        return "Selesai";

      case "accepted":
        return "Menunggu Kedatangan";

      case "rejected":
        return "Ditolak";

      case "pending":
        return "Pending";

      case "expired":
        return "Kadaluwarsa";

      default:
        return "Tidak diketahui";
    }
  }

  static String getStatusDetail(String type) {
    switch (type) {
      case "process_payment":
        return "Menunggu Pembayaran";

      case "payment_success":
        return "Pembayaran Berhasil";

      case "in_progress":
        return "Kendaraan Anda\nSedang di Proses Cuci";

      case "accepted":
        return "Menunggu Kedatangan ke Carwash";

      case "rejected":
        return "Booking di tolak";

      case "canceled":
        return "Transaksi Dibatalkan";

      case "completed":
        return "Selesai";

      case "pending":
        return "Pending";

      case "expired":
        return "Transaksi Kadaluwarsa";

      default:
        return "Tidak diketahui";
    }
  }

  static String getStatusVehicleType(String type) {
    switch (type) {
      case "motorcycle":
        return "Motor";

      case "car":
        return "Mobil";

      default:
        return "Tidak diketahui";
    }
  }

  static String getSubTitle(String type) {
    switch (type) {
      case "package_variant":
        return "Pembayaran Layanan Cuci";

      case "package":
        return "Pembayaran Layanan Cuci";

      case "service":
        return "Pembayaran Layanan Cuci";

      case "product":
        return "Pembelian Produk Belanja";

      default:
        return "History";
    }
  }

  static void doLogout(BuildContext context) async {
    final authLocal = AuthLocalDataSource();

    await authLocal.clearAuth();

    context.go('/login');
  }
}

class NoInvalidPasteFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final onlyDigits = RegExp(r'^[0-9]*$');

    if (!onlyDigits.hasMatch(newValue.text)) {
      return oldValue;
    }

    return newValue;
  }
}

class DateTimeFormatter {
  /// Convert UTC DateTime → WIB (GMT+7)
  static DateTime toWIB(DateTime date) {
    return date.toUtc().add(const Duration(hours: 7));
  }

  /// Format jam saja (24h / 12h)
  static String formatTime(DateTime date, {bool use24Hour = true}) {
    final wib = toWIB(date);

    if (use24Hour) {
      // 24 jam
      return "${_twoDigits(wib.hour)}:${_twoDigits(wib.minute)}";
    } else {
      // 12 jam dengan AM/PM
      final hour = wib.hour % 12 == 0 ? 12 : wib.hour % 12;
      final period = wib.hour >= 12 ? "PM" : "AM";
      return "$hour:${_twoDigits(wib.minute)} $period";
    }
  }

  /// Format tanggal + jam (pilih bentuk bulan angka atau teks)
  static String formatDateTime(
    DateTime date, {
    bool use24Hour = true,
    bool monthInText = true, // true = Nov, Dec / false = angka
  }) {
    final wib = date;

    final day = wib.day;
    final month = monthInText
        ? _monthShort[wib.month]!
        : _twoDigits(wib.month); // 01-12 or Jan-Dec
    final year = wib.year;

    final time = formatTime(wib, use24Hour: use24Hour);

    return "$day $month $year, $time";
  }

  static DateTime addOneDayDateTime(DateTime date) {
    final wib = toWIB(date);
    return wib.add(const Duration(days: 1));
  }

  static String addOneDayFormatted(DateTime date, {bool monthInText = false}) {
    final nextDay = addOneDayDateTime(date);

    final day = _twoDigits(nextDay.day);
    final month = monthInText
        ? _monthShort[nextDay.month]!
        : _twoDigits(nextDay.month);
    final year = nextDay.year;

    return "$year-$month-$day";
  }

  static String formatDateOnly(
    DateTime date, {
    bool monthInText = true, // true = Jan, Feb ... / false = 01, 02 ...
  }) {
    final wib = toWIB(date);

    final day = _twoDigits(wib.day);
    final month = monthInText ? _monthShort[wib.month]! : _twoDigits(wib.month);
    final year = wib.year;

    return monthInText
        ? "$day $month $year" // contoh: 01 Des 2025
        : "$day/$month/$year"; // contoh: 01/12/2025
  }

  static String formatDateForParams(DateTime date) {
    final wib = toWIB(date);

    final year = wib.year;
    final month = _twoDigits(wib.month); // → 01, 02, ..., 12
    final day = _twoDigits(wib.day); // → 01, 02, ..., 31

    return "$year-$month-$day"; // → yyyy-MM-dd
  }

  /// Helper untuk leading zero
  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  /// Daftar bulan singkat
  static const Map<int, String> _monthShort = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "Mei",
    6: "Jun",
    7: "Jul",
    8: "Agu",
    9: "Sep",
    10: "Okt",
    11: "Nov",
    12: "Des",
  };
}
