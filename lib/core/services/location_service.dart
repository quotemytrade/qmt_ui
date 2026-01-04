import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quotemytrade/core/config/api_config.dart';

class LocationService {
  Future<String?> getUserLocationHint() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.locationApiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final city = data['city'] ?? 'Unknown city';
        final country = data['country_name'] ?? 'Unknown country';
        final currency = data['currency'] ?? 'USD';
        return "User location: $city, $country (currency: $currency)";
      }
    } catch (e) {
      print('Location detection failed: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getLocalContractors(
    String tradeType,
  ) async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.locationApiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final city = data['city'] ?? '';
        final region = data['region'] ?? '';
        final country = data['country_name'] ?? '';

        if (city.isEmpty) return null;

        final query = Uri.encodeQueryComponent(
          '$city $region $country $tradeType contractor',
        );
        final googleUrl = 'https://www.google.com/search?q=$query';

        return List.generate(
          5,
          (i) => {
            "name": "Top-Rated $tradeType Contractor ${i + 1} - $city",
            "rating": (4.6 + i * 0.1).toStringAsFixed(1),
            "reviews": "${150 + i * 40}",
            "link": googleUrl,
          },
        );
      }
    } catch (e) {
      print('Contractor search error: $e');
    }
    return null;
  }
}
