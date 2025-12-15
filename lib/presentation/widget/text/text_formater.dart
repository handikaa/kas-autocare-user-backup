import 'package:intl/intl.dart';

class TextFormatter {
  static final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static String formatRupiah(int value) {
    return _currencyFormatter.format(value);
  }

  static String formatRupiahDouble(double value) {
    return _currencyFormatter.format(value);
  }

  static String formatNumber(int value) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(value);
  }

  static final _percentFormatter = NumberFormat("0.###", "id_ID");

  static String formatPercentage(double value) {
    return "${_percentFormatter.format(value)}%";
  }
}
