// class CustomException implements Exception {
//   final _message;
//   final _prefix;
//
//   CustomException([this._message, this._prefix]);
//
//   @override
//   String toString() {
//     return "API-ERROR: $_prefix$_message";
//   }
// }

// class FetchDataException extends CustomException {
//   FetchDataException([message]) : super(message, "Error During Communication: ");
// }
//
// class BadRequestException extends CustomException {
//   BadRequestException([message]) : super(message, "Invalid Request: ");
// }
//
// class RequestNotFoundException extends CustomException {
//   RequestNotFoundException([message]) : super(message, "Not Found Request: ");
// }
//
// class UnauthorisedException extends CustomException {
//   UnauthorisedException([message]) : super(message, "Unauthorised: ");
// }
//
// class RequestTimeoutException extends CustomException {
//   RequestTimeoutException([message]) : super(message, "Request Timeout: ");
// }
//
// class InvalidInputException extends CustomException {
//   InvalidInputException([message]) : super(message, "Invalid Input: ");
// }
//
// class InternalServerException extends CustomException {
//   InternalServerException([message]) : super(message, "Internal Server Error: ");
// }
