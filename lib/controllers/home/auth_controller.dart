import 'package:code_review_and_analysis/controllers/home/code_review_controller.dart';
import 'package:code_review_and_analysis/models/user_model.dart';
import 'package:code_review_and_analysis/routes/app_route_path.dart';
import 'package:code_review_and_analysis/routes/app_routes.dart';
import 'package:code_review_and_analysis/services/auth/auth_service.dart';
import 'package:code_review_and_analysis/utils/binding/app_dependency.dart';
import 'package:code_review_and_analysis/utils/helper/helper.dart';
import 'package:code_review_and_analysis/utils/storage/device_utils.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';

class AuthController extends GetxController {
  final _authService = AuthService();
  RxBool isloading = false.obs;
  RxString appToken = ''.obs;
  var userModel = UserModel().obs;
  final _codeReviewController = Get.find<CodeReviewController>();

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    isloading.value = true;
    final response = await _authService.registerNewUser(
      email: email,
      password: password,
    );

    if (response.statusCode == 201 && response.isSuccess) {
      Helper.toast(response.data['message']);
      isloading.value = false;
      appNavigatorKey.currentContext?.pushReplacement(
        AppRoutePath.loginPageRoute,
      );
    } else {
      Logger().e("Auth Error-> ${response.errorMessage}");
      Helper.toast(response.errorMessage['error'] ?? "Sign Up Failed.");
      isloading.value = false;
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    isloading.value = true;
    final response = await _authService.loginUser(
      email: email,
      password: password,
    );

    if (response.statusCode == 200 && response.isSuccess) {
      final data = response.data as Map<String, dynamic>;

      await DeviceUtils.storeAppToken(data['token']);

      appToken.value = data['token'];
      userModel.value = UserModel.fromMap(data);

      isloading.value = false;
      appNavigatorKey.currentContext?.go(AppRoutePath.homeRoute);
    } else {
      Logger().e("Auth Error-> ${response.errorMessage}");
      Helper.toast(response.errorMessage['error'] ?? "Sign In Failed.");
      isloading.value = false;
    }
  }

  Future<void> getCurrentUser() async {
    isloading.value = true;
    final response = await _authService.getCurrentUserData();

    if (response.statusCode == 200 && response.isSuccess) {
      final data = response.data as Map<String, dynamic>;

      final token = await DeviceUtils.getAppToken();

      if (token != null) {
        appToken.value = token;
      }

      userModel.value = UserModel.fromMap(data);
      isloading.value = false;
      _codeReviewController.chats.clear();
      appNavigatorKey.currentContext?.go(AppRoutePath.homeRoute);
    } else if ((response.statusCode == 401 || response.statusCode == 403) &&
        response.errorMessage['tokenExpired'] != null &&
        response.errorMessage['tokenExpired'] == true &&
        response.errorMessage['redirectRoute'] != null) {
      Helper.toast("Session Expired. Please login Again.");
      await logoutUser();
    } else {
      Logger().e("Auth Error-> ${response.errorMessage} ${response.message}");
      Helper.toast(response.errorMessage['error'] ?? "Cannot Fetch User Data");
      isloading.value = false;
      await logoutUser();
    }
  }

  Future<void> logoutUser() async {
    isloading.value = true;
    await Future.delayed(Duration(seconds: 2));

    await DeviceUtils.deleteAppToken();
    appToken.value = '';
    userModel.value = UserModel();
    await Get.deleteAll(force: true);
    AppDependency().dependencies();
    isloading.value = false;
    appNavigatorKey.currentContext?.go(AppRoutePath.homeRoute);
  }
}
