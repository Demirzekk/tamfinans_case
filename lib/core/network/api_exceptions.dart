sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'İnternet bağlantısı kontrol ediniz',
    super.originalError,
  });
}

class ServerException extends ApiException {
  const ServerException({
    super.message = 'Sunucu hatası oluştu',
    super.statusCode,
    super.originalError,
  });
}

class ClientException extends ApiException {
  const ClientException({
    super.message = 'İstek hatası',
    super.statusCode,
    super.originalError,
  });
}

class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'Bu tarih için veri bulunamadı',
    super.statusCode = 404,
  });
}

class ParseException extends ApiException {
  const ParseException({
    super.message = 'Veri işlenirken hata oluştu',
    super.originalError,
  });
}

/// Zaman aşımı hatası
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Bağlantı zaman aşımına uğradı',
    super.originalError,
  });
}
