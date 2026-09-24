import 'package:path_finder/core/errors/app_exception.dart';

class ApiResponseDto {
  const ApiResponseDto({required this.error, required this.message, required this.data});

  factory ApiResponseDto.fromJson(Object? json) {
    if (json case {'error': final bool error}) {
      return ApiResponseDto(
        error: error,
        message: json['message'] is String ? json['message'] as String : '',
        data: json['data'],
      );
    }
    throw const InvalidResponseException('Response has no "error" flag');
  }

  final bool error;
  final String message;
  final Object? data;

  Object? requireData() {
    if (error) throw ApiErrorException(message);
    return data;
  }

  static void throwIfError(Object? json) {
    if (json case {'error': true}) ApiResponseDto.fromJson(json).requireData();
  }
}
