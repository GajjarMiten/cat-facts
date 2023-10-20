class HttpResult<T> {
  HttpResultStatus status;
  T? data;
  String message;

  HttpResult.loading(this.message) : status = HttpResultStatus.loading;
  HttpResult.completed(this.data,
      [this.status = HttpResultStatus.completed, this.message = 'Success']);
  HttpResult.error([String? message])
      : status = HttpResultStatus.error,
        message = message ?? "";

  bool get hasError => status == HttpResultStatus.error && message.isNotEmpty;
  bool get hasData => status == HttpResultStatus.completed && data != null;

  bool get isNull => data == null;

  bool get isNotNull => !isNull;

  bool get isEmpty {
    if (isNull) return true;

    if (data is List) {
      return (data as List).isEmpty;
    }
    if (data is Map) {
      return (data as Map).isEmpty;
    }

    return data.toString().trim().isEmpty;
  }

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum HttpResultStatus { loading, completed, error }
