import 'package:flutter/foundation.dart';

@immutable
class Currency {
  final String? code;
  final String? name;
  final String? nameEnglish;
  final int? unit;
  final double? forexBuying;
  final double? forexSelling;
  final double? banknoteBuying;
  final double? banknoteSelling;
  final double? crossRateUsd;
  final double? crossRateOther;

  const Currency({
    required this.code,
    required this.name,
    required this.nameEnglish,
    required this.unit,
    required this.forexBuying,
    required this.forexSelling,
    this.banknoteBuying,
    this.banknoteSelling,
    this.crossRateUsd,
    this.crossRateOther,
  });

  double convertFromTl(double tlAmount) {
    if ((forexSelling ?? 0) <= 0) return 0;
    return tlAmount / ((forexSelling ?? 0) / (unit ?? 1));
  }

  double convertToTl(double amount) {
    return amount * ((forexBuying ?? 0) / (unit ?? 1));
  }

  String get icon {
    switch (code) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CHF':
        return '₣';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      default:
        return code?.substring(0, 1) ?? '';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Currency($code: $forexBuying / $forexSelling)';
}
