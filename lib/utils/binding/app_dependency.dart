import 'package:code_review_and_analysis/controllers/home/auth_controller.dart';
import 'package:code_review_and_analysis/controllers/home/code_review_controller.dart';
import 'package:code_review_and_analysis/services/api_service.dart';
import 'package:get/get.dart';

class AppDependency extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService());
    Get.lazyPut<CodeReviewController>(
      () => CodeReviewController(),
      fenix: true,
    );
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
