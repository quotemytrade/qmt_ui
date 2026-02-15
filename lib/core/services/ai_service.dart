import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:quotemytrade/core/config/api_config.dart';
import 'package:quotemytrade/core/models/estimation.dart';

class AiService {
  final List<Map<String, dynamic>> _conversationHistory = [];

  AiService() {
    _initializeSystemPrompt();
  }

  void _initializeSystemPrompt() {
    _conversationHistory.add({
      "role": "system",
      "content": """
You are a professional trades estimator AI for QuoteMyTrade. Your estimates must be realistic for 2025.

For the initial query, generate a full detailed estimate.

For follow-up queries, ALWAYS recall and reference the previous estimate from history. ONLY modify the specific parts mentioned.

Respond ONLY in valid JSON with this EXACT structure (no Markdown, no extra text):

{
  "response_text": "Brief natural summary of the work. End exactly with: 'The estimated total cost is [CURRENCY][BASE_TOTAL].' Use the correct currency symbol.",
  "items": [
    {
      "category": "Materials or Labor",
      "description": "Single-line description without newlines",
      "quantity": 1,
      "unitCost": 2500.00,
      "totalCost": 2500.00
    }
  ],
  "assumptions": ["Assumption 1"],
  "suggestions": ["Cost-saving tip 1"]
}

CRITICAL RULES:
- Calculate base_total = exact sum of all item totalCost values.
- The response_text MUST end with the total cost statement.
- For India/Bangalore location: use INR currency and Indian market rates.
- Include 10-15 detailed items for trades work (electrical, plumbing, painting, masonry, etc.).
- Keep category and description on single lines.
""",
    });
  }

  Future<Map<String, dynamic>> sendMessage({
    required String text,
    Uint8List? imageBytes,
    String? locationHint,
    String sessionId = "default", // Add this
  }) async {
    try {
      final String pythonServiceUrl =
          "http://localhost:8000/estimate"; // Update with deployed URL

      final data = {
        'text': text,
        'locationHint': locationHint ?? '',
        'session_id': sessionId,
      };

      if (imageBytes != null) {
        final base64Image = base64Encode(imageBytes);
        data['image_b64'] = base64Image;
      }

      final response = await http.post(
        Uri.parse(pythonServiceUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      dynamic result;
      try {
        result = jsonDecode(response.body);
      } catch (_) {
        result = {'success': false, 'error': 'Invalid response from service'};
      }

      if (response.statusCode == 200 && result['success'] == true) {
        final estimation = Estimation.fromJson(result['estimation']);
        return {
          'success': true,
          'responseText': result['responseText'],
          'estimation': estimation,
        };
      }

      return {'success': false, 'error': result['error'] ?? 'Unknown error'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  String _extractCurrency(String text) {
    // Use Rs. instead of ₹ symbol to avoid encoding issues
    if (text.contains('Rs.') || text.contains('INR')) return 'Rs.';
    if (text.toLowerCase().contains('rupee')) return 'Rs.';
    if (text.contains('\$')) return '\$';
    if (text.contains('USD')) return '\$';
    return 'Rs.'; // Default to Rs. for India
  }

  void clearHistory() {
    _conversationHistory.clear();
    _initializeSystemPrompt();
  }
}
