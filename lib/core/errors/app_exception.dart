import 'package:equatable/equatable.dart';

sealed class AppException extends Equatable implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}

final class NetworkException extends AppException {
  const NetworkException([super.message]);
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException();
}

final class ServerException extends AppException {
  const ServerException(this.statusCode, [super.message]);

  final int statusCode;

  @override
  List<Object?> get props => [statusCode, message];
}

final class InvalidResponseException extends AppException {
  const InvalidResponseException([super.message]);
}

final class UnsupportedFieldSizeException extends AppException {
  const UnsupportedFieldSizeException({
    required this.taskId,
    required this.width,
    required this.height,
  });

  final String taskId;
  final int width;
  final int height;

  @override
  List<Object?> get props => [taskId, width, height];
}

final class ApiErrorException extends AppException {
  const ApiErrorException(String super.message);
}

final class StorageException extends AppException {
  const StorageException([super.message]);
}

final class MissingApiUrlException extends AppException {
  const MissingApiUrlException();
}
