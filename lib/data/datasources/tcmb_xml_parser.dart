import 'package:xml/xml.dart';
import '../../core/network/api_exceptions.dart';
import '../models/currency_model.dart';

class TcmbXmlParser {
  List<CurrencyModel> parse(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);
      final currencies = <CurrencyModel>[];

      final currencyElements = document.findAllElements('Currency');

      for (final element in currencyElements) {
        final model = _parseCurrencyElement(element);
        if (model != null) {
          currencies.add(model);
        }
      }

      currencies.sort((a, b) => a.crossOrder.compareTo(b.crossOrder));

      return currencies;
    } catch (e) {
      throw ParseException(message: 'XML parse hatası', originalError: e);
    }
  }

  CurrencyModel? _parseCurrencyElement(XmlElement element) {
    try {
      final code =
          element.getAttribute('Kod') ?? element.getAttribute('CurrencyCode');

      if (code == null || code.isEmpty) return null;

      final forexBuyingStr = _getElementText(element, 'ForexBuying');
      final forexSellingStr = _getElementText(element, 'ForexSelling');

      if (forexBuyingStr == null || forexSellingStr == null) return null;

      final forexBuying = double.tryParse(forexBuyingStr);
      final forexSelling = double.tryParse(forexSellingStr);

      if (forexBuying == null || forexSelling == null) return null;

      return CurrencyModel(
        code: code,
        name: _getElementText(element, 'Isim') ?? code,
        nameEnglish: _getElementText(element, 'CurrencyName') ?? code,
        unit: int.tryParse(_getElementText(element, 'Unit') ?? '1') ?? 1,
        forexBuying: forexBuying,
        forexSelling: forexSelling,
        banknoteBuying: _parseOptionalDouble(element, 'BanknoteBuying'),
        banknoteSelling: _parseOptionalDouble(element, 'BanknoteSelling'),
        crossRateUsd: _parseOptionalDouble(element, 'CrossRateUSD'),
        crossRateOther: _parseOptionalDouble(element, 'CrossRateOther'),
        crossOrder:
            int.tryParse(element.getAttribute('CrossOrder') ?? '99') ?? 99,
      );
    } catch (_) {
      return null;
    }
  }

  String? _getElementText(XmlElement parent, String name) {
    final elements = parent.findElements(name);
    if (elements.isEmpty) return null;
    final text = elements.first.innerText.trim();
    return text.isEmpty ? null : text;
  }

  double? _parseOptionalDouble(XmlElement parent, String name) {
    final text = _getElementText(parent, name);
    if (text == null) return null;
    return double.tryParse(text);
  }
}
