import 'package:code_review_and_analysis/routes/app_route_path.dart';
import 'package:code_review_and_analysis/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class DioErrorHandler {
  static String handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final statusMessage = error.response?.statusMessage;

      switch (statusCode) {
        case 400:
          return "Bad Request: ${statusMessage ?? 'Invalid request parameters'}";
        case 401:
          return "Unauthorized: ${statusMessage ?? 'Authentication failed'}";
        case 403:
          if (error.response?.data['redirect'] != null) {
            appNavigatorKey.currentContext?.go(
              error.response?.data['redirect'],
            );
            return error.response?.data['error'];
          }
          return "Forbidden: ${statusMessage ?? 'Access denied'}";
        case 404:
          return "Not Found: ${statusMessage ?? 'Resource not found'}";
        case 500:
          return "Internal Server Error: ${statusMessage ?? 'Something went wrong on the server'}";
        default:
          return "Unexpected Error: $statusCode - ${statusMessage ?? 'Unknown error'}";
      }
    } else {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection Timeout: The connection timed out.";
        case DioExceptionType.sendTimeout:
          return "Send Timeout: Failed to send data.";
        case DioExceptionType.receiveTimeout:
          return "Receive Timeout: The server did not respond in time.";

        case DioExceptionType.cancel:
          return "Request was cancelled.";
        case DioExceptionType.unknown:
          return "Unknown error: ${error.message}";
        default:
          return "DioError: ${error.message}";
      }
    }
  }
}
