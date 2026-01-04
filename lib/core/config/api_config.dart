import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Store your API key securely - consider using flutter_dotenv or secure storage
  static String get grokApiKey =>
      dotenv.env['grokApiKey'] ?? (throw Exception('GROK_API_KEY missing'));

  static const String grokApiUrl = 'https://api.x.ai/v1/chat/completions';
  static const String grokModel = 'grok-2-latest';
  static const String locationApiUrl = 'https://ipapi.co/json/';

  static const int maxTokens = 2048;
  static const double temperature = 0.1;
  static const int seed = 42;
}
