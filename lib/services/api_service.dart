import 'package:code_review_and_analysis/utils/enums/request_type.dart';
import 'package:code_review_and_analysis/utils/env/enviroment.dart';
import 'package:code_review_and_analysis/utils/helper/error/dio_error_handler.dart';
import 'package:code_review_and_analysis/utils/helper/responseModel/api_response.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;
  final Logger _logger = Logger();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppEnviroment.baseUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 15),
        contentType: "application/json",
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i("Request-> ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i("Response-> ${response.data}");
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e("Error-> ${error.response?.data}");
          return handler.next(error);
        },
      ),
    );
  }

  Future<ApiResponse<T>> request<T>(
    RequestType requestType,
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    final option = Options(headers: headers, method: requestType.name);
    try {
      final response = await _dio.request<T>(
        endpoint,
        options: option,
        data: data,
        queryParameters: query,
      );

      return ApiResponse.success(
        response.data,
        response.statusCode,
        response.statusMessage,
      );
    } catch (error) {
      final message = DioErrorHandler.handleError(error as DioException);
      return ApiResponse.failure(
        message,
        error.response?.statusCode,
        error.response?.data ?? 'Something went wrong',
      );
    }
  }

  Future<ApiResponse> uploadFile(
    String endPoint,
    String? filePath, {
    Map<String, dynamic>? fields,
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final Map<String, dynamic> formMap = {};

      if (fields != null) {
        formMap.addAll(fields);
      }

      if (filePath != null && filePath.isNotEmpty) {
        final fileName = filePath.split('/').last;
        formMap['file'] = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formMap);
      Logger().i("formdata output-> ${formData.fields} ${formData.files}");

      final response = await _dio.post(
        endPoint,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(headers: headers, contentType: 'multipart/form-data'),
      );

      return ApiResponse.success(
        response.data,
        response.statusCode,
        response.statusMessage,
      );
    } catch (error) {
      final message = DioErrorHandler.handleError(error as DioException);
      return ApiResponse.failure(
        message,
        error.response?.statusCode,
        error.response?.data ?? 'Something went wrong',
      );
    }
  }
}
