enum Status { loading, success, error, none }

class ResponseHandler<T> {
  Status? status;
  T? data;
  String? message;
  dynamic errorCode;

  ResponseHandler();

  ResponseHandler.loading({this.message}) : status = Status.loading;
  ResponseHandler.success(this.data, {this.message}) : status = Status.success;
  ResponseHandler.error({this.message, this.errorCode}) : status = Status.error;
  ResponseHandler.none() : status = Status.none;
  @override
  String toString() {
    return 'ApiResponseHandler - Status : $status - Message : $message - Data : $data';
  }
}
