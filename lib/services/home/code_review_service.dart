import 'package:code_review_and_analysis/services/api_service.dart';
import 'package:code_review_and_analysis/utils/enums/request_type.dart';
import 'package:code_review_and_analysis/utils/helper/responseModel/api_response.dart';
import 'package:code_review_and_analysis/utils/storage/device_utils.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CodeReviewService {
  final _apiService = Get.find<ApiService>();

  Future<ApiResponse> reviewCode({
    required String code,
    String? filePath,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final deviceId = await DeviceUtils.getorCreateDeviceId();
      final token = await DeviceUtils.getAppToken();
      final endPoint = '/api/user/review/code/review';

      if (filePath != null && filePath.isNotEmpty) {
        return await _apiService.uploadFile(
          endPoint,
          filePath,
          fields: code.trim().isEmpty ? null : {"code": code},
          headers: {'x-device-id': deviceId, 'Authorization': 'Bearer $token'},
          onSendProgress: onSendProgress,
        );
      }
      return await _apiService.request(
        RequestType.post,
        endPoint,
        data: {"code": code},
        headers: {'x-device-id': deviceId, 'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      return ApiResponse.failure(e.toString());
    }
  }
}
