class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  final String? message;
  final bool isSuccess;
  final dynamic errorMessage;

  ApiResponse({
    this.data,
    this.statusCode,
    this.message,
    this.errorMessage,
    required this.isSuccess,
  });

  factory ApiResponse.success(T? data, int? statusCode, [String? message]) {
    return ApiResponse<T>(
      isSuccess: true,
      data: data,
      statusCode: statusCode,
      message: message,
    );
  }

  factory ApiResponse.failure(
    String? message, [
    int? statusCode,
    dynamic errorMessage,
  ]) {
    return ApiResponse<T>(
      isSuccess: false,
      data: null,
      statusCode: statusCode,
      message: message,
      errorMessage: errorMessage,
    );
  }
}
