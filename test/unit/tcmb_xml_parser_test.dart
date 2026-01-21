import 'package:flutter_test/flutter_test.dart';
import 'package:tamfinans_case/data/datasources/tcmb_xml_parser.dart';

void main() {
  group('TcmbXmlParser', () {
    late TcmbXmlParser parser;

    setUp(() {
      parser = TcmbXmlParser();
    });

    test('should parse valid TCMB XML correctly', () {
      const xmlString = '''
<?xml version="1.0" encoding="UTF-8"?>
<Tarih_Date Tarih="17.01.2025" Date="01/17/2025">
  <Currency CrossOrder="0" Kod="USD" CurrencyCode="USD">
    <Unit>1</Unit>
    <Isim>ABD DOLARI</Isim>
    <CurrencyName>US DOLLAR</CurrencyName>
    <ForexBuying>35.4119</ForexBuying>
    <ForexSelling>35.4757</ForexSelling>
    <BanknoteBuying>35.3500</BanknoteBuying>
    <BanknoteSelling>35.5500</BanknoteSelling>
    <CrossRateUSD/>
    <CrossRateOther/>
  </Currency>
  <Currency CrossOrder="1" Kod="EUR" CurrencyCode="EUR">
    <Unit>1</Unit>
    <Isim>EURO</Isim>
    <CurrencyName>EURO</CurrencyName>
    <ForexBuying>36.4321</ForexBuying>
    <ForexSelling>36.5000</ForexSelling>
    <BanknoteBuying>36.3000</BanknoteBuying>
    <BanknoteSelling>36.6000</BanknoteSelling>
    <CrossRateUSD>1.0288</CrossRateUSD>
    <CrossRateOther/>
  </Currency>
</Tarih_Date>
      ''';

      final result = parser.parse(xmlString);

      expect(result, isNotEmpty);
      expect(result.length, 2);

      // USD kontrolü
      final usd = result.firstWhere((c) => c.code == 'USD');
      expect(usd.name, 'ABD DOLARI');
      expect(usd.unit, 1);
      expect(usd.forexBuying, 35.4119);
      expect(usd.forexSelling, 35.4757);

      // EUR kontrolü
      final eur = result.firstWhere((c) => c.code == 'EUR');
      expect(eur.name, 'EURO');
      expect(eur.forexBuying, 36.4321);
    });

    test('should handle empty XML gracefully', () {
      const emptyXml =
          '<?xml version="1.0" encoding="UTF-8"?><Tarih_Date></Tarih_Date>';

      final result = parser.parse(emptyXml);

      expect(result, isEmpty);
    });

    test('should handle currencies with missing forex values', () {
      const xmlWithMissingValues = '''
<?xml version="1.0" encoding="UTF-8"?>
<Tarih_Date>
  <Currency Kod="XDR" CurrencyCode="XDR">
    <Unit>1</Unit>
    <Isim>ÖZEL ÇEKME HAKKI (SDR)</Isim>
    <CurrencyName>SPECIAL DRAWING RIGHT (SDR)</CurrencyName>
    <ForexBuying></ForexBuying>
    <ForexSelling></ForexSelling>
    <BanknoteBuying/>
    <BanknoteSelling/>
  </Currency>
</Tarih_Date>
      ''';

      final result = parser.parse(xmlWithMissingValues);

      // Boş forex değerleri olan para birimleri atlanmalı veya 0 olmalı
      expect(result.isEmpty || result.first.forexBuying == 0, isTrue);
    });

    test('should parse currencies with unit > 1 (like JPY)', () {
      const jpyXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<Tarih_Date>
  <Currency Kod="JPY" CurrencyCode="JPY">
    <Unit>100</Unit>
    <Isim>JAPON YENİ</Isim>
    <CurrencyName>JAPENESE YEN</CurrencyName>
    <ForexBuying>22.5432</ForexBuying>
    <ForexSelling>22.6543</ForexSelling>
    <BanknoteBuying>22.4000</BanknoteBuying>
    <BanknoteSelling>22.8000</BanknoteSelling>
  </Currency>
</Tarih_Date>
      ''';

      final result = parser.parse(jpyXml);

      expect(result, isNotEmpty);
      expect(result.first.code, 'JPY');
      expect(result.first.unit, 100);
    });
  });
}
