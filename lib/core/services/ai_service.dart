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
  }) async {
    try {
      List<Map<String, dynamic>> content = [];

      final String fullText = locationHint != null
          ? "$locationHint\n\n$text"
          : text;

      content.add({"type": "text", "text": fullText});

      if (imageBytes != null) {
        final base64Image = base64Encode(imageBytes);
        content.add({
          "type": "image_url",
          "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
        });
      }

      final List<Map<String, dynamic>> messages = List.from(
        _conversationHistory,
      );
      messages.add({"role": "user", "content": content});

      final body = jsonEncode({
        "model": ApiConfig.grokModel,
        "messages": messages,
        "max_tokens": ApiConfig.maxTokens,
        "temperature": ApiConfig.temperature,
        "seed": ApiConfig.seed,
      });

      final response = await http.post(
        Uri.parse(ApiConfig.grokApiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer ${ApiConfig.grokApiKey}',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final jsonString = data['choices'][0]['message']['content'] as String;

        print("Raw AI Response:\n$jsonString");

        final Map<String, dynamic> parsed = jsonDecode(jsonString);
        String responseText =
            parsed['response_text'] ?? "Here's your detailed estimate:";

        final estimation = Estimation.fromJson(parsed);

        // Calculate ±5% range
        double baseTotal = estimation.totalCost;
        double low = (baseTotal * 0.95 / 100).round() * 100;
        double high = (baseTotal * 1.05 / 100).round() * 100;

        String currencySymbol = _extractCurrency(responseText);
        String rangeText =
            "The estimated total cost is $currencySymbol${low.toStringAsFixed(0)} to $currencySymbol${high.toStringAsFixed(0)} (±5% variance).";

        if (responseText.contains("The estimated total cost is")) {
          responseText = responseText.replaceAll(
            RegExp(r'The estimated total cost is[^.]*\.'),
            rangeText,
          );
        } else {
          responseText += "\n\n$rangeText";
        }

        // Add to conversation history
        _conversationHistory.add({"role": "user", "content": text});
        _conversationHistory.add({
          "role": "assistant",
          "content": responseText,
        });

        return {
          'success': true,
          'responseText': responseText,
          'estimation': estimation,
        };
      } else {
        return {
          'success': false,
          'error': 'API Error: ${response.statusCode}\n${response.body}',
        };
      }
    } catch (e) {
      print("AI Service Error: $e");
      return {
        'success': false,
        'error': 'Failed to get response. Please try again.',
      };
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
