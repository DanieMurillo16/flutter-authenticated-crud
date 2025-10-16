import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnviroment() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiurl = dotenv.env['API_URL'] ?? 'Sin api';
}
