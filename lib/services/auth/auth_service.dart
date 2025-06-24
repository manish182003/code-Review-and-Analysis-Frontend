import 'package:code_review_and_analysis/services/api_service.dart';
import 'package:code_review_and_analysis/utils/enums/request_type.dart';
import 'package:code_review_and_analysis/utils/helper/responseModel/api_response.dart';
import 'package:code_review_and_analysis/utils/storage/device_utils.dart';

import 'package:get/get.dart';

class AuthService {
  final _apiService = Get.find<ApiService>();

  Future<ApiResponse> registerNewUser({
    required String email,
    required String password,
  }) async {
    try {
      return await _apiService.request(
        RequestType.post,
        '/api/auth/register',
        data: {"email": email, "password": password},
      );
    } catch (e) {
      return ApiResponse.failure(e.toString());
    }
  }

  Future<ApiResponse> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      return await _apiService.request(
        RequestType.post,
        '/api/auth/login',
        data: {"email": email, "password": password},
      );
    } catch (e) {
      return ApiResponse.failure(e.toString());
    }
  }

  Future<ApiResponse> getCurrentUserData() async {
    try {
      final deviceId = await DeviceUtils.getorCreateDeviceId();
      final token = await DeviceUtils.getAppToken();

      return await _apiService.request(
        RequestType.get,
        '/api/auth/user/get-data',
        headers: {'x-device-id': deviceId, 'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      return ApiResponse.failure(e.toString());
    }
  }
}
