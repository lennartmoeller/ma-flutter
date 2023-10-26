import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpHelper {
  // TODO: Move to config file in future
  static String baseUrl = 'http://localhost/api/masters-thesis';

  static Future<Map<String, dynamic>> get(String resource) async {
    try {
      var url = Uri.parse('$baseUrl/$resource');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (e) {
      throw Exception('Failed to load data from the API: $e');
    }
  }
}
