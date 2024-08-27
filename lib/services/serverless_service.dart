import 'dart:async';
import 'package:intl/intl.dart'; // Make sure to add this package to your pubspec.yaml
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ServerlessService {
  final String baseUrl =
      'https://d9cuoxk4x9.execute-api.ap-south-1.amazonaws.com/Prod';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String?> _getIdToken() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  Future<void> updateProfile(Map<String, dynamic> userData,
      {bool isNew = false}) async {
    try {
      userData['isNew'] = isNew;

      Map<String, dynamic> sanitizedUserData = userData.map((key, value) {
        if (value is DateTime) {
          return MapEntry(key, DateFormat('yyyy-MM-dd').format(value));
        }
        return MapEntry(key, value);
      });

      String? idToken = await _getIdToken();
      if (idToken == null) {
        throw Exception('User not authenticated');
      }

      print(json.encode(sanitizedUserData));

      final Uri uri = Uri.parse('$baseUrl/userProfile/');

      final response = await http
          .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode(sanitizedUserData),
      )
          .timeout(Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, please try again.');
      });

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to ${isNew ? 'create' : 'update'}: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error in updateProfile: $e');
      print('Stack trace: $stackTrace');
      rethrow; // Re-throw the exception after logging
    }
  }

  Future<bool> addToMatchQueue(Map<String, dynamic> userData) async {
    try {
      String? idToken = await _getIdToken();
      if (idToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/addToMatchQueue'),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*', // Allow all origins
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('error $e');
      return false;
    }
  }

  Future<void> removeFromMatchQueue() async {
    String? idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/removeFromMatchQueue'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*', // Allow all origins
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from match queue: ${response.body}');
    }
  }
}
