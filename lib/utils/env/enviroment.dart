import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnviroment {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  static final String deviceId = dotenv.env['DEVICE_ID'] ?? '';
  static final String appToken = dotenv.env['APP_TOKEN'] ?? '';
}
