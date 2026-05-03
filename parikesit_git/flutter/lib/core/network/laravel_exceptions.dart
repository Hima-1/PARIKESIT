class LaravelValidationException implements Exception {
  LaravelValidationException({required this.message, required this.errors});

  final String message;
  final Map<String, List<String>> errors;

  @override
  String toString() => 'LaravelValidationException: $message ($errors)';
}

class UnauthorizedException implements Exception {
  UnauthorizedException([this.message = 'Unauthorized']);

  final String message;

  @override
  String toString() => 'UnauthorizedException: $message';
}

class ForbiddenException implements Exception {
  ForbiddenException([this.message = 'Forbidden']);

  final String message;

  @override
  String toString() => 'ForbiddenException: $message';
}

class NotFoundException implements Exception {
  NotFoundException([this.message = 'Not Found']);

  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}

class InternalServerErrorException implements Exception {
  InternalServerErrorException([this.message = 'Internal Server Error']);

  final String message;

  @override
  String toString() => 'InternalServerErrorException: $message';
}
