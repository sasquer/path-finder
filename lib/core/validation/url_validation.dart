enum UrlValidationError { empty, invalidFormat, unsupportedScheme, invalidHost }

sealed class UrlValidationResult {
  const UrlValidationResult();
}

final class ValidUrl extends UrlValidationResult {
  const ValidUrl(this.uri);

  final Uri uri;
}

final class InvalidUrl extends UrlValidationResult {
  const InvalidUrl(this.error);

  final UrlValidationError error;
}

class UrlValidator {
  const UrlValidator();

  static const _allowedSchemes = {'http', 'https'};
  static const _localhost = 'localhost';

  static final _whitespace = RegExp(r'\s');

  static final _domain = RegExp(
    r'^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+'
    r'[a-z](?:[a-z0-9-]{0,61}[a-z0-9])?$',
    caseSensitive: false,
  );

  static final _ipv4 = RegExp(
    r'^(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}'
    r'(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$',
  );

  UrlValidationResult validate(String input) {
    final value = input.trim();
    if (value.isEmpty) {
      return const InvalidUrl(UrlValidationError.empty);
    }
    if (value.contains(_whitespace)) {
      return const InvalidUrl(UrlValidationError.invalidFormat);
    }

    final uri = Uri.tryParse(value);
    if (uri == null) {
      return const InvalidUrl(UrlValidationError.invalidFormat);
    }
    if (!_allowedSchemes.contains(uri.scheme)) {
      return const InvalidUrl(UrlValidationError.unsupportedScheme);
    }
    if (!_isValidHost(uri.host)) {
      return const InvalidUrl(UrlValidationError.invalidHost);
    }
    return ValidUrl(uri);
  }

  bool _isValidHost(String host) =>
      host == _localhost || _ipv4.hasMatch(host) || _domain.hasMatch(host);
}
