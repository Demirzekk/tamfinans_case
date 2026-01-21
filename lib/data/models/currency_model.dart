import '../../domain/entities/currency.dart';

class CurrencyModel {
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
  final int crossOrder;

  const CurrencyModel({
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
    this.crossOrder = 0,
  });

  Currency toEntity() {
    return Currency(
      code: code,
      name: name,
      nameEnglish: nameEnglish,
      unit: unit,
      forexBuying: forexBuying,
      forexSelling: forexSelling,
      banknoteBuying: banknoteBuying,
      banknoteSelling: banknoteSelling,
      crossRateUsd: crossRateUsd,
      crossRateOther: crossRateOther,
    );
  }

  @override
  String toString() => 'CurrencyModel($code: $forexBuying / $forexSelling)';
}
