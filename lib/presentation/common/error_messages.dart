import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/core/validation/url_validation.dart';
import 'package:path_finder/domain/entities/grid_field.dart';

extension UrlValidationErrorMessage on UrlValidationError {
  String get userMessage => switch (this) {
    UrlValidationError.empty => 'Please enter the API URL',
    UrlValidationError.invalidFormat => 'The URL has an invalid format',
    UrlValidationError.unsupportedScheme => 'The URL must start with http:// or https://',
    UrlValidationError.invalidHost => 'The URL must contain a valid host, e.g. example.com',
  };
}

extension AppExceptionMessage on AppException {
  String get userMessage => switch (this) {
    NetworkException() => 'Network error. Check your internet connection and the URL',
    RequestTimeoutException() => 'The server took too long to respond',
    ServerException(:final statusCode, :final message) =>
      message == null ? 'Server error ($statusCode)' : 'Server error ($statusCode): $message',
    InvalidResponseException() => 'Unexpected response from the server',
    UnsupportedFieldSizeException(:final width, :final height) =>
    'A task has an unsupported field size ${width}x$height. '
        'Allowed sizes are from ${GridField.minSize}x${GridField.minSize} '
        'to ${GridField.maxSize}x${GridField.maxSize}',
    ApiErrorException(:final message) =>
      message == null || message.isEmpty ? 'The server returned an error' : message,
    StorageException() => 'Failed to save the URL on the device',
  };
}
