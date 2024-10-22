class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix: $_message";
  }
}

class InternetException extends AppExceptions {
  InternetException([String? message])
      : super(message, "No Internet Connection");
}

class RequestTimeOutException extends AppExceptions {
  RequestTimeOutException([String? message])
      : super(message, "Request Time Out");
}

class ServerException extends AppExceptions {
  ServerException([String? message]) : super(message, "Internal Server Error");
}

class InvalidUrlException extends AppExceptions {
  InvalidUrlException([String? message]) : super(message, "Invalid URL");
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
      : super(message, "Error During Communication");
}

class UnauthorisedException extends AppExceptions {
  UnauthorisedException([String? message]) : super(message, "Unauthorized");
}
