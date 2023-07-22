class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_message$_prefix";
  }
}

class FetchException extends AppException {
  FetchException([String? _message])
      : super(_message, "Error During Communication");
}

class BadRequestException extends AppException {
  BadRequestException([String? _message]) : super(_message, "Invalid Request");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? _message])
      : super(_message, "UnauthorizedException Request");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? _message])
      : super(_message, "InvalidInputException Request");
}
