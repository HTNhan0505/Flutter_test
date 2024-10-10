import 'package:intl/intl.dart';

class CurrencyUtil {
  static CurrencyUtil? _instance;

  CurrencyUtil._();

  factory CurrencyUtil() => _instance ??= CurrencyUtil._();

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ', decimalDigits: 0);
    return formatter.format(amount).replaceAll(',', '.');
  }

}