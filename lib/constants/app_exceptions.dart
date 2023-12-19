class AppExceptions implements Exception {
  final dynamic message;
  final dynamic prefix;

  AppExceptions([this.message, this.prefix]);

  @override
  String toString() {
    return '$message $prefix';
  }
}

class InternetException extends AppExceptions {
  InternetException([String? message]) : super(message, 'No Internet');
}

class RequestTimeOut extends AppExceptions {
  RequestTimeOut([String? message]) : super(message, 'Request Time Out');
}

class ServerException extends AppExceptions {
  ServerException([String? message])
      : super(message, 'Internal Server Exception');
}

class InvalidUrlException extends AppExceptions {
  InvalidUrlException([String? message]) : super(message, 'Invalid Url');
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
      : super(message, 'Error while communication');
}

class NullException extends AppExceptions {
  NullException([String? message]) : super(message, 'Value found as null');
}
