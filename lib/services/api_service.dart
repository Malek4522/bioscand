import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static String get baseUrl => dotenv.env['URL'] ?? '';

  /// Predicts plant health based on environmental data
  /// Returns: {'prediction': 'Healthy'/'High Stress'/'Moderate Stress'}
  static Future<Map<String, dynamic>> predictEnvironmentalHealth(
    Map<String, dynamic> environmentalData,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/env');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(environmentalData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to predict environmental health: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error calling environmental health API: $e');
    }
  }

  /// Predicts plant disease from image
  /// Returns: {
  ///   "success": true,
  ///   "plant": plant_type,
  ///   "predicted_class": predicted_class,
  ///   "confidence": confidence
  /// }
  static Future<Map<String, dynamic>> predictPlantDisease(
    String plantType,
    String imagePath,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/predict/$plantType');
      print('DEBUG: Calling plant disease API at: $url');
      print('DEBUG: Plant type: $plantType');
      print('DEBUG: Image path: $imagePath');

      var request = http.MultipartRequest('POST', url);

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imagePath,
          contentType: MediaType('image', 'jpg'),
        ),
      );
      print('DEBUG: Sending multipart request with image');

      final streamedResponse = await request.send();
      print('DEBUG: Got response with status: ${streamedResponse.statusCode}');

      final response = await http.Response.fromStream(streamedResponse);
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to predict plant disease: ${response.statusCode} - URL: $url - Response: ${response.body}',
        );
      }
    } catch (e) {
      print('DEBUG: Error in predictPlantDisease: $e');
      throw Exception('Error calling plant disease API: $e');
    }
  }

  /// Gets treatment recommendations from LLM
  /// Returns: {"medicine": "...", "dosage": "..."}
  static Future<Map<String, dynamic>> getTreatmentRecommendations(
    String message,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/plant-treatment');
      print('DEBUG: Calling treatment API at: $url');
      print('DEBUG: Message: $message');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      print('DEBUG: Treatment API response status: ${response.statusCode}');
      print('DEBUG: Treatment API response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to get treatment recommendations: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('DEBUG: Error in getTreatmentRecommendations: $e');
      throw Exception('Error calling treatment API: $e');
    }
  }
}
