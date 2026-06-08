import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String rupiah(num amount) {
    return _rupiah.format(amount);
  }

  static String compact(num amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)} Jt';
    }

    if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)} Rb';
    }

    return 'Rp ${amount.toInt()}';
  }
}