import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpHelper {
  // TODO: Move to config file in future
  static String baseUrl = 'http://localhost';
  static String appUrl = '$baseUrl/api/masters-thesis';

  static Future<Map<String, dynamic>> get(String resource) async {
    try {
      var url = Uri.parse('$appUrl/$resource');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('GET request failed');
      }
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  static Future<Map<String, dynamic>> image(String resource, File img) async {
    try {
      var url = Uri.parse('$appUrl/$resource');
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', img.path));
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        String responseString = await streamedResponse.stream.bytesToString();
        return json.decode(responseString);
      } else {
        throw Exception('POST request failed');
      }
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  static Future<Map<String, dynamic>> put(String resource, Map<String, dynamic> data) async {
    try {
      var url = Uri.parse('$appUrl/$resource');
      var response = await http.put(url, body: json.encode(data));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('PUT request failed');
      }
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  static String getMediaURL(String filename) {
    return "$baseUrl/media/$filename";
  }
}
