import '../../core/network/api_client.dart';
import '../models/currency_model.dart';
import 'tcmb_xml_parser.dart';

class TcmbRemoteDatasource {
  final ApiClient _apiClient;
  final TcmbXmlParser _parser;

  TcmbRemoteDatasource({required ApiClient apiClient, TcmbXmlParser? parser})
    : _apiClient = apiClient,
      _parser = parser ?? TcmbXmlParser();

  Future<List<CurrencyModel>> getExchangeRates(DateTime date) async {
    final xmlString = await _apiClient.getExchangeRates(date);
    return _parser.parse(xmlString);
  }
}
