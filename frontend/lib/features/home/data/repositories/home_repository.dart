import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:witnessed_art/features/home/data/models/user_state_model.dart';

class HomeRepository {
  final String baseUrl =
      dotenv.env['API_URL'] ?? "http://localhost:8000/api/v1";

  // In a real app, this would be injected or fetched from a secure storage
  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  Future<UserStateModel> initUser(String timezone) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/init"),
      headers: {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        'X-Idempotency-Key': 'init-${DateTime.now().millisecondsSinceEpoch}',
      },
      body: jsonEncode({'timezone': timezone}),
    );

    if (response.statusCode == 200) {
      return UserStateModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to initialize user: ${response.body}");
    }
  }

  Future<ProgressResponseModel> triggerProgress() async {
    final response = await http.post(
      Uri.parse("$baseUrl/progress"),
      headers: {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        'X-Idempotency-Key': 'prog-${DateTime.now().millisecondsSinceEpoch}',
      },
      body: jsonEncode(
          {'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000}),
    );

    if (response.statusCode == 200) {
      return ProgressResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to progress: ${response.body}");
    }
  }

  Future<void> resetUser() async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/reset"),
      headers: {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        'X-Idempotency-Key': 'reset-${DateTime.now().millisecondsSinceEpoch}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to reset: ${response.body}");
    }
  }

  Future<void> saveImage() async {
    final response = await http.post(
      Uri.parse("$baseUrl/saved-images/save"),
      headers: {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        'X-Idempotency-Key': 'save-${DateTime.now().millisecondsSinceEpoch}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to save: ${response.body}");
    }
  }

  Future<List<dynamic>> listSavedImages() async {
    final response = await http.get(
      Uri.parse("$baseUrl/saved-images/"),
      headers: {
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to fetch gallery: ${response.body}");
    }
  }
}
